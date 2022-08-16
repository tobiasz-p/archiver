# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :attachments
  has_many :authentication_tokens

  validates :email, presence: true,
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'format invalid' },
                    uniqueness: { case_sensitive: false },
                    length: { minimum: 4, maximum: 254 }
end
