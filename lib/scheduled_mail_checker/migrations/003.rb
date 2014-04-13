module ScheduledMailChecker
  module Migrations
    module AddTimeSettingsToEmailAccountModel
      def self.included(klass)
        klass.class_eval do
          register_migrations_for [0,0,3] do |m|
            m.add_column :email_accounts, :check_delay, :integer, default: 1, null: false
          end
        end
      end
    end
  end
end