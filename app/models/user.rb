class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

  validates :family_name,
    format: { with: /\A[ぁ-んァ-ン一-龥a-zA-Z]+\z/,
              message: "全角の日本語か半角の英語で入力して下さい" },
    on: :update,
    allow_blank: true

  validates :given_name,
    format: { with: /\A[ぁ-んァ-ン一-龥a-zA-Z]+\z/,
              message: "全角の日本語か半角の英語で入力して下さい" },
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
    params.delete(:current_password)

    if params[:password].blank?
     params.delete(:password)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  # Association
  has_many :social_profiles
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships
  has_many :articles
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :keeps, dependent: :destroy

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
