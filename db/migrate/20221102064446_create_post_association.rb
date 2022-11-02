class CreatePostAssociation < ActiveRecord::Migration[7.0]
  def change
    create_table :post_associations do |t|
      t.references :post, null: false, foreign_key: true

      t.references :postable, polymorphic: true

      t.timestamps
    end
  end
end
