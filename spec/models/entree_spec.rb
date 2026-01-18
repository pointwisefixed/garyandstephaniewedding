require 'rails_helper'

RSpec.describe Entree, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:entree)).to be_valid
    end

    it 'creates vegetarian entree' do
      entree = create(:entree, :vegetarian)
      expect(entree.name).to eq("Vegetarian Option")
    end

    it 'creates meat entree' do
      entree = create(:entree, :meat)
      expect(entree.name).to eq("Meat Option")
    end
  end

  describe 'attributes' do
    let(:entree) { create(:entree, name: 'Test Entree', description: 'Test Description') }

    it 'has a name' do
      expect(entree.name).to eq('Test Entree')
    end

    it 'has a description' do
      expect(entree.description).to eq('Test Description')
    end
  end

  describe 'creation' do
    it 'can be created with valid attributes' do
      entree = Entree.create(name: 'New Entree', description: 'New Description')
      expect(entree).to be_persisted
      expect(entree.name).to eq('New Entree')
    end
  end
end
