class RelationshipsController < ApplicationController

   def create
    @user = User.find(params[:relationship][:following_id])
    current_user.follow!(@user)
    get_ep_on_followed
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).following
    current_user.unfollow!(@user)
    get_ep_on_unfollowed
    redirect_to @user
  end

end
