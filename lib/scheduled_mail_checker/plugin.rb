require_relative "version"

require_relative "migrations/001"
require_relative "migrations/002"
require_relative "migrations/003"

module ScheduledMailChecker
  class Plugin < BaseJump::Plugins::Base
    include Migrations::InitialDataSetup
    include Migrations::AddTrackingToReceivedEmailModel
    include Migrations::AddTimeSettingsToEmailAccountModel
    
    register "b0df1997-35e9-428a-bcf1-ff5aebe6a32b", :version => ScheduledMailChecker::VERSION.split(".")
  end
end

require_relative "controllers/routes"
require_relative "controllers/email_accounts_controller"

require_relative "view_models/scheduled_mail_checker_email_account_view_model"
require_relative "view_models/scheduled_mail_checker_received_email_view_model"

require_relative "models/email_account"
require_relative "models/received_email"
require_relative "models/email_account_handler"

require_relative "config/schedule"
require_relative "email_handlers/email_handler_base"