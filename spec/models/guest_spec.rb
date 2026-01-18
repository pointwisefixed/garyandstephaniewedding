require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe 'model existence' do
    it 'exists as a model' do
      expect(Guest).to be_a(Class)
    end

    it 'inherits from ActiveRecord::Base' do
      expect(Guest.superclass).to eq(ActiveRecord::Base)
    end
  end

  describe 'creation' do
    it 'can be instantiated' do
      guest = Guest.new
      expect(guest).to be_a(Guest)
    end

    it 'can be created and persisted' do
      guest = Guest.create
      expect(guest).to be_persisted
    end
  end
end
