class AddSubscriberBenefitsToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :subscriber_benefits, :text
  end
end
