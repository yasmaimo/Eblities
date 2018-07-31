# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  prepend_before_action :check_captcha, only: [:create]
  prepend_before_action :customize_sign_up_params, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save

      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          flash[:flash_message] = "ご登録ありがとうございます！Eblitiesからあなたへのご挨拶を送りました。右上の通知ボタンからご覧いただけます。"
          Notification.create(user_id: current_user.id, notified_type: "サインアップ")
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end

    else

      flash.now[:sign_up_failed] = "入力内容を確認してください"
      render :new

    end

    # resource = User.new(customize_sign_up_params)
    # if User.find_by(params[:user][:email])
    #   flash.now[:sign_up_failed] = "すでに使用されているメールアドレスです"
    #   render :new
    #   return
    # elsif resource.invalid?
    #   flash.now[:sign_up_failed] = "入力内容を確認してください"
    #   render :new
    #   return
    # else
    #   super
    # end
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

  private

  def customize_sign_up_params
    devise_parameter_sanitizer.permit :sign_up, keys: [:user_name, :email, :password, :password_confirmation, :remember_me]
  end

  # reCAPTCHA_validation
  def check_captcha
    self.resource = resource_class.new sign_up_params
    resource.validate
    unless verify_recaptcha(model: resource)
      flash.now[:verify_failed] = "reCAPTCHA認証に失敗しました"
      respond_with_navigational(resource) { render :new }
    end
  end

end
