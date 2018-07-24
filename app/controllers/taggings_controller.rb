class TaggingsController < ApplicationController

	def destroy
		tagging = Tagging.find(params[:id])
		@user = User.find(tagging.taggable_id)
    @tag = Tag.new
    @taggings = Tagging.where(taggable_type: "User", taggable_id: @user.id)
		# tag = Tag.find_by(id: tagging.tag_id)
		# count = tag.taggings_count - 1
		# tag.update(taggings_count: count)
		tagging.destroy
		# redirect_to user_path(current_user.id)
	end

end
