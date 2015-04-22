class ContactMessagesController < ApplicationController
  before_action :set_contact_message, only: [:destroy]
  before_action :authenticate_admin!, only: [:index, :destroy]
  respond_to :html

  def index
    @contact_messages = ContactMessage.all
    respond_with(@contact_messages)
  end

  def new
    @contact_message = ContactMessage.new
    respond_with(@contact_message)
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)
    if @contact_message.save
      flash[:success] = 'Your message has been received, We will get back to you shortly'
      redirect_to contact_path
    else
      render :new
    end

  end

  def destroy
    @contact_message.destroy
    redirect_to :back, notice: 'Message was deleted'
  end

  private
  def set_contact_message
    @contact_message = ContactMessage.find(params[:id])
  end

  def contact_message_params
    params.require(:contact_message).permit(:id, :name, :email, :phone, :message)
  end
end
