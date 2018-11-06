require 'rails_helper'

RSpec.describe Potepan::CategoriesController, type: :controller do
  let(:cap_taxon) { create(:taxon, name: "cap") }
  let(:wallet_taxon) { create(:taxon, name: 'wallet') }
  let(:products) { create_list(:product, 5) }
  let(:taxonomies) { Spree::Taxonomy.includes(:taxons) }

  describe "GET categories show with cap_taxon" do
    before do
      get :show, params: { id: cap_taxon.id }
    end

    it "render categories/show" do
      expect(response).to render_template :show
    end

    it "returns successful response" do
      expect(response).to have_http_status(:ok)
    end

    it "@taxon should have cap_taxon" do
      expect(assigns(:taxon)).to eq(cap_taxon)
    end

    it '@taxonomies should have taxonomies' do
      expect(assigns(:taxonomies)).to eq(taxonomies)
    end

    context 'When product and taxon match' do
      before do
        products.each do |product|
          product.taxons << cap_taxon
        end
      end

      it "@products have a matching array" do
        expect(assigns(:products)).to match_array(products)
      end
    end

    context 'When product and taxon mismatch' do
      before do
        products.each do |product|
          product.taxons << wallet_taxon
        end
      end

      it "@products have an empty array" do
        expect(assigns(:products)).to match_array([])
      end
    end
  end
end
