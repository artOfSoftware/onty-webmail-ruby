require 'test_helper'

class MailboxesControllerTest < ActionController::TestCase


  # TEST: add tests as unauthenticated user


  setup do
    # make it look like we have logged in
    session[:user] = accounts( :james ).id
    assert_equal accounts( :james ).id, session[:user]
  end
  
  
  test "get index" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    get :index

    assert_response :success
    assert_template 'index'

    assert_match "View Mailbox", @response.body
    assert_match "You have", @response.body
    
  end

  
  test "get index unauthenticated (neg)" do

    #make sure we are NOT logged in
    session.delete( :user )
    assert_nil session[:user], "logged in before neg test"

    get :index

    assert_response :redirect
    assert_redirected_to :controller=>'accounts', :action=>'login'
    
  end

  
  test "get inbox unauthenticated (neg)" do

    #make sure we are NOT logged in
    session.delete( :user )
    assert_nil session[:user], "logged in before neg test"

    get :folder, :id=>1

    assert_response :redirect
    assert_redirected_to :controller=>'accounts', :action=>'login'
    
  end

  
  test "get inbox/sent/archived" do

    [ :inbox, :sent, :archived ].each do |f|
      #make sure we are logged in
      assert_not_nil session[:user], "not logged in before test"
  
      folder = Folder.find( Folder.get_folder_type_id( f ) )
        
      get :folder, :id=>Folder.get_folder_type_id(f)
  
      assert_response :success
      assert_template 'folder'
  
      # TEST: make sure folder name on the page is the correct one
      
      assert_match "View Mailbox: Folder <b>#{folder.name}", @response.body
      
    end
  end

  
  test "get custom folder" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    folder = folders( 'james_custom' )
    
    get :folder, :id=>folder.id

    assert_response :success
    assert_template 'folder'

    assert_match "View Mailbox: Folder <b>#{folder.name}", @response.body
    
  end



  test "get folder invalid (neg)" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    get :folder, :id=>34000

    assert_response :redirect
    assert_redirected_to :action=>'index'
    
    assert_match "The folder with id 34000 does not exist", flash[:error]
    
  end

  
  test "get custom folder of another user (neg)" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    folder = folders( 'suzanna_custom' )
    
    get :folder, :id=>folder.id

    assert_response :redirect
    assert_redirected_to :action => :index

    assert_match "You don't have permission to view that folder.", flash[:error]
    
  end

  
  test "get message" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    m = messages( 'james_one' )
      
    get :message, :id=>m.id

    assert_response :success
    assert_template 'message'

    assert_match "View a Message", @response.body
    assert_match m.subject, @response.body
    assert_match m.text, @response.body
    
  end

  
  test "get message of another user (neg)" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    m = messages( 'suzanna_one' )
      
    get :message, :id=>m.id

    assert_response :redirect
    assert_redirected_to :action=>'index'

    assert_match "does not belong to you", flash[:error]
    
  end

  
  test "get message of another user 2 (neg)" do

    #make sure we are logged in
    session[:user] = accounts( :suzanna ).id
    assert_not_nil session[:user], "not logged in before test"

    m = messages( 'james_one' )
    
    get :message, :id=>m.id

    assert_response :redirect
    assert_redirected_to :action=>'index'

    assert_match "does not belong to you", flash[:error]
    
  end

  
  test "get invalid message (neg)" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    id = 34000
    
    get :message, :id=>id

    assert_match "Could not find message with id #{id}", flash[:error]

    assert_response :redirect
    assert_redirected_to :action=>'index'
    
  end


  test "get message unauthenticated (neg)" do

    #make sure we are NOT logged in
    session.delete( :user )
    assert_nil session[:user], "logged in before neg test"

    m = messages( 'suzanna_one' )
      
    get :message, :id=>m.id

    assert_match 'Please login first', flash[:notice]
    
    assert_response :redirect
    assert_redirected_to :controller=>'accounts', :action=>'login'
    
  end

  
  test "get new, then post create (send message)" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    a1 = accounts( 'james' )
    a2 = accounts( 'suzanna' )

    nrMessages = Message.count
    
    get :new

    assert_response :success
    assert_template 'new'

    post :create, :message=>{ :to_id=>a2.id, :subject=>'subject of test message', :text=>'text of test message' }
    #_via_redirect
    #TEST: authenticity token?

    assert_response :redirect
    assert_redirected_to :action=>'index'
    #assert_template 'index'

    #follow_redirect!

    #assert_response :success
    #assert_template 'index'

    #assert_match 'Message successfully sent', flash[:message]

    #assert_matches 'the message you just sent', @response.body


    nrMessagesAfter = Message.count

    assert_equal nrMessages+2, nrMessagesAfter, "Number of messages did not increase by two. Was #{nrMessages} and became #{nrMessagesAfter}"

    #TEST:  more testing on sent/delivered message: verify fields
    
  end

  
  test "get new as unauth (neg)" do

    #make sure we are NOT logged in
    session.delete( :user )
    assert_nil session[:user], "test requires an unauthenticated user"

    nrMessages = Message.count
    
    get :new

    assert_response :redirect
    assert_redirected_to :controller=>'accounts', :action=>'login'

    nrMessagesAfter = Message.count

    assert_equal nrMessages, nrMessagesAfter, "Number of messages was supposed to stay the same, but was #{nrMessages} and became #{nrMessagesAfter}"

  end


  test "post create as unauth user (neg)" do

    #make sure we are logged in
    session.delete( :user )
    assert_nil session[:user], "test requires an unauthenticated user"

    a = accounts( :james )
      
    nrMessages = Message.count
    
    post :create, message=>{ :to_id=>a.id, :subject=>'subject of test message', :text=>'text of test message' }
    #TEST: authenticity token?

    assert_response :redirect
    assert_redirected_to :controller=>'accounts', :action=>'login'

    nrMessagesAfter = Message.count

    assert_equal nrMessages, nrMessagesAfter, "Number of messages was supposed to stay the same, but was #{nrMessages} and became #{nrMessagesAfter}"

  end

  
  test "get newfolder, then post newfolder (create folder)" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    a1 = accounts( 'james' )

    nrFolders = Folder.where( :account_id => a1.id ).count
    
    get :newfolder

    assert_response :success
    assert_template 'newfolder'

    folderName = 'New Folder'
    
    post :newfolder, :folder=>{ :name=>folderName }
    #TEST: authenticity token?

    assert_response :redirect
    #assert_redirected_to :action=>'viewfolder'

    #assert_match "View Mailbox: Folder #{folderName}"
    #sassert_match 'Folder was created successfully', flash[:message]
    
    nrFoldersAfter = Folder.where( :account_id => a1.id ).count

    assert_equal nrFolders+1, nrFoldersAfter, "Number of folders was supposed to increase by 1. Was #{nrFolders} and became #{nrFoldersAfter}"

  end


  test "get editfolder, then post editfolder (rename folder)" do

    #make sure we are logged in
    assert_not_nil session[:user], "not logged in before test"

    folder = folders( 'james_custom' )
    account = accounts( 'james' )

    nrFolders = Folder.where( :account_id => account.id ).count
    
    assert_equal account.id, folder.account_id, "bad test setup: this is supposed to be our user's folder"
    
    get :editfolder, :id=>folder.id

    assert_response :success
    assert_template 'editfolder'

    folderNameNew = folder.name << " renamed"

    patch :editfolder, :id=>folder.id, folder=>{ :name=>folderNameNew }
    #TEST: authenticity token?

    assert_response :redirect
    assert_redirected_to :action=>'folder'

    #get 'folders'

    #puts @response.body
    
    
    #assert_match 'Folder saved successfully', flash[:message]
    #assert_match "View Mailbox: Folder <b>#{folderNameNew}", @response.body

    # make sure nr of folders stayed the same
    nrFoldersAfter = Folder.where( :account_id => account.id ).count
    assert_equal nrFolders, nrFoldersAfter, "Number of folders was supposed to stay the same. Was #{nrFolders} and became #{nrFoldersAfter}"

    # make sure folder has new name in DB
    folderAgain = Folder.find( folder.id )
    assert_equal folderNameNew, folderAgain.name
    
  end


  # TEST: add tests for actions: newfolder as unauth, as bad post
  # TEST: add tests for actions: editfolder as unauth, as invalid folder id, as bad post

end
