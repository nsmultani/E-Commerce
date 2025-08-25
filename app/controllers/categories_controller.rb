# app/controllers/categories_controller.rb - Add new filters:

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @root_categories = Category.root_categories.ordered.includes(:subcategories, :products)
  end

  def show
    @products = @category.products.active.includes(:categories, images_attachments: :blob)
    @subcategories = @category.subcategories.ordered.includes(:products)
    
    # Apply filters if present
    @products = @products.featured if params[:featured] == 'true'
    @products = @products.on_sale if params[:on_sale] == 'true'
    @products = @products.new_products if params[:new_products] == 'true'
    @products = @products.recently_updated if params[:recently_updated] == 'true'
    
    # Apply search within category
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where("LOWER(products.name) LIKE ? OR LOWER(products.description) LIKE ?", search_term, search_term)
    end
    
    # Pagination
    @total_count = @products.count
    per_page = 12
    page = (params[:page] || 1).to_i
    offset = (page - 1) * per_page
    
    @products = @products.order('products.name').limit(per_page).offset(offset)
    @current_page = page
    @total_pages = (@total_count.to_f / per_page).ceil
  end

  private

  def set_category
    @category = Category.find_by!(slug: params[:slug])
  end
end