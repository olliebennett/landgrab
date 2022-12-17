class CreatePromoCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :promo_codes do |t|
      t.string :code, nil: false
      t.string :stripe_id, nil: false

      t.timestamps
    end

    add_index :promo_codes, :code, unique: true
    add_index :promo_codes, :stripe_id, unique: true
  end
end
