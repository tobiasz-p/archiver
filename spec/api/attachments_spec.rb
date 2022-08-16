# frozen_string_literal: true

require 'rails_helper'

describe '/api' do
  let(:api_key) { create(:api_key) }
  let(:developer_header) { { 'Authorization' => api_key.token } }

  describe 'GET /attachments' do
    let(:token) { create(:authentication_token) }
    let(:original_params) { { token: token.token } }
    let(:params) { original_params }

    it_behaves_like 'restricted for developers'
    it_behaves_like 'unauthenticated'

    context 'invalid params' do
      context 'incorrect token' do
        let(:params) { original_params.merge(token: 'invalid') }

        it_behaves_like 'has status code', 401
        it_behaves_like 'json result'

        it_behaves_like 'contains error msg', 'authentication_error'
        it_behaves_like 'contains error code', ErrorCodes::BAD_AUTHENTICATION_PARAMS
      end
    end

    context 'valid params' do
      before do
        travel_to Date.new(2022, 0o4, 0o1)

        create(:attachment, :with_png, user: token.user)
        create(:attachment, :with_csv, user: token.user)
        create(:attachment, :with_png, user: create(:user))
      end

      it_behaves_like 'has status code', 200
      it_behaves_like 'json result'
      it 'returns correct attachments' do
        api_call(params: params, headers: developer_header)
        data = JSON.parse(response.body)
        expect(data.size).to eq(2)
        expect(data.pluck('file')).to eq([{ 'filename' => 'file_example_PNG_3MB.png', 'byte_size' => 2_964_729 },
                                          { 'filename' => 'file_example_CSV_5000.csv', 'byte_size' => 284_042 }])
        expect(data.pick('file_url')).to match(%r{http://example\.com/.*file_example_PNG_3MB\.png})
        expect(data.pluck('file_url').second).to match(%r{http://example\.com/.*file_example_CSV_5000\.csv})
        expect(data.pluck('created_at')).to eq(%w[2022-04-01T00:00:00.000Z 2022-04-01T00:00:00.000Z])
        expect(data.pluck('updated_at')).to eq(%w[2022-04-01T00:00:00.000Z 2022-04-01T00:00:00.000Z])
      end

      context 'pagination' do
        before { create_list(:attachment, 100, :with_png, user: token.user) }

        it 'paginates' do
          api_call(params: params.merge({ page: 2 }), headers: developer_header)
          headers = response.headers

          expect(headers['Per-Page']).to eq '20'
          expect(headers['Total']).to eq '102'
          expect(headers['Page']).to eq '2'
        end
      end
    end

    def api_call(params:, headers: {})
      get '/api/attachments', params: params, headers: headers
    end
  end

  describe 'POST /attachments' do
    let(:token) { create(:authentication_token) }
    let(:original_params) { { files: files, token: token.token } }
    let(:params) { original_params }
    let(:files) do
      [
        fixture_file_upload('file_example_PNG_3MB.png', 'image/png'),
        fixture_file_upload('file_example_CSV_5000.csv', 'text/csv')
      ]
    end

    it_behaves_like 'restricted for developers'
    it_behaves_like 'unauthenticated'

    context 'invalid params' do
      context 'incorrect token' do
        let(:params) { original_params.merge(token: 'invalid') }

        it_behaves_like 'has status code', 401
        it_behaves_like 'json result'

        it_behaves_like 'contains error msg', 'authentication_error'
        it_behaves_like 'contains error code', ErrorCodes::BAD_AUTHENTICATION_PARAMS
      end
    end

    context 'valid params' do
      before { travel_to Date.new(2022, 0o4, 0o1) }

      it_behaves_like 'has status code', 201
      it_behaves_like 'json result'
      it 'returns correct attachments' do
        api_call(params: params, headers: developer_header)
        data = JSON.parse(response.body)
        expect(data['file']['filename']).to match(/20220401.*\.zip/)
        expect(data['file']['byte_size']).to eq(2_981_175)
        expect(data['file_url']).to match(%r{http://example\.com/.*20220401.*\.zip})
        expect(data['created_at']).to eq('2022-04-01T00:00:00.000Z')
        expect(data['updated_at']).to eq('2022-04-01T00:00:00.000Z')
      end
    end

    def api_call(params:, headers: {})
      post '/api/attachments', params: params, headers: headers
    end
  end
end
