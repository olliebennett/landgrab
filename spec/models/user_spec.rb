# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#titleize_lowercased_names' do
    it 'titleizes entirely lowercased first and last names' do
      simon = create(:user, first_name: 'simon', last_name: 'lópez')

      expect(simon.first_name).to eq 'Simon'
      expect(simon.last_name).to eq 'López'
    end

    it 'does not modify any already-capitalized first and last names' do
      gertrude = create(:user, first_name: 'gerTrüde', last_name: 'van Dyk')

      expect(gertrude.first_name).to eq 'gerTrüde'
      expect(gertrude.last_name).to eq 'van Dyk'
    end
  end
end
