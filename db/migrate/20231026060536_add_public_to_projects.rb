class AddPublicToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :public, :boolean, null: false, default: true
  end
end
