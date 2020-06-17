class CreateBlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :blocks do |t|
      t.st_point :southwest, null: false
      t.st_point :northeast, null: false
      t.string :w3w, null: false

      t.timestamps
    end
  end
end
