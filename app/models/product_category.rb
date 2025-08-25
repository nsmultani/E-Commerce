# app/models/product_category.rb

class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  validates :product_id, uniqueness: { scope: :category_id }

  # Define which attributes can be searched/filtered in ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["product_id", "category_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product", "category"]
  end
end