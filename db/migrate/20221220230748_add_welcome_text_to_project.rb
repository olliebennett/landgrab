class AddWelcomeTextToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :welcome_text, :text
  end
end
