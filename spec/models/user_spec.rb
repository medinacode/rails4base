require 'rails_helper'

RSpec.describe User, :type => :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  describe 'email_address' do
    it 'is invalid with an invalid email address' do
      user = FactoryGirl.build(:user, email_address: 'xxx')
      user.valid?
      expect(user.errors).to have_key(:email_address)
    end

    it 'is invalid with an existing email address' do
      user = FactoryGirl.create(:user)
      new_user = build(:user, email_address: user.email_address)
      new_user.valid?
      expect(new_user.errors).to have_key(:email_address)
    end
  end

  describe 'Password' do
    it 'is invalid without a password on create' do
      user = FactoryGirl.build(:user, password: '')
      user.valid?
      expect(user.errors).to have_key(:password)
    end

    it 'is invalid with a short password on create' do
      user = FactoryGirl.build(:user, password: 'asf')
      user.valid?
      expect(user.errors).to have_key(:password)
    end
  end

end
