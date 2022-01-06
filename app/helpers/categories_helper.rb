module CategoriesHelper
  def sub_menu parent_id
    Category.where(parent_id: parent_id)
  end

  def all_sub_menu
    Category.where.not(parent_id: nil)
  end
end
