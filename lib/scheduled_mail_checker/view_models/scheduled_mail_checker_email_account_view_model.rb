class ScheduledMailChecker::EmailAccountViewModel < BaseJump::ViewModel::Base
  
  def form_fields
    groups = []
    
    groups << build_fields("General information", :name)
    groups << build_fields("Connection information", :username, :password)
    groups << build_fields(false, :server, :port, :ssl)
    # groups << build_fields(false, :check_delay)
    groups << build_fields("Handled by", :handlers)
  end
  
  def ssl_options(field_name, nested_under)
    { :label => "SSL" }
  end
  def server_options(field_name, nested_under)
    { :hint => "Must be a POP3 account" }
  end
  # def check_delay_options(field_name, nested_under)
  #   { :hint => "Minutes between checks" }
  # end
  def handlers_options(field_name, nested_under)
    { :as => :check_boxes, :label_method => "label" }
  end
  
  def password_format_method(email_account, password)
    show_page? ? "<small>Hidden</small>".html_safe : nil
  end
  # def check_delay_format_method(email_account, check_delay)
  #   pluralize(check_delay, "minute") if check_delay
  # end
  
end