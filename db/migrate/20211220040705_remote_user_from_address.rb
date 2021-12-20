class RemoteUserFromAddress < ActiveRecord::Migration[6.1]
  def change
    remove_column :addresses, :user, :string

  end
end
