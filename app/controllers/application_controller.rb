class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search
  before_action :unread_notification_exists?

  def after_sign_in_path_for(resource)
		root_path
  end

  def after_sing_out_path_for(resource)
  	root_path
  end

  def set_search
    @search = Article.ransack(params[:q])
    @articles = @search.result.page(params[:page]).reverse_order
  end

  def unread_notification_exists?
    if user_signed_in?
      if @unread_notifications = current_user.notifications.where(read: false)
        if @unread_notifications.count > 0
          flash[:unread_notification] = "未読の通知が#{@unread_notifications.count}件あります"
          @flash_notification = flash[:unread_notification]
        end
      end
    end
  end

  def authenticate_user
    redirect_to root_path unless user_signed_in?
  end

  def get_controller_and_action_name
    controller_name = controller_name
    action_name = action_name
  end

  def add_five_point
    ep = current_user.point
    ep += 5
    current_user.update(point: ep)
  end

  def subtract_any_point
    ep = current_user.point
    ep = ep - 5 - @article.favorites.count - @article.keeps.count
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
