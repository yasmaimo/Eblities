class Relationship < ApplicationRecord

	# Association
	belongs_to :follower, class_name: "User"

end
