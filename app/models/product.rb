class Product < ApplicationRecord
  # Active Storage associations for images
  has_many_attached :images
  
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
  
  def display_price
    on_sale? && sale_price.present? ? sale_price : price
  end
  
  def in_stock?
    stock_quantity > 0
  end

  def primary_image
    images.attached? ? images.first : nil
  end

  # Define which attributes can be searched/filtered in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["name", "sku", "price", "stock_quantity", "is_active", "featured", "on_sale", "created_at", "updated_at"]
  end

  # Define which associations can be searched (none for now)
  def self.ransackable_associations(auth_object = nil)
    []
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