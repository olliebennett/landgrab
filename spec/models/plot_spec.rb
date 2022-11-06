# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plot do
  let(:plot_params) { { title: 'hi', polygon: 'POLYGON ((-0.02018 51.51576, -0.02002 51.51591, -0.01981 51.51558, -0.02018 51.51576))' } }
  let(:plot) { described_class.new(plot_params) }

  it 'is valid by default' do
    expect(plot).to be_valid
  end

  it 'handles polygon centroid' do
    # See https://github.com/olliebennett/landgrab/issues/1
    expect(plot.polygon.methods).to include :centroid
  end

  describe '#blocks_subscribed_by' do
    subject(:blocks_subscribed) { plot.blocks_subscribed_by(user) }

    let(:user) { create(:user) }
    let(:block) { create(:block, plot:) }
    let(:subscription) { create(:subscription, user:, block:) }

    before { subscription }

    it 'returns subscribed block' do
      expect(blocks_subscribed.ids).to match_array [block.id]
    end

    it 'excludes unsubscribed blocks' do
      subscription.destroy

      expect(blocks_subscribed.ids).to be_empty
    end

    it 'excludes blocks subscribed by another user' do
      subscription.update!(user: create(:user))

      expect(blocks_subscribed.ids).to be_empty
    end
  end
end
