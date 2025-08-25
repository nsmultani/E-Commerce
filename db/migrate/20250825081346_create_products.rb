class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.string :sku, null: false, index: { unique: true }
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock_quantity, default: 0
      t.decimal :weight, precision: 8, scale: 3
      t.string :dimensions
      t.boolean :is_active, default: true
      t.boolean :featured, default: false
      t.boolean :on_sale, default: false
      t.decimal :sale_price, precision: 10, scale: 2

      t.timestamps
    end

    add_index :products, :name
    add_index :products, :is_active
    add_index :products, :featured
  end
end