class Potepan::CategoriesControllerController < ApplicationController
  @taxon = Spree::Taxon.find(params[:id])
  @products = Spree::Product.in_taxon(@taxon)
  @taxonomies = Spree::Taxonomy.all
end
