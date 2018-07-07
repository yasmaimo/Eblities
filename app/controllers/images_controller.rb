class ImagesController < ApplicationController
  def create
  end

  def destroy
  end

  private

  def image_params
  	params.require(:image).permit(:article_id, :image)
  end

end
