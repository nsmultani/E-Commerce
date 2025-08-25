# app/models/order_item.rb - Updated version
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :product_name, presence: true

  # Store product details at time of purchase for historical accuracy
  before_create :store_product_details

  def total_price
    quantity * price
  end

  # For ActiveAdmin ransack
  def self.ransackable_attributes(auth_object = nil)
    ["quantity", "price", "product_name", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end

  private

  def store_product_details
    if product
      self.product_name = product.name
      self.price = product.display_price
    end
  end
end