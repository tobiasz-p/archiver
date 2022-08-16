# frozen_string_literal: true

FactoryBot.define do
  factory :authentication_token do
    user
    token { 'MyString' }
    expires_at { 1.day.from_now }
  end
end
