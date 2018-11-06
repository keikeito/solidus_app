module CategoriesHelper
  def grid_layout?(layout)
    layout != 'list'
  end

  def list_layout?(layout)
    layout == 'list'
  end
end
