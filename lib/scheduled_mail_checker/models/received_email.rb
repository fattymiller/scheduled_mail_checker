module ScheduledMailChecker
  class ReceivedEmail < ActiveRecord::Base    
    belongs_to :email_account, :class_name => "ScheduledMailChecker::EmailAccount"
    
    has_attached_file :email
    validates_attachment_content_type :email, :content_type => "message/rfc822"
    
    def parse!
      return if !email_account
      return if !email
      
      email_account.handlers.each { |handler| handler.parse(email) }
    end
    
  end
end