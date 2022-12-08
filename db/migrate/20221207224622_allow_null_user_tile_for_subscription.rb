class AllowNullUserTileForSubscription < ActiveRecord::Migration[7.0]
  def change
    change_column_null :subscriptions, :user_id, true
    change_column_null :subscriptions, :tile_id, true
  end
end
