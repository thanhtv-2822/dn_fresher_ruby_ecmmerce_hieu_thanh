class RemoveImageFromContributes < ActiveRecord::Migration[6.1]
  def change
    remove_column :contributes, :image
  end
end
