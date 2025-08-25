# app/models/category.rb - Update the ransackable methods:

class Category < ApplicationRecord
  # Self-referential association for subcategories
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent_category, class_name: 'Category', foreign_key: 'parent_id', optional: true

  # Many-to-many relationship with products
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-_]+\z/ }
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :root_categories, -> { where(parent_id: nil) }
  scope :ordered, -> { order(:position, :name) }
  
  before_validation :generate_slug

  # Define which attributes can be searched/filtered in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "slug", "position", "parent_id", "created_at", "updated_at"]
  end

  # Define which associations can be searched - simplified for Ransack
  def self.ransackable_associations(auth_object = nil)
    ["products", "product_categories"]
  end

  def full_name
    return name if parent_category.nil?
    "#{parent_category.name} > #{name}"
  end

  def is_root_category?
    parent_id.nil?
  end

  def has_subcategories?
    subcategories.any?
  end

  private

  def generate_slug
    return if slug.present? && !name_changed?
    self.slug = name.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-+|-+$/, '')
  end
end