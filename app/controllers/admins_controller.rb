class AdminsController < ApplicationController
  before_action :authenticate_admin!


  def dashboard
    @owners = Owner.all
    @contact_messages = ContactMessage.all
  end
end