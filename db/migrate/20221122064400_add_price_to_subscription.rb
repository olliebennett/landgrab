class AddPriceToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :price_pence, :integer
  end
end
