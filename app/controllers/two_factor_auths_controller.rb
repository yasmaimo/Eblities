class TwoFactorAuthsController < ApplicationController

  before_action :authenticate_user

  def new
    unless current_user.otp_secret
      current_user.otp_secret = User.generate_otp_secret(32)
      current_user.save!
    end

    @qr_code = build_qr_code
  end

  def create
    if current_user.validate_and_consume_otp!(params[:otp_attempt])
      current_user.otp_required_for_login = true
      @codes = current_user.generate_otp_backup_codes!
      current_user.save!
      render 'codes'
    else
      @error = 'コードが違います'
      @qr_code = build_qr_code
      render 'new'
    end
  end

  def destroy
    current_user.update_attributes(
      otp_required_for_login:    false,
      encrypted_otp_secret:      nil,
      encrypted_otp_secret_iv:   nil,
      encrypted_otp_secret_salt: nil,
    )
    redirect_to user_two_factor_authentication_path(current_user)
  end





  private

  def build_qr_code
    RQRCode::render_qrcode(
      current_user.otp_provisioning_uri(current_user.email, issuer: "Eblities"),
      :svg,
      level: :l,
      unit: 2
    )
  end

end
