# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }

  it 'is valid by default' do
    expect(project).to be_valid
  end

  describe '#viewable_by?' do
    subject(:viewable) { project.viewable_by?(user) }

    let(:user) { create(:user) }
    let(:plot) { create(:plot, project:) }
    let(:block) { create(:block, plot:) }
    let(:subscription) { create(:subscription, user:, block:) }

    before { subscription }

    it 'returns true if block subscribed' do
      expect(viewable).to be true
    end

    it 'returns false if block unsubscribed' do
      subscription.destroy
      block.reload

      expect(viewable).to be false
    end

    it 'returns false if block subscribed by another user' do
      subscription.update!(user: create(:user))
      block.reload

      expect(viewable).to be false
    end

    it 'returns false if block assigned to different plot' do
      block.update!(plot: create(:plot))
      block.reload

      expect(viewable).to be false
    end

    it 'returns false if plot assigned to different project' do
      plot.update!(project: create(:project))

      expect(viewable).to be false
    end
  end
end
