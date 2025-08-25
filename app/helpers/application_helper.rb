# app/helpers/application_helper.rb

module ApplicationHelper
  def current_cart
    @current_cart ||= ShoppingCart.new(session)
  end
  
  def cart_item_count
    current_cart.total_items
  end
  
  def cart_subtotal
    current_cart.subtotal
  end
end