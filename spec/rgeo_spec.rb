require 'rails_helper'

RSpec.describe 'RGeo' do
  it 'is supported' do
    expect(RGeo::Geos).to be_supported
  end
end
