module CategoriesHelper
  def grid_layout?
    params[:layout] != "list"
  end

  def list_layout?
    params[:layout] == "list"
  end
end
