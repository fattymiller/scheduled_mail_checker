module ScheduledMailChecker
  module Migrations
    module AddTrackingToReceivedEmailModel
      def self.included(klass)
        klass.class_eval do
          register_migrations_for [0,0,2] do |m|
            m.add_column :received_emails, :from_address, :string
            m.add_column :received_emails, :subject, :string
            m.add_column :received_emails, :internal_message_identifier, :string
          end
        end
      end
    end
  end
end