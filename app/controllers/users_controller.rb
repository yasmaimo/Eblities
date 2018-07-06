class UsersController < ApplicationController
  def index
  end

  def show
  end

  def account
  end

  def password
  end

  def profile
  end

  def two_factor_authentication
  end

  def two_factor_authentication_setting
  end

  def unsubscribe_confirm
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:family_name, :given_name, :user_name, :introduction, :user_url, :image_id, :email, :password, :status)
  end

end
