Rails.application.routes.prepend do
  resources :email_accounts, controller: "scheduled_mail_checker/email_accounts", as: :scheduled_mail_checker_email_accounts
end