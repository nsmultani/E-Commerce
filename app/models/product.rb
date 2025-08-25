# app/models/product.rb - Add new scopes:

class Product < ApplicationRecord
  # Active Storage associations for images
  has_many_attached :images
  
  # Many-to-many relationship with categories
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :sku, presence: true, uniqueness: true, format: { with: /\A[A-Z0-9\-_]+\z/i }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  
  # Image validation
  validate :acceptable_images

  scope :active, -> { where(is_active: true) }
  scope :featured, -> { where(featured: true) }
  scope :on_sale, -> { where(on_sale: true) }
  scope :in_category, ->(category) { joins(:categories).where(categories: { id: category.id }) }
  
  # New scopes for filtering
  scope :new_products, -> { where('created_at >= ?', 30.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 7.days.ago, 30.days.ago) }
  
  def display_price
    on_sale? && sale_price.present? ? sale_price : price
  end
  
  def in_stock?
    stock_quantity > 0
  end

  def primary_image
    images.attached? ? images.first : nil
  end

  def category_names
    categories.pluck(:name).join(', ')
  end

  def is_new?
    created_at >= 30.days.ago
  end

  def recently_updated?
    updated_at >= 7.days.ago && created_at < 30.days.ago
  end

  # Define which attributes can be searched/filtered in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["name", "sku", "price", "stock_quantity", "is_active", "featured", "on_sale", "created_at", "updated_at"]
  end

  # Define which associations can be searched
  def self.ransackable_associations(auth_object = nil)
    ["categories", "product_categories"]
  end

  private

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
        errors.add(:images, 'must be a JPEG, PNG, GIF, or WebP image')
      end
      
      if image.byte_size > 5.megabytes
        errors.add(:images, 'must be less than 5MB')
      end
    end
  end
end