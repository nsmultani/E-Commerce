class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # This method is now available to all controllers that inherit from ApplicationController.
  def initialize_cart
    @cart = ShoppingCart.new(session)
  end
end
