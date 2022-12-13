# frozen_string_literal: true

require 'support/stripe_test_helper'

SECRET = ENV.fetch('STRIPE_WEBHOOK_SIGNING_SECRET')

RSpec.describe 'StripeWebhook' do
  describe 'GET #webhook' do
    subject(:run_hook) { post '/webhook/stripe', params: webhook_params.to_json, headers: }

    let(:headers) { { 'Stripe-Signature' => stripe_generate_header(payload: webhook_params.to_json) } }

    let(:webhook_params) { JSON.parse(file_fixture('stripe/checkout_session_completed.json').read) }

    it 'returns a 200 status code with json content type' do
      run_hook

      expect(response).to have_http_status(:ok)
    end

    it 'refreshes the stripe subscription' do
      expect { run_hook }.to enqueue_job(StripeSubscriptionRefreshJob)
    end
  end
end
