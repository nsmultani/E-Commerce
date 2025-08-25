class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :email
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :taxes, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.string :status
      t.string :stripe_payment_intent_id

      t.timestamps
    end
  end
end