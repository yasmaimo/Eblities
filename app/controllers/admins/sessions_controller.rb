# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if admin = Admin.find_by(email: params[:admin][:email])
      if admin.is_deleted == true
        redirect_to new_admin_session_path
        flash[:failed] = "停止中の管理者アカウントです。アカウントを復旧するにはメイン管理者に連絡を取ってください。"
      else
        super
      end
    else
      redirect_to new_admin_session_path
      flash[:failed] = "入力内容を確認してください。"
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
