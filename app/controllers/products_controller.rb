# app/controllers/products_controller.rb - Enhanced search functionality:

class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.active.includes(:categories, images_attachments: :blob)
    
    # Enhanced search functionality - search by keyword within selected category
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where("LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ?", search_term, search_term)
      
      # If category is selected for search, filter by that category
      if params[:search_category_id].present? && params[:search_category_id] != ""
        @products = @products.joins(:categories).where(categories: { id: params[:search_category_id] })
      end
    end
    
    # Apply other filters (separate from search)
    @products = @products.featured if params[:featured] == 'true'
    @products = @products.on_sale if params[:on_sale] == 'true'
    @products = @products.new_products if params[:new_products] == 'true'
    @products = @products.recently_updated if params[:recently_updated] == 'true'
    
    # Apply category filter (from sidebar navigation - different from search category)
    if params[:category_id].present? && params[:search].blank?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end
    
    # Use Kaminari for pagination
    @products = @products.order('products.name').page(params[:page]).per(12)
    @categories = Category.root_categories.ordered
    @all_categories = Category.ordered # For search dropdown
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

  # Add a dedicated search action
  def search
    @search_term = params[:search]
    @search_category_id = params[:search_category_id]
    
    @products = Product.active.includes(:categories, images_attachments: :blob)
    
    if @search_term.present?
      search_term = "%#{@search_term.downcase}%"
      @products = @products.where("LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ?", search_term, search_term)
      
      # Filter by category if selected
      if @search_category_id.present? && @search_category_id != ""
        @products = @products.joins(:categories).where(categories: { id: @search_category_id })
        @search_category = Category.find(@search_category_id)
      end
    end
    
    @products = @products.order('products.name').page(params[:page]).per(12)
    @categories = Category.root_categories.ordered
    @all_categories = Category.ordered
    
    render :index
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found or no longer available."
  end
end