require 'rails_helper'

RSpec.describe "ShoppingCarts", type: :request do
  # You'll need a Product model for these tests to work.
  # If you are using FactoryBot, you can use:
  # let!(:product) { create(:product) }
  # Otherwise, create a product directly:
  let!(:product) { Product.create!(name: 'Northern Lights Poster', sku: 'POSTER-NL-01', price: 15.99, stock_quantity: 10, description: 'A beautiful poster.') }

  describe "GET /cart" do
    it "returns http success" do
      get cart_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /cart/add/:product_id" do
    it "adds an item to the cart and redirects" do
      post cart_add_path(product_id: product.id), params: { quantity: 2 }

      # The controller uses redirect_back, which in a test environment
      # will go to the fallback_location.
      expect(response).to redirect_to(products_path)
      follow_redirect!
      expect(response.body).to include("#{product.name} added to cart!")

      # Verify the item is in the cart on the next request
      get cart_path
      expect(response.body).to include(product.name)
    end
  end

  describe "PATCH /cart/update/:product_id" do
    before do
      # Add an item to the cart to be updated
      post cart_add_path(product_id: product.id), params: { quantity: 1 }
    end

    it "updates an item quantity and redirects to the cart" do
      patch cart_update_path(product_id: product.id), params: { quantity: 5 }
      expect(response).to redirect_to(cart_path)
      follow_redirect!
      expect(response.body).to include("Cart updated!")
    end
  end

  describe "DELETE /cart/remove/:product_id" do
    before do
      post cart_add_path(product_id: product.id)
    end

    it "removes an item from the cart and redirects" do
      delete cart_remove_path(product_id: product.id)
      expect(response).to redirect_to(cart_path)
      follow_redirect!
      expect(response.body).to include("#{product.name} removed from cart!")
      expect(response.body).not_to include(product.name)
    end
  end

  describe "DELETE /cart/clear" do
    it "clears the entire cart and redirects" do
      delete cart_clear_path
      expect(response).to redirect_to(cart_path)
      follow_redirect!
      expect(response.body).to include("Cart cleared!")
    end
  end
end
