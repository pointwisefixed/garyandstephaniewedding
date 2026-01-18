require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'helper module' do
    it 'is a module' do
      expect(ApplicationHelper).to be_a(Module)
    end

    it 'can be included' do
      expect { Class.new.include(ApplicationHelper) }.not_to raise_error
    end
  end
end
