class Comment < ApplicationRecord

  # Validatoin
  validates :comment,
  	presence: true,
  	length: { maximum: 500,
              message: "タイトルは最大500文字まで入力できます" }

	# Association
	has_many :notifications
	belongs_to :article
	belongs_to :user

end
