require 'rails_helper'

RSpec.describe GuestsHelper, type: :helper do
  describe 'helper module' do
    it 'is a module' do
      expect(GuestsHelper).to be_a(Module)
    end

    it 'can be included' do
      expect { Class.new.include(GuestsHelper) }.not_to raise_error
    end
  end
end
