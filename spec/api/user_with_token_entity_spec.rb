# frozen_string_literal: true

require 'rails_helper'

describe Entities::UserWithTokenEntity do
  describe 'fields' do
    subject(:subject) { described_class }

    let!(:token) { create(:authentication_token) }

    specify 'presents the first available token' do
      json = described_class.new(token.user).as_json
      expect(json[:token]).to be_present
    end
  end
end
