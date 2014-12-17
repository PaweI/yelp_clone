require 'rails_helper'


def user_sign_in
  user_sign_up
  visit('/')
  click_link('Sign in')
  fill_in('Email', with: 'test@test.com')
  fill_in('Password', with: 'hellohello')
  click_button('Log in')
end

def user_sign_up
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'test@test.com')
  fill_in('Password', with: 'hellohello')
  fill_in('Password confirmation', with: 'hellohello')
  click_button('Sign up')
end

feature 'restaurants' do



  before do
    @user = User.create(email: "test@test.com", password: "hellohello", password_confirmation: "hellohello", id: 1)
  end

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  feature 'after logging in' do

    context 'creating a valid restaurant' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        user_sign_in
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        user_sign_in
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

    context 'editing and deleting restaurants that user own' do

      before do
        @restaurant = Restaurant.create(name:'KFC', 
                          user_id: 1)
      end

      it 'lets a user edit a restaurant' do
        user_sign_in
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end

      it "removes a restaurant when a user clicks a delete link" do
        user_sign_in
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end

    end

    context 'editing and deleting restaurants that user doesn\'t own' do

      before do
        Restaurant.create(name:'KFC', 
                          user_id: 24)
      end

      it 'lets a user edit a restaurant' do
        user_sign_in
        visit '/restaurants'
        click_link 'Edit KFC'
        expect(page).to have_content 'You cannot edit this restaurant'
      end

      it "doesn't remove a restaurant when a user clicks a delete link" do
        user_sign_in
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).to have_content 'You cannot delete this restaurant'
      end

    end

  end

  feature 'before logging in' do

    context 'creating a valid restaurant' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).to have_content("You need to sign in or sign up before continuing.")
      end
    end

    context 'editing restaurants' do

      before do
        Restaurant.create(name:'KFC')
      end

      it 'lets a user edit a restaurant' do
       visit '/restaurants'
       click_link 'Edit KFC'
       expect(page).to have_content("You need to sign in or sign up before continuing.")
      end

    end

    context 'deleting restaurants' do

      before do
        Restaurant.create(:name => "KFC")
      end

      it "removes a restaurant when a user clicks a delete link" do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).to have_content("You need to sign in or sign up before continuing.")
      end

    end

  end

  context 'viewing restaurants' do

    before do
      @kfc = Restaurant.create(name:'KFC')
    end

    it 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{@kfc.id}"
    end

  end

  

end