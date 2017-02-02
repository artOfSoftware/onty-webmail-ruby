module MailboxesHelper

#  :inbox = 1
#  :sent = 2
#  :archived = 3
#  :custom = 0

    
  def self.SendMessage( fromUserId, message )
    #TODO: verify fromId is valid
    accountId = fromUserId
    
    message.from_id    = fromUserId
    message.account_id = fromUserId
    message.folder_id  = Folder.get_folder_type_id( :sent )
    message.save!

    message2 = message.make_copy
    message2.account_id = message2.to_id
    message2.folder_id  = Folder.get_folder_type_id( :inbox )
    message2.save!

    return message.id
  end

  
#  def self.get_id_for_folder_type( accountId, typeSymbol )
#    folderTypeId = Folder.get_folder_type_id( typeSymbol )
#    f = Folder.where( account_id: 0, folder_type: folderTypeId ).first()
#    return f.id
#  end

  
#  def self.GetMessagesTo( accountId, userId )
#    Message.where("account_id=#{accountId} and to_id=#{userId}").find_each()
#  end
#
#  def self.GetMessagesFrom( accountId, userId )
#    Message.where("account_id=#{accountId} and from_id=#{userId}").find_each()
#  end

  def self.GetMessagesInFolder( accountId, folderId )
    Message.where("account_id=#{accountId} and folder_id=#{folderId}").find_each()
  end

  
  def self.GetNrMessagesInFolder( accountId, folderId, status=:any )

    if status==:any
      return Message.where( :account_id=>accountId, :folder_id=>folderId ).length
    else
      statusId = MessageStatus.GetStatusIdByName(status)
      return Message.where( :account_id=>accountId, :folder_id=>folderId, :status=>statusId).length
    end

  end

  
end
