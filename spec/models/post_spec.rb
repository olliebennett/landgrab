# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post do
  let(:post) { build(:post) }

  it 'is valid by default' do
    expect(post).to be_valid
  end

  describe '#mentioned_tiles' do
    let(:tile1) { create(:tile) }
    let(:body) { "Tile 1 is ///#{tile1.w3w} thanks" }

    before { post.body = body }

    it 'extracts tiles from w3w strings in body' do
      expect(post.mentioned_tiles.map(&:id)).to contain_exactly(tile1.id)
    end
  end
end
