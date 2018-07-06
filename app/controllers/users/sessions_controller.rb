# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if user = User.find_by(email: params[:user][:email])
      if user.status == 1
        redirect_to new_user_session_path
        flash[:failed] = "退会済みのアカウントです。"
      elsif user.status == 2
        redirect_to new_user_session_path
        flash[:failed] = "このアカウントは管理者によって強制退会となったため、ご利用いただけません。"
      else
        super
      end
    else
      redirect_to new_user_session_path
      flash[:failed] = "入力内容を確認してください"
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
