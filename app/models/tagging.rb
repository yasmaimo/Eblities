class Tagging < ApplicationRecord
	belongs_to :tag, optional: true
	belongs_to :article, optional: true
	belongs_to :user, optional: true
end
