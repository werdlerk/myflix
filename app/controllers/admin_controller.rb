class AdminController < AuthenticatedController
  before_filter :require_admin

  private

  def require_admin
    unless current_user.admin?
      flash[:warning] = "This is not allowed."
      redirect_to root_path
    end
  end
end
