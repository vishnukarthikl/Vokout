class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :set_facility, only: [:new, :create, :update]

  def index
    if facility_id
      @members = Member.eager_load(subscriptions: :membership).where({facility_id: facility_id})
    else
      @members = Member.eager_load(subscriptions: :membership).all
    end
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
      if @member.update(member_params) && update_latest_subscription_and_revenue()
        new_subscription.save if new_subscription
        revenue_for_renewal.save if revenue_for_renewal
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_latest_subscription_and_revenue
    latest_subscription = params.require(:latest_subscription)
    found_subscription = Subscription.find(latest_subscription[:id])
    membership = latest_subscription.require(:membership)
    found_subscription.update({start_date: latest_subscription[:start_date], membership_id: membership[:id]})
    found_subscription.revenue.update({value: found_subscription.membership.cost, date: found_subscription.start_date})
    @member.reload
  end


  def renewed_subscription(member)
    params.require(:subscriptions).each do |subscription|
      unless subscription[:id]
        membership = Membership.find(subscription[:membership_id])
        return Subscription.new({member: member, membership: membership, start_date: subscription[:start_date]})
      end
    end
    nil
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
    @member = Member.includes(subscriptions: :membership).find(params[:id])
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
    params[:facility_id]
  end

end
