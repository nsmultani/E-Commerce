
class CreateProductCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :product_categories do |t|
      t.references :product, null: false, index: true
      t.references :category, null: false, index: true

      t.timestamps
    end

    # Ensure unique product-category combinations
    add_index :product_categories, [:product_id, :category_id], unique: true
    
    # Add foreign keys separately for SQLite compatibility
    add_foreign_key :product_categories, :products
    add_foreign_key :product_categories, :categories
  end
end