class RelationshipsController < ApplicationController

  before_action :authenticate_user

   def create
    @user = User.find(params[:relationship][:following_id])
    current_user.follow!(@user)
    add_two_point
    create_notification
    # redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).following
    current_user.unfollow!(@user)
    subtract_two_point
    destroy_notification
    # redirect_to @user
  end

  private

  def create_notification
    return if @user == current_user
    Notification.create(
                      user_id: @user.id,
                      notified_by_id: current_user.id,
                      notified_type: "フォロー")
  end

  def destroy_notification
    notification = Notification.find_by(
                    user_id: @user.id,
                    notified_by_id: current_user.id,
                    notified_type: "フォロー")
    notification.destroy
  end

end
