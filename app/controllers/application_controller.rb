class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search

  def after_sign_in_path_for(resource)
		root_path
  end

  def after_sing_out_path_for(resource)
  	root_path
  end

  # ransack用
  def set_search
    @search = Article.ransack(params[:q])
    @articles = @search.result.page(params[:page]).reverse_order
  end

  def authenticate_user
    redirect_to root_path unless user_signed_in?
  end

  def add_five_point
    ep = current_user.point
    ep += 5
    current_user.update(point: ep)
  end

  def subtract_five_point
    ep = current_user.point
    ep -= 5
    current_user.update(point: ep)
  end

  def add_two_point
    ep = @user.point
    ep += 2
    @user.update(point: ep)
  end

  def subtract_two_point
    ep = @user.point
    ep -= 2
    @user.update(point: ep)
  end

  def add_one_point
    ep = @user.point
    ep += 1
    @user.update(point: ep)
  end

  def subtract_one_point
    ep = @user.point
    ep -= 1
    @user.update(point: ep)
  end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys:[:user_name])
		devise_parameter_sanitizer.permit(:sing_in, keys:[:otp_attempt])
	end

end
