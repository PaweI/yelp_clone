require 'rails_helper'

def create_user
  visit '/'
  click_link 'Sign up'
  fill_in 'user[email]', with: 'test@test.com'
  fill_in 'user[password]', with: 'hellohello'
  fill_in 'user[password_confirmation]', with: 'hellohello'
  click_button 'Sign up'
end

feature 'restaurants' do
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
        create_user
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        create_user
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

    context 'editing and deleting restaurants' do

      before do
        Restaurant.create(name:'KFC')
      end

      it 'lets a user edit a restaurant' do
        create_user
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end

      it "removes a restaurant when a user clicks a delete link" do
        create_user
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
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