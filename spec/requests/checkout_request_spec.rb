# frozen_string_literal: true

RSpec.describe 'Checkout' do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('STRIPE_PRICE_ID_BLOCK_MONTHLY').and_return('price_123monthly')

    stub_stripe_api(:post, 200, 'checkout/sessions', 'new')
  end

  describe 'GET #generate' do
    subject(:do_get) { get '/checkout/generate', params: request_params }

    let(:request_params) { { freq: 'monthly' } }
    let(:stripe_url) { 'https://checkout.stripe.com/c/pay/cs_test_aaaaaa#bbbbbb%2Fccccccc' }

    let(:user) { create(:user) }
    let(:promo_code) { create(:promo_code) }

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_call_original
    end

    it 'redirects to the stripe checkout url' do
      do_get

      expect(response).to redirect_to(stripe_url)
    end

    it 'passes a promo code when one is provided' do
      request_params[:code] = promo_code.code

      do_get

      expect(Stripe::Checkout::Session).to have_received(:create).with(hash_including(discounts: [{ promotion_code: promo_code.stripe_id }]))
    end
  end
end
