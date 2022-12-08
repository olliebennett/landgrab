class AddClaimEmailHashToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :claim_email, :string
    add_column :subscriptions, :claim_hash, :string
  end
end
