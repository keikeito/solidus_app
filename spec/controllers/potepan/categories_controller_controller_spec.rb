require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  let(:one_taxon) { create(:taxon, name: "one") }
  let(:two_taxon) { create(:taxon, name: 'two') }
  let(:products) { create_list(:product, 10) }

  describe "GET categories show with one_taxon" do
    before do
      get :show, params: { id: one_taxon.id }
    end

    it "render categories/show" do
      expect(response).to render_template("potepan/categories/show")
    end

    it "returns successful response" do
      expect(response).to have_http_status(:ok)
    end

    it "@taxon have one_taxon" do
      expect(assigns(:taxon)).to eq(one_taxon)
    end

    it "@products have one_taxon.products" do
      products.each do |product|
        product.taxons << one_taxon
      end
      expect(assigns(:products)).to match_array(products)
    end

    it "@products have not two_taxon.products" do
      products.each do |product|
        product.taxons << two_taxon
      end
      expect(assigns(:products)).to match_array([])
    end
  end
end
