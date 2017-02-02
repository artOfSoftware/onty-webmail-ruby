class Folder < ActiveRecord::Base


  def self.get_folders_for_account( accountId )
    folders = where( "account_id=#{accountId} or account_id=0" )
    return folders
  end


  def self.get_folder_type_id( typeSymbol )
    case( typeSymbol )
      when :inbox then 1
      when :sent then 2
      when :archived then 3
      else 0
    end
  end

  
#  def self.get_folder_name_by_id( folderId )
#    folder = find()
#    return folder.name
#  end

  
end
