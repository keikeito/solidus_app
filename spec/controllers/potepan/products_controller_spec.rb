require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  let(:product) { create(:product) }

  describe "GET product show" do
    before do
      get :show, params: { id: product.id }
    end

    it "render products/show" do
      expect(response).to render_template("potepan/products/show")
    end

    it "returns successful response" do
      expect(response).to have_http_status(:ok)
    end

    it "@product should have product" do
      expect(assigns(:product)).to eq(product)
    end
  end
end
