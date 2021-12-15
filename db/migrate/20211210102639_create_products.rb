class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.float :rating
      t.string :image
      t.text :description
      t.integer :category_id
      t.integer :type_id

      t.timestamps
    end
  end
end
