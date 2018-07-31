class Keep < ApplicationRecord

	# Association
	has_many :notifications
	belongs_to :article
	belongs_to :user

end
