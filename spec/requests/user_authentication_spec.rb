require 'rails_helper'

RSpec.describe "User Authentication", type: :request do
  let(:user) { create(:user, password: 'password123', password_confirmation: 'password123') }

  describe "Sign in" do
    it "allows user to sign in with valid credentials" do
      post user_session_path, params: {
        user: {
          login: user.username,
          password: 'password123'
        }
      }
      expect(response).to have_http_status(:redirect)
    end

    it "allows user to sign in with email" do
      post user_session_path, params: {
        user: {
          login: user.email,
          password: 'password123'
        }
      }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "Sign out" do
    before do
      sign_in user
    end

    it "allows user to sign out" do
      delete destroy_user_session_path
      expect(response).to have_http_status(:redirect)
    end
  end
end
