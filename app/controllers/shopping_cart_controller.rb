# app/controllers/shopping_cart_controller.rb

class ShoppingCartController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = @cart.products
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity]&.to_i || 1
    
    @cart.add_product(product.id, quantity)
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: products_path, notice: "#{product.name} added to cart!") }
      format.json { render json: { success: true, cart_count: @cart.total_items, message: "#{product.name} added to cart!" } }
    end
  end

  def update_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    
    @cart.update_quantity(product.id, quantity)
    
    respond_to do |format|
      format.html { redirect_to shopping_cart_path, notice: "Cart updated!" }
      format.json { render json: { success: true, cart_count: @cart.total_items, subtotal: @cart.subtotal } }
    end
  end

  def remove_item
    product = Product.find(params[:product_id])
    @cart.remove_product(product.id)
    
    respond_to do |format|
      format.html { redirect_to shopping_cart_path, notice: "#{product.name} removed from cart!" }
      format.json { render json: { success: true, cart_count: @cart.total_items, subtotal: @cart.subtotal } }
    end
  end

  def clear
    @cart.clear
    redirect_to shopping_cart_path, notice: "Cart cleared!"
  end

  private

  def initialize_cart
    @cart = ShoppingCart.new(session)
  end
end