require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'test'
    end
  end

  before do
    routes.draw { get 'index' => 'anonymous#index' }
  end

  describe 'base controller' do
    it 'inherits from ActionController::Base' do
      expect(ApplicationController.superclass).to eq(ActionController::Base)
    end

    it 'can be instantiated' do
      expect(ApplicationController.new).to be_a(ApplicationController)
    end
  end

  describe 'CSRF protection' do
    it 'includes protect_from_forgery' do
      expect(controller.class.ancestors).to include(ActionController::RequestForgeryProtection)
    end
  end
end
