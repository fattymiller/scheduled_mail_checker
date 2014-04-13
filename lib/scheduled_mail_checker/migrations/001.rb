module ScheduledMailChecker
  module Migrations
    module InitialDataSetup
      def self.included(klass)
        klass.class_eval do
          register_migrations_for [0,0,1] do |m|
            m.create_table :email_accounts do |t|
              t.string :name, :null => false
            
              t.datetime :available_from
              t.datetime :available_until
              
              t.string :encrypted_username, :null => false
              t.string :encrypted_password, :null => false
              
              t.string :server, :null => false
              t.integer :port
              t.boolean :ssl, :null => false, :default => false
            
              t.timestamps
            end

            m.create_table :received_emails do |t|
              t.references :email_account
              
              t.string :email_file_name
              t.integer :email_file_size
              t.string :email_content_type
              t.datetime :email_updated_at
            
              t.timestamps
            end

            m.create_table :email_account_handlers do |t|
              t.references :email_account
              t.string :handler_klass
            end
          end
        end
      end
    end
  end
end