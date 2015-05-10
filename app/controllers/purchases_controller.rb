class PurchasesController < ApplicationController
  before_action :set_entities, only:  [:create]
  respond_to :json


  def show
  end

  def create
    @purchase = @member.purchases.create(purchase_params)
    if @purchase.save
      @purchase.create_revenue({value: @purchase.cost,
                     date: @purchase.date,
                     member: @member,
                     facility: @facility})

      @member.reload
      render :show, status: :created, location: member_purchase_url(@member,@purchase)
    else
      render json: @purchase.errors, status: :unprocessable_entity
    end
  end

  # todo: add update and delete

  private
  def set_entities
    @owner = current_owner
    @facility = @owner.facility
    @member = Member.find(params[:member_id])
  end


  def purchase_params
    params.permit([:name, :cost, :purchase_type, :date])
  end
end
