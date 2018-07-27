class Notification < ApplicationRecord

 belongs_to :notified_by, class_name: 'User', optional: true
 belongs_to :user
 belongs_to :article, optional: true

end
