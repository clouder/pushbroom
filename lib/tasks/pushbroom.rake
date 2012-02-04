namespace :pushbroom do
  task :full_sweep => :environment do
    PushbroomSweepers.full_sweep
  end

  task :manual_sweep, [:id] => :environment do |t, args|
    PushbroomSweepers.manual_sweep(args[:id])
  end
end

task :cron => :environment do
  Rake::Task['pushbroom:full_sweep'].invoke
end