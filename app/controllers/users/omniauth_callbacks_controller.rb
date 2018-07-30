class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # prepend_before_action :check_captcha, only: [:facebook][:twitter][:google]

  # callback for facebook
  def facebook
    callback_for(:facebook)
  end

  # callback for twitter
  def twitter
    callback_for(:twitter)
  end

  # callback for google
  def google_oauth2
    callback_for(:google)
  end

  # common callback method
  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      if @user.otp_required_for_login == true
        authenticate_with_two_factor
      else
        flash[:sign_in_succeeded] = "ログインしました"
        sign_in_and_redirect @user, event: :authentication
        # set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
      end
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
      flash[:sign_up_succeeded] = "登録が完了しました。ようこそEblitiesへ！"
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def authenticate_with_two_factor
    # self.resource = @user
    session[:otp_user_id] = @user.id
    render 'users/sessions/two_factor' and return
  end

  # reCAPTCHA_validation
  # def check_captcha
  #   self.resource = resource_class.new sign_up_params
  #   resource.validate
  #   unless verify_recaptcha(model: resource)
  #     respond_with_navigational(resource) { render :new }
  #   end
  # end

end