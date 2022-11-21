# frozen_string_literal: true

namespace :tile do
  desc 'Populate tiles within a given region polygon'
  task populate_from_polygon: :environment do
    plot = Plot.last

    PlotTilesPopulateJob.perform_now(plot.id)
  end
end
