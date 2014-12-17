require 'rails_helper'

describe 'reviewing' do
  before do
    Restaurant.create(name: 'KFC')
  end

  def write_review
     visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'
  end

  it 'allows users to leave a review using a form' do
     write_review
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  it 'allows users to leave one review per restaurant' do
    write_review
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end



end