namespace :scheduled_mail_checker do
  desc "Run the mailman script against a specific email_account instance"
  task :check_account, [:email_account_id] => [:environment] do |t, args|
    email_account_id = args["email_account_id"].to_i

    email_account = ScheduledMailChecker::EmailAccount.find(email_account_id) if email_account_id > 0
    email_account.check_mail! if email_account
  end

end
