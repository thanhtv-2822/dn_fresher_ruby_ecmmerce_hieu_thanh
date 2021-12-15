class RemoteTypeFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :type_id, :integer
  end
end
