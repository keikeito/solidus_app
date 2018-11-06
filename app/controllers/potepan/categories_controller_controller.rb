class Potepan::CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    @products = Spree::Product.in_taxon(@taxon)
    @taxonomies = Spree::Taxonomy.all
  end
end
