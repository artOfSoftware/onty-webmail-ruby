require 'test_helper'


class Integration02Test < ActionDispatch::IntegrationTest


  test "integration 02 a" do

    james_account = accounts( :james )

    james = login( :james )
    
    james.home
    
    james.root
    
    james.get '/'
    james.assert_response :redirect

    james.get_folder(1)
    james.get_folder(2)
    james.get_folder(3)

    message = Message.where( :account_id=>james_account.id ).last()
    
    james.get_message( message.id )
        
  end


  
private

  module ActorModule

    def root
      get '/'
      assert_response :redirect
    end

    def login( username, password )
      post '/accounts/login', :user=>{ :name=>username, :password=>password }
      assert_response :redirect
      assert_redirected_to '/accounts/home'
      follow_redirect!
      assert_equal '/accounts/home', path
    end

    def home
      get '/accounts/home'
      assert_response :success
    end

    def get_folder( folderId )
      
      folder = Folder.find( folderId )
      
      get "/mailboxes/#{folderId}/folder"

      assert_response :success
      assert_template 'folder'

      assert_match "View Mailbox: Folder <b>#{folder.name}", @response.body
    end

    def get_message( messageId )

      message = Message.find( messageId )
      
      get "/mailboxes/#{messageId}/message"

      assert_response :success
      assert_template 'message'

      assert_match "View a Message", @response.body
      assert_match message.subject, @response.body
      assert_match message.text, @response.body

    end
    
  end

  def login(account)
    
    open_session do |s|
      s.extend(ActorModule)
      a = accounts(account)
      s.login( a.name, a.name )
      #      sess.https!
      #      sess.https!(false)
    end

  end


end
