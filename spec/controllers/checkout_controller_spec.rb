# frozen_string_literal: true

RSpec.describe CheckoutController do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('STRIPE_PRICE_ID_BLOCK_MONTHLY').and_return('price_123monthly')

    stub_stripe_api(:post, 200, 'checkout/sessions', 'new')
  end

  describe 'GET generate' do
    let(:stripe_url) { 'https://checkout.stripe.com/c/pay/cs_test_aaaaaa#bbbbbb%2Fccccccc' }

    let(:user) { create(:user) }
    let(:promo_code) { create(:promo_code) }
    let(:price) { create(:price) }

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_call_original
    end

    it 'returns see other status' do
      get :generate, params: { price: price.hashid }

      expect(response).to have_http_status(:see_other)
    end

    it 'redirects to the stripe checkout url' do
      get :generate, params: { price: price.hashid }

      expect(response).to redirect_to(stripe_url)
    end

    it 'generates a checkout with price specified' do
      get :generate, params: { price: price.hashid }

      expect(Stripe::Checkout::Session).to have_received(:create).with(hash_including(line_items: [{ price: price.stripe_id, quantity: 1 }]))
    end

    it 'passes a promo code when one is provided' do
      get :generate, params: { price: price.hashid, code: promo_code.code }

      expect(Stripe::Checkout::Session).to have_received(:create).with(hash_including(discounts: [{ promotion_code: promo_code.stripe_id }]))
    end
  end
end
