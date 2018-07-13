class Draft < ApplicationRecord

  acts_as_taggable

  # Validatoin
  validates :title,
  	length: { maximum: 70,
              message: "タイトルは最大70文字まで入力できます" }

  validates :body,
  	length: { maximum: 10000,
              message: "本文は最大10000文字まで入力できます" }

  # Association
	belongs_to :user
  has_many :images, as: :post, dependent: :destroy
  has_many :tagging, as: :taggable, dependent: :destroy
end
