class AddLatestSubscriptionToTile < ActiveRecord::Migration[7.0]
  def change
    add_reference :tiles, :latest_subscription, foreign_key: { to_table: :subscriptions }
  end
end
