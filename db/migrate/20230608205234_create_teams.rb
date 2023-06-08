class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :title
      t.string :slug
      t.string :logo_url
      t.string :website
      t.string :description

      t.timestamps
    end

    add_index :teams, :slug, unique: true
  end
end
