require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it 'factory has :invalid_user method' do
    expect(FactoryGirl.build(:invalid_user)).to_not be nil?
  end

  describe ':full_name' do
    it 'is invalid without full_name' do
      user = FactoryGirl.build(:user, full_name: '')
      user.valid?
      expect(user.errors).to have_key(:full_name)
    end

    subject(:user) { FactoryGirl.build(:user) }
    it { should accept_values_for(:full_name, Faker::Name.name) }
    it { should_not accept_values_for(:full_name, nil, '', ' ') }
  end

  describe ':nickname' do
    it 'is invalid without nickname' do
      user = FactoryGirl.build(:user, nickname: '')
      user.valid?
      expect(user.errors).to have_key(:nickname)
    end

    subject(:user) { FactoryGirl.build(:user) }
    it { should accept_values_for(:nickname, Faker::Name.first_name) }
    it { should_not accept_values_for(:nickname, nil, '', ' ') }
  end

  describe ':email_address' do
    it 'is invalid without email_address' do
      user = FactoryGirl.build(:user, email_address: '')
      user.valid?
      expect(user.errors).to have_key(:email_address)
    end

    it 'is invalid with duplicate email_address' do
      existing = FactoryGirl.create(:user)
      user = FactoryGirl.build(:user, email_address: existing.email_address)
      user.valid?
      expect(user.errors).to have_key(:email_address)
    end

    subject(:user) { FactoryGirl.build(:user) }
    it { should accept_values_for(:email_address, Faker::Internet.email) }
    it { should_not accept_values_for(:email_address, nil, '', ' ', 'testy@teser') }
  end

  describe ':password' do
    it 'is invalid without password on create' do
      user = FactoryGirl.build(:user, password: '')
      user.valid?
      expect(user.errors).to have_key(:password)
    end

    it 'is invalid with too short password on create' do
      user = FactoryGirl.build(:user, password: Faker::Internet.password(6))
      user.valid?
      expect(user).to_not be_valid
    end

    it 'is valid without password on update' do
      user = FactoryGirl.create(:user)
      user.password = ''
      user.valid?
      expect(user).to be_valid
    end

    it 'is invalid with too short password on update' do
      user = FactoryGirl.create(:user)
      user.password = Faker::Internet.password(7)
      user.valid?
      expect(user).to_not be_valid
    end
  end

end
