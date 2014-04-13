class ScheduledMailChecker::ReceivedEmailViewModel < BaseJump::ViewModel::Base
  
  def index_fields(scope = nil)
    [:from_address, :subject, :created_at]
  end
  
  def from_address_header
    "From"
  end
  def created_at_header
    "Received"
  end
  
end