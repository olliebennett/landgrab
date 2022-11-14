# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post do
  let(:post) { build(:post) }

  it 'is valid by default' do
    expect(post).to be_valid
  end

  describe '#mentioned_blocks' do
    let(:block1) { create(:block) }
    let(:body) { "Block 1 is ///#{block1.w3w} thanks" }

    before { post.body = body }

    it 'extracts blocks from w3w strings in body' do
      expect(post.mentioned_blocks.map(&:id)).to match_array [block1.id]
    end
  end
end
