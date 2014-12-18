require 'rails_helper'

  # def write_review
  #   visit '/restaurants'
  #   click_link 'Review KFC'
  #   fill_in "Thoughts", with: "so so"
  #   select '3', from: 'Rating'
  #   click_button 'Leave Review'
  # end

  def write_review
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
  end

  def user_sign_in
    visit('/')
    click_link('Sign in')
    fill_in('Email', with: 'test@test.com')
    fill_in('Password', with: 'hellohello')
    click_button('Log in')
  end

describe 'reviewing' do
  before do
    Restaurant.create(name: 'KFC', id: 1)
    @user = User.create(email: "test@test.com", password: "hellohello", password_confirmation: "hellohello", id: 1)
    # Review.create(thoughts: "rubbish", rating: 4, restaurant_id: 1)
  end


  context 'when logged in' do

    it 'allows users to leave a review using a form' do
      user_sign_in
      write_review
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end

    it 'allows users to leave one review per restaurant' do
      user_sign_in
      write_review
      visit '/restaurants'
      click_link 'Review KFC'
      expect(page).to have_content('You have already reviewed this restaurant.')
    end

  end

  context 'when logged out' do

    it 'does not allow users to leave a review using a form' do
      visit '/restaurants'
      click_link 'Review KFC'
      expect(page).to have_content('You must be logged in to write a review.')
    end
    
  end



end