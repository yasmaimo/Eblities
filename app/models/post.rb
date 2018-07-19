class Post < ApplicationRecord

  # Validatoin
  validates :post,
  	presence: true,
  	length: { maximum: 200,
              message: "最大200文字まで入力できます" }

  # Association
	belongs_to :user, dependent: :destroy

end
