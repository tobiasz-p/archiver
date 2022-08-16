# frozen_string_literal: true

module Entities
  class FileEntity < Grape::Entity
    expose :filename
    expose :byte_size
  end
end
