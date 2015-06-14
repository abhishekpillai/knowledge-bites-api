require 'rails_helper'

feature 'A knowledge bites session', :type => :feature do
  scenario 'displays 4 bites' do
    expected_count_of_bites = 4

    (expected_count_of_bites+1).times do |index|
      vid = Video.create! title: "Bobloblaw's Talk #{index}"
      Bite.create! content: vid
    end

    visit '/'

    expect(page).to have_selector('ul section.bite', count: expected_count_of_bites)
  end
end
