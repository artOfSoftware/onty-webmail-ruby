#TEST: add test for viewing another user's account
#TEST: more tests for logout (can browse after logout?)


require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  setup do
    #@account = accounts(:one)
  end

  
  test "get index (unauth)" do
    get :index
    assert_response :redirect
    
    assert_redirected_to :action=>'login'
  end

  
  test "get home (unauth)" do
    get :home
    assert_response :redirect

    assert_redirected_to :action=>'login'
  end

  
  test "get login (unauth)" do
    get :login
    assert_response :success
  end

  test "post login no-data (unauth)" do
    post :login
    assert_response :success
  end

  test "post login valid-user (unauth)" do
    as = AccountSecret.get_by_user_id(0)
    #as.password = "abc"
    #as.save!

    a = Account.find(0)
    oldNrLogins = a.nr_logins
        
    post :login, :user=>{ :name=>a.name, :password=>a.name }
    # also had: id: @account, 
    assert_not_nil session[:user]
    #assert_match 'Login Successful', flash[:notices]
    assert_no_match 'Login unsuccessful', flash[:errors]
    assert_response :redirect
    assert_redirected_to :action=>'home'

    a = Account.find(0)
    assert_equal oldNrLogins+1, a.nr_logins
  end

  test "post login valid-user-invalid-password (unauth)" do
    post :login, :id=>@account, :user=>{ :name=>'userA', :password=>'qwerty' }
    assert_response :success
    assert_match 'Login unsuccessful', @response.body
  end

  test "post login invalid-user (unauth)" do
    post :login, :user=>{ :name=>'qwerty', :password=>'qwerty' }
    #id: @account, 
    assert_response :success
    assert_match 'Login unsuccessful', @response.body
  end


  
  test "get password (unauth)" do
    get :password
    assert_response :redirect
    assert_redirected_to :action=>'login'
  end

  test "patch password (unauth)" do
    patch :home
    assert_response :redirect
    assert_redirected_to :action=>'login'
  end




  test "get signup (unauth)" do
    get :signup
    assert_response :success
  end

  test "post signup (unauth)" do
    name = 'userX'

    # make sure such account does not already exist
    a = Account.where( :name=>name ).first()
    assert_nil a, "Account already exists in the DB"

    post :signup, :signup=>{ :name=>name, :fullname=>'User X', :email=>'userX@here.org', :password=>'userX', :password_confirmation=>'userX' }
    assert_response :redirect
    assert_redirected_to :action=>'home'
    assert_match 'Account', flash[:notice]
    assert_match 'created', flash[:notice]

    a = Account.where( "name='#{name}'" ).first()
    assert_not_nil a, "Newly created Account not found in DB table account"

    as = AccountSecret.where( "account_name='#{name}'" ).first()
    assert_not_nil a, "Newly created Account not found in DB table account_secrets"
    
    assert_equal 0, a.nr_logins
  end

  
  test "post signup as duplicate user (unauth)" do
    name = 'userA'

    # make sure such account does not already exist
    a = Account.where( :name=>name ).first()
    assert_not_nil a, "Account does not already exist in the DB, so cannot test duplicate user signup"

    post :signup, :signup=>{ :name=>name, :fullname=>'User A dupe', :email=>'userAA@here.org', :password=>'userAA', :password_confirmation=>'userAA' }
    assert_response :success
    #assert_redirected_to :action=>'home'
    assert_match 'already exists', flash[:error]
    #assert_match 'created', flash[:notice]

    aNr = Account.where( :name=>name ).length
    assert_equal 1, aNr, "expecting to find one account with such name, but found #{aNr}"

    asNr = AccountSecret.where( "account_name='#{name}'" ).length
    assert_equal 1, aNr, "expecting to find one account_secret with such name, but found #{aNr}"
  end



  test "get logout (unauth)" do
    get :logout
    assert_response :redirect
    assert_redirected_to :action=>'login'
  end

    

end

