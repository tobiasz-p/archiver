# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'registration failed' do
  it 'does not create user' do
    post '/users', params: params

    expect(response).not_to redirect_to root_path
    expect(User.all.count).to eq 0
  end
end

RSpec.describe 'Users', type: :request do
  describe 'GET /users/new' do
    it 'returns http success' do
      get '/users/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /users' do
    let(:params) { { user: { email: email, password: password, password_confirmation: password_confirmation } } }
    let(:email) { 'john.doe@example.com' }
    let(:password) { '123456' }
    let(:password_confirmation) { password }

    context 'when credentials are valid' do
      it 'redirects to root and returns http success' do
        post '/users', params: params
        expect(response).to redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(User.all.count).to eq 1
      end
    end

    context 'registration failed' do
      context 'invalid email' do
        let(:email) { 'invalid@mail' }

        it_behaves_like 'registration failed'
      end

      context 'invalid password' do
        let(:password) { '' }

        it_behaves_like 'registration failed'
      end

      context 'invalid password_confirmation' do
        let(:password_confirmation) { '111111' }

        it_behaves_like 'registration failed'
      end

      context 'email already taken' do
        before { create(:user, email: email, password: password) }

        it 'does not create user' do
          post '/users', params: params

          expect(response).not_to redirect_to root_path
          expect(User.all.count).to eq 1
        end
      end
    end
  end
end
