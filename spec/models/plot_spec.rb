require 'rails_helper'

RSpec.describe Plot, type: :model do
  let(:plot_params) { { title: 'hi', polygon: 'POLYGON ((-0.02018 51.51576, -0.02002 51.51591, -0.01981 51.51558, -0.02018 51.51576))' } }
  let(:plot) { described_class.new(plot_params) }

  it 'is valid by default' do
    expect(plot).to be_valid
  end

  it 'handles polygon with the correct rgeo method' do
    expect(plot.polygon).to be_a RGeo::Geos::CAPIPolygonImpl
  end
end
