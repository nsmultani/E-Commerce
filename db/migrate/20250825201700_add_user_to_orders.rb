class AddUserToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :user, foreign_key: true, null: true
    # null: true because we want to support guest checkout too
  end
end