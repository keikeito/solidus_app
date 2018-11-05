require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe "GET product show" do
    before do
      create(:product)
      create(:product_property)
      @product = Spree::Product.last
      get :show, params: { id: @product.id }
    end

    it "render products/show" do
      expect(response).to render_template("potepan/products/show")
    end

    it "return statuscode 200" do
      expect(response.status).to eq(200)
    end

    it "@product should have product" do
      expect(assigns(:product)).to eq(@product)
    end

    it "@product_properties should have product" do
      product_property = @product.product_properties
      expect(assigns(:product_properties)).to eq product_property
    end
  end
end
