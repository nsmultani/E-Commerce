require 'rails_helper'

RSpec.describe "ShoppingCarts", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/shopping_cart/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /add_item" do
    it "returns http success" do
      get "/shopping_cart/add_item"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update_item" do
    it "returns http success" do
      get "/shopping_cart/update_item"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /remove_item" do
    it "returns http success" do
      get "/shopping_cart/remove_item"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /clear" do
    it "returns http success" do
      get "/shopping_cart/clear"
      expect(response).to have_http_status(:success)
    end
  end

end
