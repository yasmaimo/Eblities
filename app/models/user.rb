class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attachment :image

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

  validates :user_name,
    presence: true,
    length: { maximum: 16,
              message: "タイトルは最大500文字まで入力できます" },
    format: { with: /\A[a-zA-Z_`_]+\z/,
              message: "半角の英語とアンダースコア _ のみ使用できます" },
    on: :update,
    allow_blank: true

  validates :introduction,
    length: { maximum: 150,
              message: "自己紹介は最大150文字まで入力できます" },
    on: :update,
    allow_blank: true

  validates :status,
    presence: true,
    format: { with: /\A\d[0-2]\z/,
              message: "無効な入力です" },
    on: :update

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
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :articles, through: :comments,
                      through: :favorites,
                      through: :keeps,
                      through: :taggings
  has_many :comments
  has_many :favorites
  has_many :keeps
  has_many :taggings

end
