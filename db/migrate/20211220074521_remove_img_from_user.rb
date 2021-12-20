class RemoveImgFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :img, :string
  end
end
