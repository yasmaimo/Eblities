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

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys:[:user_name])
		devise_parameter_sanitizer.permit(:sing_in, keys:[:user_name])
	end
end
