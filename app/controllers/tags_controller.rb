class TagsController < ApplicationController
  def index
  end

  def create
  end

  def show
  end

  def update
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :taggings_count)
  end

end
