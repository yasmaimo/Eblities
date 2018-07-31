class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attachment :image

  # Validatoin
  validates :family_name,
    format: { with: /\A[ぁ-んァ-ン一-龥a-zA-Z]+\z/,
      				message: "全角の日本語か半角の英語で入力して下さい" }

  validates :given_name,
    format: { with: /\A[ぁ-んァ-ン一-龥a-zA-Z]+\z/,
							message: "全角の日本語か半角の英語で入力して下さい" }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
  	presence: true,
  	uniqueness: true,
    format: { with: VALID_EMAIL_REGEX,
      				message: "記入内容を確認して下さい" }

  validates :is_main_administer,
  	inclusion: { in: [true, false] },
    default: false

  validates :is_deleted,
	  inclusion: { in: [true, false] },
		default: false

  # Validatoin on create
  validates :password,
  	presence: true,
    length: { in: 6..20,
      				message: "6〜20文字までのパスワードを入力してください" },
    on: :create

  # Validation on update
  validates :password,
    length: { in: 6..20,
              message: "6〜20文字までのパスワードを入力してください" },
    on: :update,
    allow_blank: true

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank?
     params.delete(:password)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end
