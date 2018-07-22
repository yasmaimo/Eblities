class Post < ApplicationRecord

  # Association
	belongs_to :posted_by, class_name: 'User'
	belongs_to :user
	belongs_to :article

end
