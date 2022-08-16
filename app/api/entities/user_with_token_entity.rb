# frozen_string_literal: true

module Entities
  class UserWithTokenEntity < UserEntity
    expose :token do |user, _options|
      user.authentication_tokens.valid.first.token
    end
  end
end
