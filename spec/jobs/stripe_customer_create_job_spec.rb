# frozen_string_literal: true

RSpec.describe StripeCustomerCreateJob do
  subject(:job) { described_class.new }

  let(:user) { create(:user) }

  describe '#perform' do
    before do
      stub_stripe_api(:post, 200, 'customers', 'create')
    end

    it 'creates a Stripe customer' do
      expect { job.perform(user) }.to change(user, :stripe_customer_id).to('cus_aoeuidhtns')
    end
  end
end
