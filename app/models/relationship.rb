class Relationship < ApplicationRecord

	# Validation
	validates :follower_id, presence: true
	validates :following_id, presence: true

	# Association
	belongs_to :follower, class_name: "User"
	belongs_to :following, class_name: "User"


end
