class AdminsController < ApplicationController
  def index
  end

  def show
  end

  def password
  end

  def profile
  end

  def two_factor_authentication
  end

  def two_factor_authentication_setting
  end

  def update
  end

  private

  def admin_params
    params.require(:admin).permit(:family_name, :given_name, :image_id, :email, :password, :is_deleted)
  end

end
