class RenameBlockToTile < ActiveRecord::Migration[7.0]
  def change
    rename_table :blocks, :tiles

    rename_column :subscriptions, :block_id, :tile_id
  end
end
