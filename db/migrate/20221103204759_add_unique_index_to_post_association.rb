class AddUniqueIndexToPostAssociation < ActiveRecord::Migration[7.0]
  def change
    add_index :post_associations,
              [:post_id, :postable_type, :postable_id],
              unique: true,
              name: :index_post_associations_on_post_and_postable
  end
end
