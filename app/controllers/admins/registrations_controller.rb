# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :require_no_authentication, only: :cancel
  prepend_before_action :authenticate_scope!, only: %i[new create]

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @resource = Admin.new
    if admin_signed_in?
      if current_admin.is_main_administer == true
        super
      else
        redirect_to admins_path
      end
    else
      redirect_to admins_path
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?

          original_admin = current_admin
          sign_up(resource_name, resource)
          Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
          sign_in(resource_name, original_admin)

          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
        redirect_to new_admin_registration_path
        flash[:failed] = "入力内容を確認してください"
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

  def update_resource(resource, params)
   resource.update_without_current_password(params)
  end

end
