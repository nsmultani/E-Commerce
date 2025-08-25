# app/controllers/products_controller.rb - Better approach avoiding unnecessary joins:

class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.active.includes(:categories, images_attachments: :blob)
    
    # Apply search first (before joins to avoid ambiguity)
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where("LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ?", search_term, search_term)
    end
    
    # Apply basic filters (no joins needed)
    @products = @products.featured if params[:featured] == 'true'
    @products = @products.on_sale if params[:on_sale] == 'true'
    
    # Apply category filter (requires join)
    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end
    
    # Get total count before pagination
    @total_count = @products.count
    
    # Apply pagination
    per_page = 12
    page = (params[:page] || 1).to_i
    offset = (page - 1) * per_page
    
    @products = @products.order('products.name').limit(per_page).offset(offset)
    @current_page = page
    @total_pages = (@total_count.to_f / per_page).ceil
    
    @categories = Category.root_categories.ordered
  end

  def show
    @related_products = Product.active
                              .joins(:categories)
                              .where(categories: { id: @product.categories.ids })
                              .where.not(id: @product.id)
                              .limit(4)
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  end
end