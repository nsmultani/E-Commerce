class Product < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :sku, presence: true, uniqueness: true, format: { with: /\A[A-Z0-9\-_]+\z/i }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  
  scope :active, -> { where(is_active: true) }
  scope :featured, -> { where(featured: true) }
  scope :on_sale, -> { where(on_sale: true) }
  
  def display_price
    on_sale? && sale_price.present? ? sale_price : price
  end
  
  def in_stock?
    stock_quantity > 0
  end

  # Define which attributes can be searched/filtered in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["name", "sku", "price", "stock_quantity", "is_active", "featured", "on_sale", "created_at", "updated_at"]
  end

  # Define which associations can be searched (none for now)
  def self.ransackable_associations(auth_object = nil)
    []
  end
end