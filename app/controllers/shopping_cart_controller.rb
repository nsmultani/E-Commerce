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
    redirect_back(fallback_location: products_path, notice: "#{product.name} added to cart!")
  end

  def update_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    
    @cart.update_quantity(product.id, quantity)
    redirect_to cart_path, notice: "Cart updated!"
  end

  def remove_item
    product = Product.find(params[:product_id])
    @cart.remove_product(product.id)
    redirect_to cart_path, notice: "#{product.name} removed from cart!"
  end

  def clear
    @cart.clear
    redirect_to cart_path, notice: "Cart cleared!"
  end

end