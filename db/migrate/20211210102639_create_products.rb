class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, default: 0
      t.float :rating, default: 1
      t.text :description

      t.timestamps
    end
  end
end
