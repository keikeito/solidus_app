require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  let(:product_property) { create(:product_property) }

  describe "GET product show"
    before do
      get :show, params: { id: product_property.product.id }
    end

    it "render products/show" do
      expect(response).to render_template :show
    end

    it "return statuscode 200" do
      expect(response.status).to eq(200)
    end

    it "@product should have product" do
      expect(assigns(:product)).to eq(product_property.product)
    end

    it "@product_properties should have product" do
      expect(assigns(:product_properties)).to eq Array(product_property)
    end
  end

