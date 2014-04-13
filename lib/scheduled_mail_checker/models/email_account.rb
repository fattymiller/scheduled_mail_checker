module ScheduledMailChecker
  class EmailAccount < ActiveRecord::Base
    include BaseJump::Expirable
    
    has_many :handlers, :class_name => "ScheduledMailChecker::EmailAccountHandler"
    
    has_many :received_emails, :class_name => "ScheduledMailChecker::ReceivedEmail"
    
    attr_encrypted :username, :key => :username_encryption_key
    attr_encrypted :password, :key => :password_encryption_key
    
    expirable_on :lower => :available_from, :upper => :available_until
    
    validates_numericality_of :check_delay, only_integer: true, greater_than_or_equal_to: 1
    
    def check_mail!
      check_for_mail
    end
    def process_email(message)
      temp_file = Tempfile.new([message_filename(message), ".eml"])
      temp_file.write(message)
      temp_file.rewind

      received_emails.create!({ email: temp_file, from_address: message.from.first, subject: message.subject }).delay.parse!

      temp_file.close
      temp_file.unlink # delete the TempFile      
    end
    
    def username_encryption_key
      Digest::SHA512.hexdigest(Digest::SHA512.hexdigest(encryption_key_base)).reverse
    end
    def password_encryption_key
      Digest::SHA512.hexdigest(Digest::SHA512.hexdigest(encryption_key_base).reverse)
    end
        
    def log_debug(message)
      puts message
      Mailman.logger.debug message
    end
    def log_info(message)
      puts message
      Mailman.logger.info message
    end
    def log_error(message)
      puts message
      Mailman.logger.error message
    end

    private
    
    def safe_file_name
      username.to_s.parameterize.underscore
    end
    def log_file_name
      "#{safe_file_name}.log"
    end
    def lock_filename
      "#{safe_file_name}_#{id}.lock"
    end
    def message_filename(message)
      filename = message.date.strftime('%Y%m%d%H%M%S')
      filename += "#{safe_file_name}_#{message.subject.underscore.parameterize.underscore}"[0..100]
      
      "#{filename}.eml"
    end
    
    def encryption_key_base
      Rails.application.config.secret_key_base.to_s.reverse
    end
    
    def mailman_settings
      @settings ||= {
        server:   self[:server],
        port:     self[:port],
        ssl:      self[:ssl],
        
        username: self.username,
        password: self.password
      }
    end
    
    def setup_listener
      log_debug " - Setting up listener (#{Rails.env.to_s})..."
    
      Mailman.config.ignore_stdin = true
      Mailman.config.logger = Logger.new(Rails.root.join("log/#{log_file_name}"))
      
      Mailman.config.poll_interval = 0
      Mailman.config.graceful_death = true
      Mailman.config.pop3 = mailman_settings
    end
    def check_for_mail
      setup_listener
      
      lock_file_path = "./#{lock_filename}"
    
      if File.exists?(lock_file_path)
        log_info "   - Lock file detected, bailing."
        return
      end
    
      log_debug " -- creating lock file.."

      lockfile = File.new(lock_file_path, 'w+')
      lockfile.write("lock file to prevent mailman from running on top of itself")
      lockfile.close
    
      begin
        log_info " - Logging in..."
        
        email_account_instance = self
    
        Mailman::Application.run do
          email_account_instance.log_info " - Mail listener starting for: (#{email_account_instance.username})" unless Mailman.config.maildir
          email_account_instance.log_info " - Mail listener using test directory: #{Mailman.config.maildir}" if Mailman.config.maildir
          email_account_instance.handlers.collect(&:handler_klass).each { |handler_klass| puts "   - Using handler: \"#{handler_klass}\"" }

          from('%email%').subject('%subject%') do
            email_account_instance.log_info " - Fetching email '#{params["subject"]}' from #{params["email"]}."
            email_account_instance.process_email(message)
          end
        end
        
        log_info " - Mail listener finished"
    
      rescue => e
        log_error " >> error detected! #{e.message}"
        log_error e.backtrace.join("\r\n")
      rescue Exception => e
        log_error " >> FATAL error detected! #{e.message}"
        log_error e.backtrace.join("\r\n")

        raise
      ensure
        log_debug " -- deleting lock file.."

        # always delete this file
        File.delete(lock_file_path) if File.exists?(lock_file_path)
      end
    end    
  end
end