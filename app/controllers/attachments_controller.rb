# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def new
    @attachment = Attachment.new
  end

  def create
    @file_zipper_service = FilesZipperService.new(create_params[:files], current_user)
    @attachment = @file_zipper_service.call

    if @attachment.save
      password_notice
      redirect_to root_path
    else
      render :new
    end
  end

  def index
    @pagy, @attachments = pagy(Attachment.all.where(user: current_user).order(created_at: :desc))
  end

  private

  def create_params
    params.require(:attachment).permit(files: [])
  end

  def password_notice
    flash[:success] = "Hasło do twojego pliku: #{@file_zipper_service&.secure_random}"
  end

  rescue_from ActionController::ParameterMissing do
    flash.now[:danger] = 'Dodaj co najmniej jeden plik'
    @attachment = Attachment.new
    render :new
  end
end
