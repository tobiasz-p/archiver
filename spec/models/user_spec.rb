# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:record) do
    build(:user, email: email, password: password, password_confirmation: password_confirmation)
  end

  let(:email) { 'john.doe@example.com' }
  let(:password) { '123456' }
  let(:password_confirmation) { '123456' }

  context 'associations' do
    it 'has_many attachments' do
      expect(described_class.reflect_on_association(:attachments).macro).to match(:has_many)
    end

    it 'has_many authentication_tokens' do
      expect(described_class.reflect_on_association(:authentication_tokens).macro).to match(:has_many)
    end
  end

  context 'validations' do
    context 'email' do
      context 'empty' do
        let(:email) { '' }

        it { is_expected.not_to be_valid }

        it 'sets proper error messages' do
          record.validate
          expect(record.errors.messages).to eq({ email: ['jest pusty', 'niepoprawny',
                                                         'zbyt krótki (minimum 4 znaki)'] })
        end
      end

      context 'invalid' do
        let(:email) { 'invalid@mail' }

        it { is_expected.not_to be_valid }

        it 'sets proper error messages' do
          record.validate
          expect(record.errors.messages).to eq({ email: ['niepoprawny'] })
        end
      end

      context 'too long' do
        let(:email) { "#{'a' * 249}@a.com" }

        it { is_expected.not_to be_valid }

        it 'sets proper error messages' do
          record.validate
          expect(record.errors.messages).to eq({ email: ['zbyt długi (maximum 254 znaki)'] })
        end
      end
    end

    context 'password' do
      context 'empty' do
        let(:password) { '' }

        it { is_expected.not_to be_valid }

        it 'sets proper error messages' do
          record.validate
          expect(record.errors.messages).to eq({ password: ['nie może być puste'] })
        end
      end

      context 'password_confirmation does not match password' do
        let(:password_confirmation) { '123' }

        it { is_expected.not_to be_valid }

        it 'sets proper error messages' do
          record.validate
          expect(record.errors.messages).to eq({ password_confirmation: ['musi się zgadzać z podanym hasłem'] })
        end
      end
    end
  end
end
