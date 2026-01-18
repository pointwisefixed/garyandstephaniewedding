require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe 'admin controller' do
    it 'inherits from ApplicationController' do
      expect(AdminController.superclass).to eq(ApplicationController)
    end

    it 'can be instantiated' do
      expect(AdminController.new).to be_a(AdminController)
    end
  end
end
