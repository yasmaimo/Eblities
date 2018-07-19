class NotificationsController < ApplicationController

	def index
		@notifications = current_user.notifications.page(params[:page]).reverse_order
		@notifications.each do |notification|
			if notification.read == false
				notification.update(read: true)
			end
		end
	end

  def link_through
    @notification = Notification.find(params[:id])
    @notification.update read: true
		redirect_to article_path @notification.article
  end

end
