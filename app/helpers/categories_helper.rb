module CategoriesHelper
  def sub_menu parent_id
    Category.where(parent_id: parent_id)
  end
end
