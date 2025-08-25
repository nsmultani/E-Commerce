class AddOrderTrackingFields < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :shipped_at, :datetime
    add_column :orders, :delivered_at, :datetime
    add_column :orders, :tracking_number, :string
  end
end