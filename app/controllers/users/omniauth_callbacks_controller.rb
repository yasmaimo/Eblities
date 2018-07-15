class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

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
        sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
      end
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
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

  def valid_otp_attempt?(user)
    user.validate_and_consume_otp!(params[:otp_attempt]) ||
    user.invalidate_otp_backup_code!(params[:otp_attempt]) # この条件を追加
  end


end