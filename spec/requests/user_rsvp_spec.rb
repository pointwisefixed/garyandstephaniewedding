require 'rails_helper'

RSpec.describe "User RSVP", type: :request do
  let(:user) { create(:user) }
  let(:entree) { create(:entree) }

  before do
    sign_in user
  end

  describe "Updating RSVP" do
    it "allows user to RSVP as attending" do
      patch user_path(user), params: {
        user: {
          attending: true,
          entree_id: entree.id
        }
      }, as: :json

      expect(response).to have_http_status(:success)
      user.reload
      expect(user.attending).to be true
      expect(user.entree_id).to eq(entree.id)
    end

    it "allows user to add a plus one" do
      patch user_path(user), params: {
        user: {
          attending: true,
          plusone: true,
          plus_one_first_name: 'Jane',
          plus_one_last_name: 'Doe'
        }
      }, as: :json

      expect(response).to have_http_status(:success)
      user.reload
      expect(user.plusone).to be true
      expect(user.plus_one_first_name).to eq('Jane')
      expect(user.plus_one_last_name).to eq('Doe')
    end

    it "prevents user from updating another user's RSVP" do
      other_user = create(:user)
      patch user_path(other_user), params: {
        user: { attending: true }
      }, as: :json

      expect(response).to have_http_status(:forbidden)
      other_user.reload
      expect(other_user.attending).to be false
    end
  end
end
