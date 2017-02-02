class MessageStatus < ActiveRecord::Base

  
  def self.GetStatusNameById( id )
    raise "id must not be nil" if id.nil?
    MessageStatus.find( id ).name
  end

  def self.GetStatusIdByName( statusName )
    case ( statusName )
      when :unread then 0
      when :read then 1
      when :any then -1
      else raise "Unknown status #{statusName}"
    end
  end

    
end

