class AddRecurringIntervalToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :recurring_interval, :integer
  end
end
