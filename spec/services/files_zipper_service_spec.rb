# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesZipperService, type: :model do
  before { travel_to Date.new(2022, 0o4, 0o1) }

  describe '#call' do
    let!(:attachment) { described_class.new(files, user).call }
    let(:user) { create(:user) }
    let(:files) do
      [
        fixture_file_upload('file_example_PNG_3MB.png', 'image/png'),
        fixture_file_upload('file_example_CSV_5000.csv', 'text/csv')
      ]
    end

    it 'zips given file(s)' do
      expect(attachment.file.attached?).to be true
      expect(attachment.file.blob.filename.to_s).to match(/20220401.+zip/)
      expect(attachment.file.blob.content_type).to eq 'application/zip'
    end
  end
end
