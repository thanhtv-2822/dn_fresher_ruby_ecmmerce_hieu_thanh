class CreateContributes < ActiveRecord::Migration[6.1]
  def change
    create_table :contributes do |t|
      t.string :content
      t.string :image
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
