namespace :block do
  desc 'Populate blocks within a given region polygon'
  task populate_from_polygon: :environment do
    plot = Plot.last

    PlotBlocksPopulateJob.perform_now(plot.id)
  end
end
