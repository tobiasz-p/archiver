# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'attachments/index', type: :view do
  let(:png) { fixture_file_upload('file_example_PNG_3MB.png', 'image/png') }
  let(:csv) { fixture_file_upload('file_example_CSV_5000.csv', 'text/csv') }

  before do
    assign(:attachments, [
             create(:attachment, :with_png),
             create(:attachment, :with_csv)
           ])
    assign(:pagy, Pagy.new(count: 100, page_param: :custom_param))
  end

  it 'renders a list of attachments' do
    render

    expect(rendered).to match(/file_example_PNG_3MB/)
    expect(rendered).to match(/file_example_CSV_5000/)
  end
end
