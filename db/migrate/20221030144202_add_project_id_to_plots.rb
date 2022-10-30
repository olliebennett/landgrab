class AddProjectIdToPlots < ActiveRecord::Migration[7.0]
  def change
    add_reference :plots, :project, foreign_key: true
  end
end
