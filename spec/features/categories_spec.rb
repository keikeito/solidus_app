require 'rails_helper'

feature "categories pages" do
  given!(:bag) { create(:product, name: 'Bag') }
  given!(:bag_taxon) { create(:taxon, name: 'Bags') }
  given!(:tote) { create(:product, name: 'Tote') }
  given!(:ruby_shirt) { create(:product, name: 'Ruby_shirt') }
  given!(:ruby_taxon) { create(:taxon, name: 'Ruby', taxonomy_id: Spree::Taxonomy.first.id, parent_id: 1) }
  given!(:taxonomy_categories) { create(:taxonomy, name: "Categories") }
  given!(:cap) { create(:product, name: 'Cap') }
  given!(:cap_taxon) { create(:taxon, name: 'Caps', taxonomy_id: taxonomy_categories.id, parent_id: 1) }

  background do
    image = File.open(File.expand_path('../../fixtures/JPEG_example_.jpg', __FILE__))
    bag.images.create(attachment: image)
    tote.images.create(attachment: image)
    bag_taxon.products.push(bag, tote)
    ruby_taxon.products.push(ruby_shirt)
    cap_taxon.products.push(cap)
    visit potepan_category_path(bag_taxon.id)
  end

  scenario "show same category products" do
    expect(page).to have_content /^Bag$/
    expect(page).to have_content /^Tote$/
  end

  scenario "dont show other products" do
    expect(page).not_to have_content /^Ruby_shirt$/
    expect(page).not_to have_content /^Cap$/
  end

  scenario "move home page when click BIGBAG logo" do
    find('.navbar-brand').click
    expect(current_path).to eq potepan_root_path
  end

  scenario "move home page when click home link" do
    click_on 'Home'
    expect(current_path).to eq potepan_root_path
  end

  scenario "move product page when click product.name" do
    click_on 'Bag'
    expect(current_path).to eq potepan_product_path(bag.id)
  end

  scenario "move category page when click Categories and then taxon.name" do
    click_on 'Categories'
    click_on 'Caps'
    expect(current_path).to eq potepan_category_path(cap_taxon.id)
    expect(page).to have_content 'Cap'
  end

  scenario "move category page when click Brand and then taxon.name" do
    click_on 'Brand'
    click_on 'Ruby'
    expect(current_path).to eq potepan_category_path(ruby_taxon.id)
    expect(page).to have_content 'Ruby_shirt'
  end

  scenario "LIST become active and switch URL when click LIST ", js: true do
    find('.link_btn', :text => 'Link', visible: false).click
    expect(find("#List_active")).to have_css('.active')
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq "/potepan/categories/#{bag_taxon.id}?layout=list"
  end

  scenario "GRID become active and switch URL when click GRID", js: true do
    find('.grid_btn', :text => 'Grid', visible: false).click
    expect(find("#Grid_active")).to have_css('.active')
    expect(current_path).to eq "/potepan/categories/#{bag_taxon.id}"
  end

  scenario "GRID become active and switch URL when click LIST and then GRID ", js: true do
    find('.link_btn', :text => 'Link', visible: false).click
    find('.grid_btn', :text => 'Grid', visible: false).click
    expect(find("#Grid_active")).to have_css('.active')
    expect(find("#List_active")).not_to have_css('.active')
    expect(current_path).to eq "/potepan/categories/#{bag_taxon.id}"
  end
end
