class MailboxesController < ApplicationController

  #include MailboxesHelper
  
  before_action :loggedin?
  #before_action :set_message, only: [:message]


  def debug
    flash[:notice] = "This is a notice."
    flash[:error]  = "This is an error."
    flash[:test]   = "This is a test."
    flash[:debug]  = "This is a debug."
  end


  # GET /mailboxes
  def index
    @folders = Folder.get_folders_for_account( session[:user] )
  end

  
#  # GET /mailboxes/inbox
#  def inbox
#    redirect_to :action=>'folder', :id=>1
#    #@messages = MailboxesHelper.GetMessagesTo( session[:user], session[:user] )
#  end
#
#  
#  # GET /mailboxes/sent
#  def sent
#    redirect_to :action=>'folder', :id=>2
#    #@messages = MailboxesHelper.GetMessagesFrom( session[:user], session[:user] )
#  end

  
  # GET /mailboxes/1/folder
  def folder
    folderId = params[:id]

    begin
      @folder = Folder.find(folderId)
    rescue => ex
      flash[:error] = "The folder with id #{folderId} does not exist"
      redirect_to :action=>'index'
      return
    end
      
    #check whether current user is the owner of this folder
    if @folder.account_id != session[:user] and @folder.account_id != 0
      flash[:error] = "You don't have permission to view that folder."
      redirect_to :action=>'index'
      return
    end
      
    @messages = MailboxesHelper.GetMessagesInFolder( session[:user], folderId )
  end


  # GET /mailboxes/1
  def message

    id = params[:id]

    #check if there is such a message
    begin
      @message = Message.find(id)
    rescue
      flash[:error]="Could not find message with id #{id}"
      redirect_to :action => 'index'
      return
    end

    if !@message
      flash[:error]="Could not find message with id #{id}"
      redirect_to :action => 'index'
      return
    end
        
    #check if it's in the user's mailbox
    if @message.account_id != session[:user]
      flash[:error]="Message with id #{id} does not belong to you"
      redirect_to :action => 'index'
      return
    end

    @message.SetStatusRead
    
    @folders = Folder.get_folders_for_account( session[:user] )

  end


  # GET /mailboxes/new
  def new
    @message = Message.new
    @accounts = Account.all
  end


  # POST /mailboxes/create
  def create

    params[:message].permit!
    @message = Message.new( params[:message] )
    messageId = MailboxesHelper.SendMessage( session[:user], @message )

    flash[:notice]="Message successfully sent"
    flash[:sent_message_id] = messageId
    redirect_to :action=>'index'
    
  end

  
  
  # POST /mailboxes/1/movemessage
  def movemessage

    messageId = params[:id]

    #check if there is such a message
    begin
      m = Message.find(messageId)
    rescue
      flash[:error]="Could not find message with id #{id}"
      redirect_to 'message'
      return
    end

    if !m
      flash[:error]="Could not find message with id #{id}"
      redirect_to 'message'
      return
    end
        
    #check if it's in the user's mailbox
    if m.account_id != session[:user]
      flash[:error]="Message with id #{id} does not belong to you"
      redirect_to 'message'  #TODO: in this case should redirect to index, since cannot view message either
      return
    end

    #change its folder
    fromFolderId = m.folder_id
    toFolderId = params[:message][:folder_id]

    if !toFolderId
      flash[:error] = "Folder with id #{toFolderId} is invalid so cannot move the message there."
    end
      
    m.folder_id = toFolderId
    result = m.save
    
    if ! result or ! m.errors.empty?
      flash[:error]="There was a problem saving the message back to the DB"
      redirect_to 'message'
      return
    end
      
    flash[:notice]="Message successfully moved"
    #redirect_to :action=>'index'
    redirect_to :action=>'message'

  end


    
  # GET /mailboxes/folders
  def folders

    @folders_system = Folder.where( :account_id=>0 )
    @folders_custom = Folder.where( :account_id=>session[:user] )

  end

  
  # GET /mailboxes/newfolder
  # POST /mailboxes/newfolder
  def newfolder
  
    if request.post?

      #POST

      if ! params[:folder]
        flash[:error] = 'Your submission did not make sense. Please try again.'
        return
      end

      params[:folder].permit!

      @folder = Folder.new( params[:folder] )
      @folder.account_id = session[:user]
      @folder.folder_type = 0   #custom
      
      if !@folder.save
        flash[:error] = "Error saving folder: #{@folder.errors}"
        return
      end
      
      @folder.reload
      
      id = @folder.id
        
      flash[:notice]="Folder was created successfully"
      #flash[:new_folder_id] = id
      redirect_to :action=>'folder', :id=>id

    else

      #GET
      @folder = Folder.new

    end  

  end



  # GET /mailboxes/newfolder
  # PATCH /mailboxes/newfolder
  def editfolder

    if request.patch?

      # PATCH
      
      if ! params[:folder]
        flash[:error] = 'Your submission did not make sense. Please try again.'
        return
      end
      
      params[:folder].permit!

      @folder = Folder.find( params[:id] )

      # make sure the user owns the folder. this also checks if this is a system folder.
      if @folder.account_id != session[:user]
        flash[:error] = "You cannot rename this folder because it's not yours"
        redirect_to :action=>'folders'
        return
      end

      @folder.name = params[:folder][:name]

      if !@folder.save
        flash[:error] = "Error saving folder: #{@folder.errors}"
        return
      end

      @folder.reload

      id = @folder.id

      flash[:notice]="Folder saved successfully"
      flash[:new_folder_id] = id
      redirect_to :action=>'folder', :id=>id

    else

      # GET
      @folder = Folder.find( params[:id] )

    end  

  end




private

  def loggedin?
    if session[:user]
      return true
    else
      flash[:notice] = 'Please login first'
      session[:return_to] = request.url
      redirect_to :controller=>'accounts', :action=>'login'
    end
    return false
  end


end

