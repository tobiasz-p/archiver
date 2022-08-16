# frozen_string_literal: true

module Entities
  class AttachmentEntity < Grape::Entity
    expose :file, using: FileEntity
    expose :file_url
    expose :created_at
    expose :updated_at
  end
end
