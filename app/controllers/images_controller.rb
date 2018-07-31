class ImagesController < ApplicationController
  def create
  end

  def destroy
  end





  private

  def image_params
  	params.require(:image).permit(:post_id, :post_type, :image)
  end

end
