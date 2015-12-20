require 'rails_helper'

feature 'Landing page' do
  scenario 'Shows site title' do
    visit root_path
    expect(page).to have_content('Blicker')
  end
end
