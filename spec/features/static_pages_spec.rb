require 'rails_helper'

feature 'Landing page' do
  scenario 'Shows site title' do
    visit root_path
    expect(page).to have_content('Blicker')
  end
end

feature 'About page' do
  scenario 'Shows site title' do
    visit about_path
    expect(page).to have_content('Blicker')
  end

  scenario 'Shows about text' do
    visit about_path
    expect(page).to have_content('a site to collect and monitor stock symbols while I blog about them')
  end
end
