class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :customer_name, :email, :address_line_1, :city, :province, :postal_code, :country, presence: true
  validates :subtotal, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum status: {
    pending: 'pending',
    paid: 'paid',
    shipped: 'shipped',
    cancelled: 'cancelled'
  }

  def self.ransackable_attributes(auth_object = nil)
    ["customer_name", "email", "status", "total", "created_at"]
  end
end