require 'rails_helper'

RSpec.describe Plot, type: :model do
  let(:plot_params) { { title: 'hi', polygon: 'POLYGON ((-0.02018 51.51576, -0.02002 51.51591, -0.01981 51.51558, -0.02018 51.51576))' } }
  let(:plot) { described_class.new(plot_params) }

  it 'is valid by default' do
    expect(plot).to be_valid
  end

  it 'handles polygon centroid' do
    # See https://github.com/olliebennett/landgrab/issues/1
    expect(plot.polygon.methods).to include :centroid
  end
end
