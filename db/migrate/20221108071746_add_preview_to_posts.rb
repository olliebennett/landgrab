class AddPreviewToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :preview, :text
  end
end
