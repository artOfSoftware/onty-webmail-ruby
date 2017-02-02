require 'test_helper'

class Integration01Test < ActionDispatch::IntegrationTest

  test "integration 01 a" do
  
    name = 'userX'

    # make sure such account does not already exist
    a = Account.where( :name=>name ).first()
    assert_nil a, "Account already exists in the DB"

    # get main page
    
    get '/'
    assert_response :redirect
    assert_redirected_to :controller=>:accounts, :action=>:login

    # get signup page

    follow_redirect!

    assert_response :success
    assert_equal '/accounts/login', path    
    assert_match 'Account Login', @response.body

    #get :controller=>:account, :action=>:signup

    get '/accounts/signup'
    assert_response :success
    assert_match 'Account Signup', @response.body

    # post signup page

    post '/accounts/signup', :signup=>{ :name=>name, :fullname=>'User X', :email=>'userX@here.org', :password=>'userX', :password_confirmation=>'userX' }
    assert_response :redirect
    assert_redirected_to :action=>:home
    assert_match 'Account', flash[:notice]
    assert_match 'created', flash[:notice]

    a = Account.where( :name=>name ).first()
    assert_not_nil a, "Newly created Account not found in DB table account"

    as = AccountSecret.where( :account_name=>name ).first()
    assert_not_nil a, "Newly created Account not found in DB table account_secrets"
    
    assert_equal 0, a.nr_logins
    
  end


end
