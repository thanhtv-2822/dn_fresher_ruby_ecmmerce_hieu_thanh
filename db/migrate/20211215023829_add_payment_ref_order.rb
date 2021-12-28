class AddPaymentRefOrder < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :payment, null: true, foreign_key: true
  end
end
