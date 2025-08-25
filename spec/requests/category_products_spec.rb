require 'rails_helper'

RSpec.describe "CategoryProducts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/category_products/index"
      expect(response).to have_http_status(:success)
    end
  end

end
