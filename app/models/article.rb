class Article < ApplicationRecord

  # Validatoin
  validates :title,
  	presence: true,
  	length: { maximum: 70,
              message: "タイトルは最大70文字まで入力できます" }

  validates :body,
  	presence: true,
  	length: { maximum: 10000,
              message: "本文は最大10000文字まで入力できます" }

  # Association
	belongs_to :user
	has_many :comments, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :keeps, dependent: :destroy
  has_many :taggings, dependent: :destroy

end
