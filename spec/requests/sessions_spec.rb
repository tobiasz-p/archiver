# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'login failed' do
  it 'shows error message' do
    post '/login', params: params

    expect(response).not_to have_http_status(:redirect)
    expect(flash[:danger]).to match(/Nieprawidłowy email lub hasło/)
  end
end

RSpec.describe 'Sessions', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /login' do
    let(:params) { { login: { email: email, password: password } } }
    let(:email) { 'john.doe@example.com' }
    let(:password) { '123456' }

    before { create(:user, email: 'john.doe@example.com', password: '123456') }

    context 'login successful' do
      it 'redirects to login path' do
        post '/login', params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        follow_redirect!
      end
    end

    context 'login failed' do
      context 'email' do
        context 'invalid' do
          let(:email) { 'invalid@mail.com' }

          it_behaves_like 'login failed'
        end

        context 'missing' do
          let(:params) { { login: { password: password } } }

          it_behaves_like 'login failed'
        end
      end

      context 'password' do
        context 'invalid' do
          let(:password) { 'invalid-password' }

          it_behaves_like 'login failed'
        end

        context 'missing' do
          let(:params) { { login: { email: email } } }

          it_behaves_like 'login failed'
        end
      end
    end
  end

  describe 'DELETE /logout' do
    it 'returns https success and redirects to login page' do
      delete '/logout'
      expect(response).to redirect_to login_path
      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end
end
