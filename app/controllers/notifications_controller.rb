class NotificationsController < ApplicationController

	before_action :authenticate_user

	def index
		@notifications = current_user.notifications.page(params[:page]).reverse_order
		@notifications.each do |notification|
			if notification.read == false
				notification.update(read: true)
			end
		end
	end

  def link_through
  	if Notification.exists?(params[:id])
	    @notification = Notification.find(params[:id])
	    if @notification.user_id == current_user.id
		    @notification.update read: true
				redirect_to article_path @notification.article
			else
				redirect_to root_path
			end
		else
			redirect_to root_path
		end
  end

end
