class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :is_admin
<<<<<<< HEAD
=======

>>>>>>> 10fd8e4... Create model user
      t.timestamps
    end
  end
end
