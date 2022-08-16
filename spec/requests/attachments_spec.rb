# frozen_string_literal: true

require 'rails_helper'
include LoginHelper

RSpec.describe 'Attachments', type: :request do
  describe 'GET /new' do
    context 'when user is not logged in' do
      it 'redirects to login page' do
        get '/attachments/new'

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is logged in' do
      before { login_user }

      it 'returns http success' do
        get '/attachments/new'
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST' do
    let(:params) { { attachment: { files: files } } }
    let(:files) do
      [
        fixture_file_upload('file_example_PNG_3MB.png', 'image/png'),
        fixture_file_upload('file_example_CSV_5000.csv', 'text/csv')
      ]
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post '/attachments', params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is logged in' do
      before { login_user }

      it 'returns http success' do
        post '/attachments', params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Hasło do twojego pliku:')
        expect(Attachment.all.count).to eq 1
      end
    end
  end
end
