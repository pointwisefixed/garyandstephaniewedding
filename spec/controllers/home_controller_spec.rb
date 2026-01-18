require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'public pages' do
    it 'responds to index' do
      expect(controller).to respond_to(:index)
    end
  end
end
