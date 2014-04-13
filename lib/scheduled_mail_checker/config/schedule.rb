class ScheduledMailChecker::Schedule < BaseJump::Scheduler::Base
  
  def self.load_schedule
    ScheduledMailChecker::EmailAccount.current.group_by(&:check_delay).each do |delay, accounts|
      every delay.minutes do
        # one runner/task for each mailbox to check
        accounts.each do |email_account|
          rake "\"scheduled_mail_checker:check_account[#{email_account.id}]\"", job_template: nil
        end
      end
    end
    
  end  
end