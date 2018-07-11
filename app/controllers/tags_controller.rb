class TagsController < ApplicationController
  def index
  end

  def create
    params[:user][:tag_list].split(",").each do |tag_name|
      if Tag.exists?(name: tag_name)
        @tag = Tag.find_by(name: tag_name)
        if Tagging.exists?(tag_id: @tag.id, taggable_type: "User", taggable_id: current_user.id)
        else
          Tagging.create(tag_id: @tag.id, taggable_type: "User", taggable_id: current_user.id)
          count = @tag.taggings_count + 1
          @tag.update(taggings_count: count)
        end
      else
        Tag.create(name: tag_name)
        @tag = Tag.find_by(name: tag_name)
        Tagging.create(tag_id: @tag.id, taggable_type: "User", taggable_id: current_user.id)
        count = @tag.taggings_count + 1
        @tag.update(taggings_count: count)
      end
    end
    redirect_to user_path(current_user)
  end

  def show
  end

  def update
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :taggings_count, :tag_list)
  end

end
