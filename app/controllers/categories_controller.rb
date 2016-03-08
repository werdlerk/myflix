class CategoriesController < AuthenticatedController

  def show
    @category = Category.includes(:videos).find(params[:id])
  end
end
