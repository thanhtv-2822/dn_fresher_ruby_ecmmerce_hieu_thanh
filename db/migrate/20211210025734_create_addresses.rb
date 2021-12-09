class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :phone
      t.string :street
      t.string :commune
      t.string :district
      t.string :city
      t.string :user
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
