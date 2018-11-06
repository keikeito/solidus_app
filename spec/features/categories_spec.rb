require 'rails_helper'

feature "categories pages" do
  given(:bag) { create(:product, name: 'Bag') }
  given(:bag_taxon) { create(:taxon, name: 'Bags') }
  given(:tote) { create(:product, name: 'Tote') }
  given!(:taxonomy_categories) { create(:taxonomy, name: "Categories") }
  given(:cap) { create(:product, name: 'Cap') }
  given!(:cap_taxon) { create(:taxon, name: 'Caps', taxonomy_id: taxonomy_categories.id) }

  background do
    image = File.open(File.expand_path('../../fixtures/JPEG_example_.jpg', __FILE__))
    bag.images.create(attachment: image)
    tote.images.create(attachment: image)
    bag_taxon.products.push(bag, tote)
    visit potepan_category_path(bag_taxon.id)
  end

  scenario "show same category products" do
    expect(page).to have_content 'Bag'
    expect(page).to have_content 'Tote'
  end

  scenario "dont show other taxon products" do
    expect(page).not_to have_content 'Caps'
  end

  scenario "move home page when click home link" do
    click_on 'Home'
    expect(current_path).to eq potepan_root_path
  end

  scenario "move product page when click product.name link" do
    click_on 'Bag'
    expect(current_path).to eq potepan_product_path(bag.id)
  end

  scenario "[1]taxonをクリックするとtaxonのidと同じ商品が並ぶ Display products with the same Taxon_id when click taxon" do
    click_on 'Categories'
    click_on cap_taxon.name
    expect(current_path).to eq potepan_category_path(cap_taxon.id)
  end

  scenario "[2]LISTクリックするとLISTはactiveになる" do
    find('.certain_class', :text => 'Click me').click
    expect(current_path).to eq "potepan/categories/#{bag_taxon.id}?layout=list"
  end
end
