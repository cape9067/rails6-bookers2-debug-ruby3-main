class FavoritesController < ApplicationController
  before_action :authenticate_user!

  
  def create
  @post_favorite = Favorite.new(user_id: current_user.id, book_id: params[:book_id])
  @post_favorite.save
  redirect_to book_path(params[:book_id]) 
  end
  

  def destroy
  @post_favorite = Favorite.find_by(user_id: current_user.id, book_id: params[:book_id])
  if @post_favorite.present?
  @post_favorite.destroy
  end
  redirect_to book_path(params[:book_id]) 
  end
  
  private

  def book_params
    @favorite = Book.find(params[:id])
  end
end
