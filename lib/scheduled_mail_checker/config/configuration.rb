# module ScheduledMailChecker
#   class Configuration
#     include Singleton
#     
#     def 
#     
#     private
#     
#     def mailman
#       @mailman ||= Mailman.config
#     end
#   end
#   
#   def self.config
#     yield(ScheduledMailChecker::Configuration.instance)
#   end
# end