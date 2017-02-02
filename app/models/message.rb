class Message < ActiveRecord::Base

  def SetStatusRead
    SetStatus(1)  #:read
  end
  
  def SetStatus( status )
    # make sure this is a valid status
    raise "Invalid Status" if MessageStatus.GetStatusNameById(status).nil?

    self.status = status
    result = save
    
    raise "Did not save status" if !result
  end

  
#  def copy_from!( m2 )
#    account_id = m2.account_id
#    from_id    = m2.from_id
#    to_id      = m2.to_id
#    subject    = m2.subject
#    text       = m2.text
#    status     = m2.status
#  end

  def make_copy()
    m2 = Message.new
    m2.account_id = account_id
    m2.from_id    = from_id
    m2.to_id      = to_id
    m2.subject    = subject
    m2.text       = text
    m2.status     = status
    return m2
  end
  
  
end
