# frozen_string_literal: true

class Attachment < ApplicationRecord
  has_one_attached :file

  belongs_to :user

  def file_url
    Rails.application.routes.url_helpers.polymorphic_url(file, host: ENV.fetch('HOST_NAME', 'example.com'))
  end
end
