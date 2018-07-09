class Image < ApplicationRecord
	attachment :image
	# Association
	belongs_to :article

end
