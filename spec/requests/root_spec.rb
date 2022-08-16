# frozen_string_literal: true

require 'rails_helper'
include LoginHelper

RSpec.describe 'Attachments', type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:user_attachment) { create(:attachment, :with_csv, user: user) }
  let!(:another_user_attachment) { create(:attachment, :with_png, user: another_user) }

  describe 'GET /' do
    context 'when user is not logged in' do
      it 'redirects to login page' do
        get '/'

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is logged in' do
      before { login_user(user) }

      it 'returns http success and logged user\'s attachments only' do
        get '/'
        expect(response).to have_http_status(:success)
        expect(response.body).to match(/file_example_CSV_5000/)
        expect(response.body).not_to match(/file_example_PNG_3MB/)
      end
    end
  end
end
