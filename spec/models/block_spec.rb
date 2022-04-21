# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Block, type: :model do
  let(:block_params) { { w3w: 'aaa.bbb.ccc', southwest: 1, northeast: 1 } }
  let(:block) { described_class.new(block_params) }

  it 'is valid by default' do
    expect(block).to be_valid
  end

  describe '#validates w3w' do
    it 'rejects two-word what3words' do
      block.w3w = 'two.words'

      block.validate

      expect(block.errors[:w3w]).to include('format should be a.b.c')
    end

    it 'rejects extra what3words text' do
      block.w3w = 'something//one.two.three|garbage'

      block.validate

      expect(block.errors[:w3w]).to include('format should be a.b.c')
    end
  end
end
