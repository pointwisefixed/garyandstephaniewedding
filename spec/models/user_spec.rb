require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:entree).optional }
    it { should belong_to(:plus_one_entree).optional }
  end

  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
  end

  describe 'devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes trackable module' do
      expect(User.devise_modules).to include(:trackable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe '.find_first_by_auth_conditions' do
    let!(:user) { create(:user, username: 'testuser', email: 'test@example.com') }

    context 'when login is provided' do
      it 'finds user by username' do
        result = User.find_first_by_auth_conditions(login: 'testuser')
        expect(result).to eq(user)
      end

      it 'finds user by email' do
        result = User.find_first_by_auth_conditions(login: 'test@example.com')
        expect(result).to eq(user)
      end

      it 'is case insensitive for username' do
        result = User.find_first_by_auth_conditions(login: 'TESTUSER')
        expect(result).to eq(user)
      end

      it 'is case insensitive for email' do
        result = User.find_first_by_auth_conditions(login: 'TEST@EXAMPLE.COM')
        expect(result).to eq(user)
      end

      it 'returns nil when user not found' do
        result = User.find_first_by_auth_conditions(login: 'nonexistent')
        expect(result).to be_nil
      end
    end

    context 'when login is not provided' do
      it 'finds user by username' do
        result = User.find_first_by_auth_conditions(username: 'testuser')
        expect(result).to eq(user)
      end

      it 'returns first user when no username provided' do
        result = User.find_first_by_auth_conditions({})
        expect(result).to be_a(User)
      end
    end
  end

  describe '#email_required?' do
    it 'returns false' do
      user = build(:user)
      expect(user.email_required?).to be false
    end
  end

  describe '.to_csv' do
    let!(:entree) { create(:entree, description: 'Chicken') }
    let!(:plus_one_entree) { create(:entree, description: 'Beef') }
    let!(:user) do
      create(:user, :attending, :with_plus_one,
             first_name: 'John',
             last_name: 'Doe',
             username: 'johnd',
             email: 'john@example.com',
             entree: entree,
             plus_one_entree: plus_one_entree)
    end
    let!(:user_no_entree) do
      create(:user, :attending,
             first_name: 'Jane',
             last_name: 'Smith',
             username: 'janes',
             email: 'jane@example.com')
    end
    let(:exportable_users) { [user, user_no_entree] }

    it 'generates CSV with correct headers' do
      csv = User.to_csv(exportable_users)
      headers = CSV.parse(csv).first
      expect(headers).to eq(["First Name", "Last Name", "Username", "Email", "RSVP?", "Plus one?", "Entree", "Plus One Entree"])
    end

    it 'includes user data in CSV' do
      csv = User.to_csv(exportable_users)
      rows = CSV.parse(csv)
      first_row = rows[1]
      expect(first_row[0]).to eq('John')
      expect(first_row[1]).to eq('Doe')
      expect(first_row[2]).to eq('johnd')
      expect(first_row[3]).to eq('john@example.com')
      expect(first_row[4]).to eq('true')
      expect(first_row[5]).to eq('true')
      expect(first_row[6]).to eq('Chicken')
      expect(first_row[7]).to eq('Beef')
    end

    it 'handles nil entrees' do
      csv = User.to_csv(exportable_users)
      rows = CSV.parse(csv)
      second_row = rows[2]
      expect(second_row[6]).to eq('')
      expect(second_row[7]).to eq('')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'creates attending user' do
      user = create(:user, :attending)
      expect(user.attending).to be true
    end

    it 'creates user with plus one' do
      user = create(:user, :with_plus_one)
      expect(user.plusone).to be true
      expect(user.plus_one_first_name).to be_present
    end

    it 'creates admin user' do
      user = create(:user, :admin)
      expect(user.admin?).to be true
    end
  end
end
