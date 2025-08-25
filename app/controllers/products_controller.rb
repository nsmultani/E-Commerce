# app/controllers/products_controller.rb - Replace with Kaminari pagination:

class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.active.includes(:categories, images_attachments: :blob)
    
    # Apply search first (before joins to avoid ambiguity)
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where("LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ?", search_term, search_term)
    end
    
    # Apply filters (no joins needed for these)
    @products = @products.featured if params[:featured] == 'true'
    @products = @products.on_sale if params[:on_sale] == 'true'
    @products = @products.new_products if params[:new_products] == 'true'
    @products = @products.recently_updated if params[:recently_updated] == 'true'
    
    # Apply category filter (requires join)
    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end
    
    # Use Kaminari for pagination
    @products = @products.order('products.name').page(params[:page]).per(12)
    @categories = Category.root_categories.ordered
  end

  def show
    # Find related products based on shared categories
    if @product.categories.any?
      @related_products = Product.active
                                .joins(:categories)
                                .where(categories: { id: @product.categories.ids })
                                .where.not(id: @product.id)
                                .distinct
                                .limit(4)
    else
      @related_products = Product.active.where.not(id: @product.id).limit(4)
    end
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found or no longer available."
  end
end