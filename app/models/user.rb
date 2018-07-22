class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]

  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['ENCRYPTION_KEY']

  devise :two_factor_backupable, otp_number_of_backup_codes: 10

  serialize :otp_backup_codes, JSON

  attachment :image

  acts_as_taggable

  # Validatoin
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
  	presence: true,
  	uniqueness: true,
    format: { with: VALID_EMAIL_REGEX,
      				message: "メールアドレスの記入内容を確認して下さい" }

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

  validates :introduction,
    length: { maximum: 150,
              message: "自己紹介は最大150文字まで入力できます" },
    on: :update,
    allow_blank: true

  # validates :status,
  #   presence: true,
  #   format: { with: /\A\d[0-2]\z/,
  #             message: "無効な入力です" },
  #   on: :update

  def update_without_current_password(params, *options)
    if action_name != "password"
      params.delete(:current_password)

      if params[:password].blank?
       params.delete(:password)
      end

      result = update_attributes(params, *options)
      clean_up_passwords
      result
    end
  end

  # Association
  # has_many :social_profiles, dependent: :destroy
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships
  has_many :articles
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :keeps, dependent: :destroy
  has_many :tagging, as: :taggable
  has_many :notifications, dependent: :destroy

  # omniauth_callback
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.user_name = auth.info.name
      # user.image_url = auth.info.image
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end

end
