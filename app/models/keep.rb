class Keep < ApplicationRecord

	# Association
	belongs_to :article
	belongs_to :user

end
