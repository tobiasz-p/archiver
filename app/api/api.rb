# frozen_string_literal: true

class API < Grape::API
  prefix 'api'
  mount Login
  mount Attachments
  mount Users

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    rack_response({
      status: e.status,
      error_msg: e.message
    }.to_json, 400)
  end
end
