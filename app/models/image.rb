class Image < ApplicationRecord

	mount_uploader :image, ImageUploader

	# Association
	belongs_to :post, polymorphic: true, optional: true

end
