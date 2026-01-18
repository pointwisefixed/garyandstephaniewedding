require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  before do
    sign_in user
  end

  describe 'GET #update' do
    context 'when user updates their own record' do
      let(:new_attributes) do
        {
          attending: true,
          plusone: true,
          plus_one_first_name: 'Jane',
          plus_one_last_name: 'Doe'
        }
      end

      it 'updates the user' do
        patch :update, params: { id: user.id, user: new_attributes }, format: :json
        user.reload
        expect(user.attending).to be true
        expect(user.plusone).to be true
        expect(user.plus_one_first_name).to eq('Jane')
        expect(user.plus_one_last_name).to eq('Doe')
      end

      it 'returns the updated user as JSON' do
        patch :update, params: { id: user.id, user: new_attributes }, format: :json
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['attending']).to be true
      end
    end

    context 'when user tries to update another user record' do
      it 'returns forbidden status' do
        patch :update, params: { id: other_user.id, user: { attending: true } }, format: :json
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns error message' do
        patch :update, params: { id: other_user.id, user: { attending: true } }, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Unauthorized')
      end

      it 'does not update the other user' do
        original_attending = other_user.attending
        patch :update, params: { id: other_user.id, user: { attending: true } }, format: :json
        other_user.reload
        expect(other_user.attending).to eq(original_attending)
      end
    end

    context 'when admin updates any user record' do
      before do
        sign_in admin_user
      end

      it 'allows the update' do
        patch :update, params: { id: other_user.id, user: { attending: true } }, format: :json
        other_user.reload
        expect(other_user.attending).to be true
      end

      it 'returns success status' do
        patch :update, params: { id: other_user.id, user: { attending: true } }, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'when not authenticated' do
      before do
        sign_out user
      end

      it 'redirects to sign in' do
        patch :update, params: { id: user.id, user: { attending: true } }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
