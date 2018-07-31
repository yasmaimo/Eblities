# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :authenticate_with_two_factor, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if warden.authenticate?(auth_options)
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      yield resource if block_given?
      flash[:flash_message] = "ログインしました"
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash[:sign_in_failed] = "メールアドレスかパスワードが違います"
      redirect_to new_user_session_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:flash_message] = "ログアウトしました" if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def authenticate_with_two_factor
    user_params = params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)
    if user_params[:email]
      user = User.find_by(email: user_params[:email])
    elsif user_params[:otp_attempt].present? && session[:otp_user_id]
      user = User.find(session[:otp_user_id])
    end
    self.resource = user
    return unless user && user.otp_required_for_login
    if user_params[:email]
      if user.valid_password?(user_params[:password])
        session[:otp_user_id] = user.id
        render 'users/sessions/two_factor' and return
      end
    elsif user_params[:otp_attempt].present? && session[:otp_user_id]
      if user.validate_and_consume_otp!(user_params[:otp_attempt])
        session.delete(:otp_user_id)
        flash[:flash_message] = "ログインしました"
        sign_in(user) and return
      else
        flash.now[:alert] = '認証コードが違います'
        render :two_factor and return
      end
    end
  end

  def valid_otp_attempt?(user)
    user.validate_and_consume_otp!(user_params[:otp_attempt]) ||
    user.invalidate_otp_backup_code!(user_params[:otp_attempt])
  end

end
