class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @product_properties = @product.product_properties.includes(:property)
  end
end
