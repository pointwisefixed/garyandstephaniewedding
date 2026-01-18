require 'rails_helper'

RSpec.describe "Guest Management", type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }

  describe "Admin access" do
    before do
      sign_in admin_user
    end

    it "allows admin to view guest list" do
      get guests_path
      expect(response).to have_http_status(:success)
    end

    it "allows admin to export guest list" do
      create(:user, :attending)
      get export_guests_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('text/csv')
    end

    it "allows admin to create a new guest" do
      post guests_path, params: {
        guest: attributes_for(:user)
      }
      expect(response).to have_http_status(:success)
    end

    it "allows admin to get guest count" do
      get count_guests_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "Regular user access" do
    before do
      sign_in regular_user
    end

    it "denies regular user access to guest list" do
      get guests_path
      expect(response).to redirect_to(root_path)
    end

    it "denies regular user access to export" do
      get export_guests_path(format: :csv)
      expect(response).to redirect_to(root_path)
    end
  end
end
