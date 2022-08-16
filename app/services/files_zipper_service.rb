require 'zip'

class FilesZipperService
  attr_reader :files, :secure_random, :user

  SECURE_RANDOM_SIZE = 20
  FILENAME_HEX_SUFFIX_LEN = 4

  def initialize(files, user)
    @files = files
    @user = user
  end

  def call
    @attachment = Attachment.new.tap do |attachment|
      attachment.file.attach(io: File.open(zip_file), filename: filename, content_type: 'application/zip')
      attachment.user = user
    end
  end

  private

  def zip_file
    stringio = Zip::OutputStream.write_buffer(::StringIO.new(''), encrypter) do |zio|
      files.each do |file|
        zio.put_next_entry(file.original_filename)
        zio.write(File.read(file.tempfile.path))
      end
    end

    stringio.rewind

    Tempfile.new.tap do |tempfile|
      tempfile.binmode
      tempfile.write(stringio.read)
    end
  end

  def encrypter
    @secure_random = SecureRandom.alphanumeric(SECURE_RANDOM_SIZE)
    Zip::TraditionalEncrypter.new(@secure_random)
  end

  def filename
    "#{Time.current.to_s(:number)}-#{SecureRandom.hex(FILENAME_HEX_SUFFIX_LEN)}.zip"
  end
end
