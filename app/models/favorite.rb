class Favorite < ApplicationRecord

	# Association
	belongs_to :article
	belongs_to :user

end
