class Image < ApplicationRecord

	# Association
	belongs_to :post, polymorphic: true

end
