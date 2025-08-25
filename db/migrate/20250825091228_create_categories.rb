# We can add this to the categories migration or create a new one
# Add this to the end of the CreateCategories migration:

class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.string :slug, null: false
      t.integer :position, default: 0
      t.integer :parent_id

      t.timestamps
    end

    add_index :categories, :name
    add_index :categories, :position
    add_index :categories, :slug, unique: true
    add_index :categories, :parent_id
    
    # Add foreign key for parent_id (self-referential)
    add_foreign_key :categories, :categories, column: :parent_id
  end
end