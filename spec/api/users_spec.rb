# frozen_string_literal: true

require 'rails_helper'

describe '/api' do
  describe 'POST /users' do
    let(:developer_header) { {} }
    let(:original_params) { { email: email, password: password, password_confirmation: password_confirmation } }
    let(:email) { 'john.doe@example.com' }
    let(:password) { '123456' }
    let(:password_confirmation) { password }
    let(:params) { original_params }

    context 'invalid params' do
      context 'incorrect email' do
        let(:email) { 'invalid@mail' }

        it_behaves_like 'has status code', 422
        it_behaves_like 'json result'
        it do
          post '/api/users', params: params, headers: headers
          expect(JSON.parse(response.body)).to eq('error' => 'Rekord nieprawidłowy: Email niepoprawny')
        end
      end

      context 'invalid password' do
        let(:password) { '' }

        it_behaves_like 'has status code', 422
        it_behaves_like 'json result'
        it do
          post '/api/users', params: params, headers: headers
          expect(JSON.parse(response.body)).to eq('error' => 'Rekord nieprawidłowy: Hasło nie może być puste')
        end
      end

      context 'invalid password_confirmation' do
        let(:password_confirmation) { '111111' }

        it_behaves_like 'has status code', 422
        it_behaves_like 'json result'
        it do
          post '/api/users', params: params, headers: headers
          expect(JSON.parse(response.body)).to eq('error' => 'Rekord nieprawidłowy: Potwierdzenie hasła musi się zgadzać z podanym hasłem')
        end
      end

      context 'email already taken' do
        before { create(:user, email: email, password: password) }

        it_behaves_like 'has status code', 422
        it_behaves_like 'json result'
        it do
          post '/api/users', params: params, headers: headers
          expect(JSON.parse(response.body)).to eq('error' => 'Rekord nieprawidłowy: Email został już wykorzystany')
        end
      end
    end

    context 'valid params' do
      before { travel_to Date.new(2022, 0o4, 0o1) }

      it_behaves_like 'has status code', 201
      it_behaves_like 'json result'
      it 'returns correct attachments' do
        api_call(params: params, headers: developer_header)
        data = JSON.parse(response.body)
        expect(data).to eq('email' => 'john.doe@example.com')
      end
    end

    def api_call(params:, headers: {})
      post '/api/users', params: params, headers: headers
    end
  end
end
