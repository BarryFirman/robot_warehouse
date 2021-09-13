# frozen_string_literal: true

namespace :robot do
  desc 'initialise application'
  task init: :environment do
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end

  desc 'reinitialise application'
  task reset: :environment do
    Rake::Task["db:drop"]
    Rake::Task["robot:init"]
  end
end
