# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription do
  describe '#assign_latest_subscription' do
    let(:subscr) { create(:subscription, tile: nil) }
    let(:tile) { create(:tile) }

    it 'assigns subscription as latest_subscription for tile' do
      expect { subscr.update(tile:) }.to change { tile.reload.latest_subscription }.from(nil).to(subscr)
    end
  end
end
