class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.string :street_address, null: false
      t.string :address_line_2
      t.string :city, null: false
      t.string :postal_code, null: false
      t.string :address_type, null: false # 'shipping' or 'billing'
      t.boolean :is_default, default: false

      t.timestamps
    end

    add_index :addresses, [:user_id, :address_type]
    add_index :addresses, [:user_id, :is_default]
  end
end