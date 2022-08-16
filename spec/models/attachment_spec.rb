# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context 'associations' do
    it 'belongs_to user' do
      expect(described_class.reflect_on_association(:user).macro).to match(:belongs_to)
    end
  end
end
