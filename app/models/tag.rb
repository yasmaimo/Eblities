class Tag < ApplicationRecord

  validates :name,
    presence: true,
    length: { maximum: 14,
              message: "タグの名前は1つにつき最大14文字まで入力できます" }

  has_many :taggings

end
