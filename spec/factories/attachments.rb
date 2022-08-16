# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    user
  end

  trait :with_csv do
    after(:build) do |attachment|
      attachment.file.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/file_example_CSV_5000.csv')),
        filename: 'file_example_CSV_5000.csv',
        content_type: 'text/csv'
      )
    end
  end

  trait :with_png do
    after(:build) do |attachment|
      attachment.file.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/file_example_PNG_3MB.png')),
        filename: 'file_example_PNG_3MB.png',
        content_type: 'image/png'
      )
    end
  end
end
