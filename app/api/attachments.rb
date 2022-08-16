# frozen_string_literal: true

class Attachments < Grape::API
  helpers AuthenticationHelper

  before do
    restrict_access_to_developers
    authenticate!
  end

  format :json

  desc 'End-points for the Attachments'
  namespace :attachments do
    desc 'Retrieve the attachments'
    paginate
    params do
      requires :token, type: String, desc: 'token'
    end
    get do
      attachments = Attachment.where(user: current_user)
      present paginate(attachments), with: Entities::AttachmentEntity
    end

    desc 'Upload file(s)'
    params do
      requires :files, type: Array[File]
    end
    post do
      files = params[:files].map { |file| ActionDispatch::Http::UploadedFile.new(file) }
      attachment = FilesZipperService.new(files, current_user).call
      attachment.save!

      present attachment, with: Entities::AttachmentEntity
    end
  end
end
