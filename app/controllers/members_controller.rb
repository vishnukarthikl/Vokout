class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    if facility_id
      @members = Member.eager_load(subscriptions: :membership).find(facility_id: facility_id)
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
    @facility = Facility.find(facility_id)
    @member = @facility.members.build(member_params)
    subscription = subscription_for(subscription_params, @member)

    respond_to do |format|
      if @member.save
        subscription.save if subscription
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
      newSubscription = renewedSubscription(@member)
      if @member.update(member_params)
        newSubscription.save if newSubscription
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def renewedSubscription(member)
    params.require(:subscriptions).each do |subscription|
      unless subscription[:id]
        membership = Membership.find(subscription[:membership_id])
        return Subscription.new({member: member, membership: membership, start_date: subscription[:start_date]})
      end
    end
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

  def member_params
    params.require(:member).permit([:name, :email, :phone_number, :is_male, :date_of_birth, :occupation, :address, :pincode, :emergency_number, :facility_id])
  end

  def subscription_params
    params.require(:subscription).permit([:membership_id, :start_date])
  end

  def facility_id
    params[:facility_id]
  end
end
