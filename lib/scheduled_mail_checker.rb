module ScheduledMailChecker
  class Tasks < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
end

puts "Installed at: #{File.dirname(__FILE__)}"