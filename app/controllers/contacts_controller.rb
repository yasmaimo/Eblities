class ContactsController < ApplicationController
  def index
  end

  def confirm
  end

  def create
  end

  def new
  end

  def sent
  end

  def update
  end





  private

  def contact_params
    params.require(:contact).permit(:title, :email, :contact, :status)
  end

end
