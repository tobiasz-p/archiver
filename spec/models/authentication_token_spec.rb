# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationToken, type: :model do
  subject(:record) do
    build(:authentication_token, token: token)
  end

  let(:token) { 'example-token' }

  context 'associations' do
    it 'belongs_to user' do
      expect(described_class.reflect_on_association(:user).macro).to match(:belongs_to)
    end
  end

  context 'validations' do
    context 'token' do
      context 'empty' do
        let(:token) { '' }

        it { is_expected.not_to be_valid }

        it 'sets proper error messages' do
          record.validate
          expect(record.errors.messages).to eq({ token: ['jest pusty'] })
        end
      end
    end
  end
end
