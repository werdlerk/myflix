class CategoriesController < ApplicationController
  before_action :require_user

  def show
    @category = Category.includes(:videos).find(params[:id])
  end
end