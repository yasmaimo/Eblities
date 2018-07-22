class Article < ApplicationRecord

  attachment :image

  acts_as_taggable

  # Validatoin
  validates :title,
  	presence: true,
  	length: { maximum: 50,
              message: "タイトルは最大50文字まで入力できます" }

  validates :body,
  	presence: true,
  	length: { maximum: 10000,
              message: "本文は最大10000文字まで入力できます" }

  # Association
	belongs_to :user
	has_many :comments, dependent: :destroy
  has_many :images, as: :post, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :keeps, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # イイねしたかどうか
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # キープしたかどうか
  def kept_by?(user)
    keeps.where(user_id: user.id).exists?
  end

end
