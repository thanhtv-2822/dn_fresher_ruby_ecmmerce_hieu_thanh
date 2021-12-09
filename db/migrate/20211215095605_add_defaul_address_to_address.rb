class AddDefaulAddressToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :default, :integer
  end
end
