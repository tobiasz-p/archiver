# frozen_string_literal: true

RSpec.shared_examples 'json result' do
  specify 'returns JSON' do
    api_call(params: params, headers: developer_header)
    expect { JSON.parse(response.body) }.not_to raise_error
  end
end

RSpec.shared_examples 'contains error msg' do |msg|
  specify "error msg is #{msg}" do
    api_call(params: params, headers: developer_header)
    json = JSON.parse(response.body)
    expect(json['error_msg']).to eq(msg)
  end
end

RSpec.shared_examples 'has status code' do |status_code|
  specify "returns #{status_code}" do
    api_call(params: params, headers: developer_header)
    expect(response.status).to eq(status_code)
  end
end

RSpec.shared_examples 'restricted for developers' do
  context 'without developer key' do
    specify 'should be an unauthorized call' do
      api_call(params: params)
      expect(response.status).to eq(401)
    end

    specify 'error code is 1001' do
      api_call(params: params)
      json = JSON.parse(response.body)
      expect(json['error_code']).to eq(ErrorCodes::DEVELOPER_KEY_MISSING)
    end
  end
end

RSpec.shared_examples 'unauthenticated' do
  context 'unauthenticated' do
    specify 'returns 401 without token' do
      api_call(params: params.except(:token), headers: developer_header)
      expect(response.status).to eq(401)
    end

    specify 'returns JSON' do
      api_call(params: params.except(:token), headers: developer_header)
      JSON.parse(response.body)
    end
  end
end

RSpec.shared_examples 'contains error code' do |code|
  specify "error code is #{code}" do
    api_call(params: params, headers: developer_header)
    json = JSON.parse(response.body)
    expect(json['error_code']).to eq(code)
  end
end

RSpec.shared_examples 'contains error msg' do |msg|
  specify "error msg is #{msg}" do
    api_call(params: params, headers: developer_header)
    json = JSON.parse(response.body)
    expect(json['error_msg']).to eq(msg)
  end
end
