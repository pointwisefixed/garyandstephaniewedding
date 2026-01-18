require 'rails_helper'

RSpec.describe WeddingInfo, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:wedding_info)).to be_valid
    end
  end

  describe 'attributes' do
    let(:wedding_info) { create(:wedding_info) }

    it 'has his_story' do
      expect(wedding_info.his_story).to be_present
    end

    it 'has her_story' do
      expect(wedding_info.her_story).to be_present
    end

    it 'has proposal' do
      expect(wedding_info.proposal).to be_present
    end

    it 'has ceremony_location' do
      expect(wedding_info.ceremony_location).to be_present
    end

    it 'has reception_location' do
      expect(wedding_info.reception_location).to be_present
    end

    it 'has accommodations' do
      expect(wedding_info.accommodations).to be_present
    end

    it 'has registry_info' do
      expect(wedding_info.registry_info).to be_present
    end
  end

  describe 'creation' do
    it 'can be created with all attributes' do
      info = WeddingInfo.create(
        his_story: 'His story',
        her_story: 'Her story',
        proposal: 'Proposal',
        ceremony_location: 'Chapel',
        reception_location: 'Ballroom',
        accommodations: 'Hotel',
        registry_info: 'Registry'
      )
      expect(info).to be_persisted
    end
  end
end
