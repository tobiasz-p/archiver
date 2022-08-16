# frozen_string_literal: true

class Users < Grape::API
  format :json

  desc 'End-points for the Users'
  namespace :users do
    desc 'Create user'
    params do
      requires :email, type: String, desc: 'email'
      requires :password, type: String, desc: 'password'
      requires :password_confirmation, type: String, desc: 'password confirmation'
    end
    post do
      user = User.create!(params)

      present user, with: Entities::UserEntity
    end
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error!({ error: e.message }, 422)
  end
end
