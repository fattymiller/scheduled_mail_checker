module ScheduledMailChecker
  class EmailAccountHandler < ActiveRecord::Base    
    belongs_to :email_account, :class_name => "ScheduledMailChecker::EmailAccount"
    
    def parse(email)
      begin
        klass = handler_klass.safe_constantize
        klass.parse(email) if klass
      rescue Exception => e
        puts e.message
        puts e.backtrace.join("\r\n")
        puts "Note: '#{handler_klass}' needs to respond to .parse(email) before it can be used as an email handler. Where email is a Paperclip::Attachment instance."
        
        raise
      end
    end
    
    def label
      handler_klass.to_s.titleize.humanize
    end
  end
end