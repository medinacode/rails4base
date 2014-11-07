require 'rails_helper'

feature 'Features: Admin User Management' do

  before :each do
    admin = FactoryGirl.create(:admin)
    page.set_rack_session(:user_id => admin.id)
  end

  scenario 'adds a new user' do
    expect {
      visit new_user_path
      fill_in 'user_full_name', with: Faker::Name.name
      fill_in 'user_nickname', with: Faker::Name.first_name
      fill_in 'user_email_address', with: Faker::Internet.email
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Save'
    }.to change(User, :count).by 1
    expect(current_path).to eq users_path
  end

  scenario 'updates an existing user' do
    user = FactoryGirl.create(:user)
    visit edit_user_path user
    fill_in 'user_full_name', with: 'New Name'
    click_button 'Save'
    expect(current_path).to eq users_path
    updated_user = User.find(user.id)
    expect(updated_user.full_name).to eq 'New Name'
  end

  scenario 'deletes a user' do
    user = FactoryGirl.create(:user)
    expect {
      visit users_path
      click_link "delete_user_#{user.id}"
    }.to change(User, :count).by -1
    expect(current_path).to eq users_path
  end
  
  scenario 'shows a user (AJAX)', js: true do
    user = FactoryGirl.create(:user)
    visit users_path
    click_link "show_user_#{user.id}"
    expect(page).to have_content 'Show User'
    click_button 'Done'
    expect(current_path).to eq users_path
  end

  scenario 'adds a new user (AJAX)', js: true do
    password = Faker::Internet.password
    expect {
      visit users_path
      click_link 'new_user'
      fill_in 'user_full_name', with: Faker::Name.name
      fill_in 'user_nickname', with: Faker::Name.first_name
      fill_in 'user_email_address', with: Faker::Internet.email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password
      click_button 'Save'
    }.to change(User, :count).by 1
    expect(current_path).to eq users_path
  end

  scenario 'updates an existing user (AJAX)', js: true do
    user = FactoryGirl.create(:user)
    visit users_path
    click_link "edit_user_#{user.id}"
    fill_in 'user_full_name', with: 'New Name'
    click_button 'Save'
    expect(current_path).to eq users_path
    updated_user = User.find(user.id)
    expect(updated_user.full_name).to eq 'New Name'
  end

end

feature 'Features: Logged in User Management' do

  before :each do
    @user = FactoryGirl.create(:user)
    page.set_rack_session(:user_id => @user.id)
  end

  scenario 'updates their information' do
    visit edit_user_path @user
    fill_in 'user_full_name', with: 'New Name'
    click_button 'Save'
    expect(current_path).to eq '/home'
    updated_user = User.find(@user.id)
    expect(updated_user.full_name).to eq 'New Name'
  end

  scenario 'shows a user (AJAX)', js: true do
    visit home_path
    find('a.dropdown-toggle').click
    find("a#show_user_#{@user.id}").click
    expect(page).to have_content 'Show User'
    click_button 'Done'
    expect(current_path).to eq '/home'
  end

  scenario 'updates their information (AJAX)', js: true do
    visit home_path
    find('a.dropdown-toggle').click
    find("a#edit_user_#{@user.id}").click
    fill_in 'user_full_name', with: 'New Name'
    click_button 'Save'
    expect(current_path).to eq '/home'
    updated_user = User.find(@user.id)
    expect(updated_user.full_name).to eq 'New Name'
  end

end