class AddShareLinkToPostViews < ActiveRecord::Migration[7.1]
  def change
    add_column :post_views, :shared_access_key, :string
  end
end
