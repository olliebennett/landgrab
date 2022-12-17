# frozen_string_literal: true

RSpec.describe 'Checkout' do
  before do
    allow(ENV).to receive(:fetch).and_call_original

    stub_stripe_api(:post, 200, 'checkout/sessions', 'new')
  end

  describe 'GET #generate' do
    subject(:do_get) { get '/checkout/generate', params: request_params }

    let(:request_params) { { freq: 'monthly' } }
    let(:stripe_url) { 'https://checkout.stripe.com/c/pay/cs_test_aaaaaa#bbbbbb%2Fccccccc' }

    let(:user) { create(:user) }

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_call_original
    end

    it 'redirects to the stripe checkout url' do
      do_get

      expect(response).to redirect_to(stripe_url)
    end
  end
end
