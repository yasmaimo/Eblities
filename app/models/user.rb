class User < ApplicationRecord
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

  validates :user_name,
    presence: true,
    format: { with: /\A[a-zA-Z_`_]+\z/,
    					message: "半角の英語とアンダースコア _ のみ使用できます" }

  validates :introduction,
  	length: { maximum: 150 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
  	presence: true,
  	uniqueness: true,
    format: { with: VALID_EMAIL_REGEX,
      				message: "記入内容を確認して下さい" }

  validates :member_status,
  	presence: true,
    format: { with: /\A\d\z/, # 0 => 入会、1 => 退会済み、2 => 強制退会
      				message: "半角数字で入力して下さい。" }

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

  # Association
  # has_many :social_profiles # order belongs_to user
  # has_many :relationships # taggings has_many users
  # has_many :articles # taggings belongs_to user
  # has_many :drafts # taggings has_many users
  # has_many :comments, dependent: :destroy # taggings has_many users
  # has_many :favorites, dependent: :destroy # taggings has_many users
  # has_many :keeps, dependent: :destroy # taggings has_many users
  # has_many :taggings, dependent: :destroy # taggings has_many users

end
