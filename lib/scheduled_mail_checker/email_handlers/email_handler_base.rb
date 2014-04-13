module ScheduledMailChecker
  class EmailHandlerBase
    
    def self.inherited(klass)
      instances << klass
    end
    def self.instances
      @@instances ||= []
    end
    
    def self.label
      name.titleize.humanize
    end
    
  end
end