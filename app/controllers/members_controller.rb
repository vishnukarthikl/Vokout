class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :set_facility, only: [:new, :create, :update]
  before_filter :authenticate

  def index
    @members = Member.eager_load(subscriptions: :membership).where({facility_id: facility_id})
  end

  def show
  end

  def new
    @member = Member.new
  end

  def edit
  end

  def create
    @member = @facility.members.build(member_params)
    subscription = subscription_for(subscription_params, @member)
    revenue = revenue_form(subscription)

    respond_to do |format|
      if @member.save
        subscription.save if subscription
        revenue.save if revenue
        @member.added_lost_histories.create({is_lost: false, since: subscription.start_date})
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end


  def subscription_for(subscription_params, member)
    membership = Membership.find(subscription_params[:membership_id])
    Subscription.new({member: member, membership: membership, start_date: subscription_params[:start_date]})
  end

  def update
    respond_to do |format|
      new_subscription = renewed_subscription(@member)
      revenue_for_renewal = revenue_form(new_subscription) if new_subscription
      previous_status = @member.inactive
      if @member.update(member_params) && update_latest_subscription_and_revenue()
        update_added_lost(@member, previous_status)
        if new_subscription
          new_subscription.save
          new_subscription.create_audit_log(facility: @member.facility, date: new_subscription.start_date, description: 'renewed')
        end
        revenue_for_renewal.save if revenue_for_renewal
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  LOST_DAYS_THRESHOLD = 21.days

  def update_added_lost(member, previously_inactive)
    if !previously_inactive and member.inactive
      member.added_lost_histories.create({is_lost: true, since: member.latest_subscription.end_date})
      member.audit_logs.create(facility: member.facility, date: DateTime.now, description: 'deactivated')
    elsif previously_inactive and !member.inactive
      latest_history = member.added_lost_histories.order(:since).order(:created_at).last
      member.audit_logs.create(facility: member.facility, date: DateTime.now, description: 'activated')
      if latest_history.is_lost and latest_history.since < LOST_DAYS_THRESHOLD.ago
        member.added_lost_histories.create({is_lost: false, since: Date.today})
      elsif latest_history.is_lost
        latest_history.delete
      end
    end
  end


  def update_latest_subscription_and_revenue
    latest_subscription = params.require(:latest_subscription)
    found_subscription = Subscription.find(latest_subscription[:id])
    membership = latest_subscription.require(:membership)
    update_params = {
        start_date: latest_subscription[:start_date],
        membership_id: membership[:id],
        extended_till: latest_subscription[:extended_till]
    }
    found_subscription.update(update_params)
    found_subscription.revenue.update({value: found_subscription.membership.cost, date: found_subscription.start_date})
    if latest_subscription[:extended_till]
      found_subscription.create_audit_log(facility: @member.facility, date: DateTime.now, description: 'extended')
    end
    @member.reload
  end


  def renewed_subscription(member)
    newsubscription = nil
    params.require(:subscriptions).each do |subscription|
      if !subscription[:id]
        latest_subscription = member.latest_subscription
        if latest_subscription
          latest_subscription.inactive = true
          latest_subscription.save
        end
        membership = Membership.find(subscription[:membership_id])
        newsubscription = Subscription.new({member: member, membership: membership, start_date: subscription[:start_date]})
      end
    end
    newsubscription
  end

  def revenue_form(subscription)
    revenue_date = if subscription.start_date > Date.today then
                     Date.today
                   else
                     subscription.start_date
                   end
    subscription.build_revenue({value: subscription.membership.cost,
                                date: revenue_date,
                                member: @member,
                                facility: @facility})
  end


  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Member was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  def set_member
    @member = Member.includes(subscriptions: :membership).where({id: params[:id], facility_id: facility_id}).first
  end

  private
  def set_facility
    @facility = Facility.find(facility_id)
  end

  def member_params
    params.require(:member).permit([:name, :email, :phone_number, :is_male, :inactive, :date_of_birth, :occupation, :address, :pincode, :emergency_number, :facility_id])
  end

  def subscription_params
    params.require(:subscription).permit([:membership_id, :start_date])
  end

  def facility_id
    current_owner.facility.id
  end

end
