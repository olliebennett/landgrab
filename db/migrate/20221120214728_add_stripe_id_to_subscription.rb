class AddStripeIdToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :stripe_id, :string, null: false
    add_index :subscriptions, :stripe_id, unique: true
  end
end
