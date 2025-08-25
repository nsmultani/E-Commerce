class AddUserToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :user, foreign_key: true, null: true
    # null: true allows for guest checkout orders
  end
end