require 'rails_helper'

feature 'Features: Login' do

  scenario 'does not log in with invalid login' do
    visit login_path
    fill_in 'email_address', with: Faker::Internet.email
    fill_in 'password', with: Faker::Internet.password
    click_button 'Go'
    expect(current_path).to eq login_path
    expect(page).to have_content 'Login Failed'
  end

  scenario 'logs in with valid login' do
    user = FactoryGirl.create(:user)
    visit login_path
    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: user.password
    click_button 'Go'
    expect(current_path).to eq '/home'
  end

  scenario 'logs out' do
    user = FactoryGirl.create(:user)
    page.set_rack_session(:user_id => user.id)
    visit logout_path
    expect(current_path).to eq login_path
    expect(page.get_rack_session).to_not include('user_id')
  end

end