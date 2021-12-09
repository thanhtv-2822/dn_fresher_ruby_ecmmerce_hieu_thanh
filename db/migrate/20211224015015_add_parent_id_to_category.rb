class AddParentIdToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :parent_id, :integer
  end
end
