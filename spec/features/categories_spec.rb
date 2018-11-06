require 'rails_helper'

feature "categories pages" do
  # product
  given(:bag) { create(:product, name: 'Bag', price: 20.00) }
  given(:tote) { create(:product, name: 'Tote', price: 21.00) }
  given(:cap) { create(:product, name: 'Cap', price: 22.00) }
  given(:ruby_shirt) { create(:product, name: 'Ruby_shirt', price: 23.00) }
  # taxon
  given(:brand_taxon) { create(:taxon, name: 'Brand') }
  given(:categories_taxon) { create(:taxon, name: 'Categories') }
  given(:bag_taxon) { create(:taxon, name: 'Bags') }
  given(:cap_taxon) { create(:taxon, name: 'Caps', taxonomy_id: categories_taxonomy.id, parent_id: categories_taxon.id) }
  given(:ruby_taxon) { create(:taxon, name: 'Ruby', taxonomy_id: brand_taxonomy.id, parent_id: brand_taxon.id) }
  # taxonomy
  given(:brand_taxonomy) { create(:taxonomy, name: "Brand") }
  given(:categories_taxonomy) { create(:taxonomy, name: "Categories") }
  # images
  given(:bag_image) { create(:image, viewable_id: bag.id, attachment_file_name: "bag_image") }
  given(:tote_image) { create(:image, viewable_id: tote.id, attachment_file_name: "tote_image") }
  given(:cap_image) { create(:image, viewable_id: cap.id, attachment_file_name: "cap_image") }
  given(:ruby_shirt_image) { create(:image, viewable_id: ruby_shirt.id, attachment_file_name: "ruby_shirt_image") }

  background do
    bag.images << bag_image
    tote.images << tote_image
    cap.images << cap_image
    ruby_shirt.images << ruby_shirt_image
    bag_taxon.products.push(bag, tote)
    ruby_taxon.products.push(ruby_shirt)
    cap_taxon.products.push(cap)
    visit potepan_category_path(bag_taxon.id)
  end

  scenario "show same category products" do
    within('.productlist') do
      expect(page).to have_content 'Bag'
      expect(page).to have_content 'Tote'
      expect(page).to have_content bag.display_price
      expect(page).to have_content tote.display_price
      expect(page).to have_selector "img[src='#{bag.display_image.attachment.url}']"
      expect(page).to have_selector "img[src='#{tote.display_image.attachment.url}']"
    end
  end

  scenario "dont show other products" do
    within('.productlist') do
      expect(page).not_to have_content 'Cap'
      expect(page).not_to have_content 'Ruby_shirt'
      expect(page).not_to have_content cap.display_price
      expect(page).not_to have_content ruby_shirt.display_price
      expect(page).not_to have_selector "img[src='#{cap.display_image.attachment.url}']"
      expect(page).not_to have_selector "img[src='#{ruby_shirt.display_image.attachment.url}']"
    end
  end

  scenario "move home page when click BIGBAG logo" do
    within('.navbar') { find('.navbar-brand').click }
    expect(current_path).to eq potepan_root_path
  end

  scenario "move home page when click home link" do
    within('.navbar') { click_on 'Home' }
    expect(current_path).to eq potepan_root_path
  end

  scenario "move product page when click product.name" do
    within('.productlist') { click_on 'Bag' }
    expect(current_path).to eq potepan_product_path(bag.id)
  end

  scenario "move category page when click Categories and then taxon.name" do
    within('.navbar-side-collapse') do
      find("a[data-target='##{categories_taxonomy.id}']").click
      click_on 'Caps'
    end
    expect(current_path).to eq potepan_category_path(cap_taxon.id)
  end

  scenario "move category page when click Brand and then taxon.name" do
    within('.navbar-side-collapse') do
      find("a[data-target='##{brand_taxonomy.id}']").click
      click_on 'Ruby'
    end
    expect(current_path).to eq potepan_category_path(ruby_taxon.id)
  end

  scenario "LIST become active, GRID dosen't become active and switch to intended URL when click LIST ", js: true do
    within('.filterArea') do
      find('.link_btn', :text => 'Link', visible: false).click
      expect(find("#List_active")).to have_css('.active')
      expect(find("#Grid_active")).not_to have_css('.active')
    end
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq potepan_category_path(bag_taxon.id, layout: "list")
  end

  scenario "GRID become active, LIST dosen't become active and switch to intended URL when click GRID", js: true do
    within('.filterArea') do
      find('.grid_btn', :text => 'Grid', visible: false).click
      expect(find("#Grid_active")).to have_css('.active')
      expect(find("#List_active")).not_to have_css('.active')
    end
    expect(current_path).to eq potepan_category_path(bag_taxon.id)
  end

  scenario "GRID become active, LIST dosen't become active and switch to intended URL when click LIST and then GRID ", js: true do
    within('.filterArea') do
      find('.link_btn', :text => 'Link', visible: false).click
      find('.grid_btn', :text => 'Grid', visible: false).click
      expect(find("#Grid_active")).to have_css('.active')
      expect(find("#List_active")).not_to have_css('.active')
    end
    expect(current_path).to eq potepan_category_path(bag_taxon.id)
  end
end
