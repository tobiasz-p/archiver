# frozen_string_literal: true

class AuthenticationToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true
  scope :valid, -> { where(expires_at: nil).or(where('expires_at > ?', Time.current)) }

  class << self
    def generate(user)
      create(token: SecureRandom.hex, user: user)
    end
  end
end
