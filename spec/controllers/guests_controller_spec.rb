require 'rails_helper'

RSpec.describe GuestsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:guest_user) { create(:user, :attending, :with_plus_one) }
  let(:entree) { create(:entree) }

  describe 'admin-only actions' do
    context 'when user is not admin' do
      before do
        sign_in regular_user
      end

      it 'redirects from index' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'redirects from count' do
        get :count
        expect(response).to redirect_to(root_path)
      end

      it 'redirects from export' do
        get :export, format: :csv
        expect(response).to redirect_to(root_path)
      end

      it 'redirects from create' do
        post :create, params: { guest: attributes_for(:user) }
        expect(response).to redirect_to(root_path)
      end

      it 'redirects from update' do
        patch :update, params: { id: guest_user.id, guest: { attending: false } }
        expect(response).to redirect_to(root_path)
      end

      it 'redirects from destroy' do
        delete :destroy, params: { id: guest_user.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is admin' do
      before do
        sign_in admin_user
      end

      describe 'GET #index' do
        it 'returns success' do
          get :index
          expect(response).to have_http_status(:success)
        end

        it 'assigns @guests' do
          get :index
          expect(assigns(:guests)).to match_array(User.all)
        end

        it 'assigns @entrees' do
          entree
          get :index
          expect(assigns(:entrees)).to be_an(Array)
          expect(assigns(:entrees).size).to be > 0
        end

        it 'assigns @attending_count' do
          guest_user
          get :index
          expect(assigns(:attending_count)).to be_a(Integer)
        end
      end

      describe 'GET #count' do
        it 'returns guest count as JSON' do
          create(:user, :attending)
          create(:user, :attending, :with_plus_one)
          get :count
          expect(response).to have_http_status(:success)
          expect(response.content_type).to match(/application\/json/)
        end

        it 'counts attending guests correctly' do
          create(:user, :attending)
          get :count
          json_response = JSON.parse(response.body)
          expect(json_response).to be > 0
        end
      end

      describe '#count_guests' do
        it 'counts only attending users' do
          create(:user, attending: false)
          attending_user = create(:user, :attending)
          controller_instance = GuestsController.new
          expect(controller_instance.count_guests).to eq(1)
        end

        it 'includes plus ones in count' do
          create(:user, :attending, :with_plus_one)
          controller_instance = GuestsController.new
          expect(controller_instance.count_guests).to eq(2) # 1 attending + 1 plus one
        end

        it 'does not double count attending users with plus ones' do
          create(:user, :attending, :with_plus_one)
          create(:user, :attending)
          controller_instance = GuestsController.new
          expect(controller_instance.count_guests).to eq(3) # 2 attending + 1 plus one
        end
      end

      describe 'GET #export' do
        before do
          create(:user, :attending, first_name: 'John', last_name: 'Doe')
        end

        it 'exports CSV file' do
          get :export, format: :csv
          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq('text/csv')
        end

        it 'sets correct filename' do
          get :export, format: :csv
          expect(response.headers['Content-Disposition']).to include("guests-#{Date.today}.csv")
        end

        it 'includes attending users only' do
          create(:user, attending: false, first_name: 'Not', last_name: 'Attending')
          get :export, format: :csv
          expect(response.body).to include('John')
          expect(response.body).not_to include('Not')
        end
      end

      describe 'POST #create' do
        let(:valid_attributes) { attributes_for(:user) }
        let(:invalid_attributes) { { username: '' } }

        context 'with valid params' do
          it 'creates a new User' do
            expect {
              post :create, params: { guest: valid_attributes }
            }.to change(User, :count).by(1)
          end

          it 'returns the created user as JSON' do
            post :create, params: { guest: valid_attributes }
            expect(response).to have_http_status(:success)
            expect(response.content_type).to match(/application\/json/)
          end
        end

        context 'with invalid params' do
          it 'does not create a new User' do
            expect {
              post :create, params: { guest: invalid_attributes }
            }.not_to change(User, :count)
          end

          it 'returns unprocessable_entity status' do
            post :create, params: { guest: invalid_attributes }
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns error messages' do
            post :create, params: { guest: invalid_attributes }
            json_response = JSON.parse(response.body)
            expect(json_response).to have_key('username')
          end
        end
      end

      describe 'PATCH #update' do
        let(:new_attributes) { { attending: true, plusone: true } }

        context 'with valid params' do
          it 'updates the requested guest' do
            patch :update, params: { id: guest_user.id, guest: { attending: false } }
            guest_user.reload
            expect(guest_user.attending).to be false
          end

          it 'returns the updated guest as JSON' do
            patch :update, params: { id: guest_user.id, guest: new_attributes }
            expect(response).to have_http_status(:success)
            expect(response.content_type).to match(/application\/json/)
          end
        end

        context 'with invalid params' do
          it 'returns unprocessable_entity status' do
            patch :update, params: { id: guest_user.id, guest: { username: '' } }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      describe 'DELETE #destroy' do
        let!(:guest_to_delete) { create(:user) }

        it 'destroys the requested guest' do
          expect {
            delete :destroy, params: { id: guest_to_delete.id }
          }.to change(User, :count).by(-1)
        end

        it 'returns no_content status' do
          delete :destroy, params: { id: guest_to_delete.id }
          expect(response).to have_http_status(:no_content)
        end
      end
    end

    context 'when not authenticated' do
      it 'redirects to sign in' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
