require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'devise modules' do
    it 'includes database_authenticatable module' do
      expect(Admin.devise_modules).to include(:database_authenticatable)
    end

    it 'includes recoverable module' do
      expect(Admin.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(Admin.devise_modules).to include(:rememberable)
    end

    it 'includes trackable module' do
      expect(Admin.devise_modules).to include(:trackable)
    end

    it 'includes validatable module' do
      expect(Admin.devise_modules).to include(:validatable)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:admin)).to be_valid
    end

    it 'creates admin with email and password' do
      admin = create(:admin)
      expect(admin.email).to be_present
      expect(admin.encrypted_password).to be_present
    end
  end

  describe 'validations' do
    it 'requires email' do
      admin = build(:admin, email: nil)
      expect(admin).not_to be_valid
    end

    it 'requires password' do
      admin = build(:admin, password: nil)
      expect(admin).not_to be_valid
    end
  end
end
