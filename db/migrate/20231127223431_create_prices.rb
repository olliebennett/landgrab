class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.references :project, null: false, foreign_key: true
      t.string :amount_display
      t.string :title
      t.string :stripe_id

      t.timestamps
    end
  end
end
