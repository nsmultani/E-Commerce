
class AddOrderTrackingFields < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :shipped_at, :datetime
    add_column :orders, :delivered_at, :datetime
    add_column :orders, :tracking_number, :string
    add_column :orders, :order_number, :string
    add_column :orders, :tax_details, :text

    add_index :orders, :order_number, unique: true
    add_index :orders, :shipped_at
    add_index :orders, :delivered_at
  end
end