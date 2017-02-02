require 'test_helper'

class AccountSecretTest < ActiveSupport::TestCase

  
  test "make account_secret" do
    #begin
      as = AccountSecret.new
      as.account_id = "71"
      as.account_name = "userC"
      as.password = "mypass"
      as.validate!
    #  flunk "Expecting an exception but did not get one"
    #rescue ActiveRecord::RecordInvalid => ex
    #  assert_match "Nr logins must be greater than or equal to 0", ex.message
    #end
  end



  test "self.make_random_string" do
    s = AccountSecret.make_random_string(34)
    assert_equal 34, s.length
  end

  test "self.make_random_string len<1 (neg)" do
    begin
      s = AccountSecret.make_random_string(0)
      flunk "Expecting an exception but did not get one"
    rescue Exception => ex
      assert_match "Length", ex.message
    end
  end


  test "self.make_random_string len>71 (neg)" do
    begin
      s = AccountSecret.make_random_string(71+1)
      flunk "Expecting an exception but did not get one"
    rescue Exception => ex
      assert_match "Length", ex.message
    end
  end

  
  test "self.hash_password" do
    for i in (1..71) do
      pass = AccountSecret.make_random_string(i)
      salt = AccountSecret.make_random_string(10)
      hp = AccountSecret.hash_password(pass,salt)
      assert_equal 64, hp.length
    end
  end

  test "self.hash_password short password (neg)" do
    #assert_raise Exception
    begin
      pass = ""
      salt = AccountSecret.make_random_string(10)
      hp = AccountSecret.hash_password(pass,salt)
    rescue Exception => ex
      assert_match 'Password must', ex.message
    end
  end

  test "self.hash_password nil password (neg)" do
    #assert_raise Exception
    begin
      pass = nil
      salt = AccountSecret.make_random_string(10)
      hp = AccountSecret.hash_password(pass,salt)
    rescue Exception => ex
      assert_match 'Password cannot', ex.message
    end
  end

  test "self.hash_password short salt (neg)" do
    #assert_raise Exception
    begin
      pass = "mypass"
      salt = ""
      hp = AccountSecret.hash_password(pass,salt)
    rescue Exception => ex
      assert_match 'Password Salt must', ex.message
    end
  end

  test "self.hash_password nil salt (neg)" do
    #assert_raise Exception
    begin
      pass = "mypass"
      salt = nil
      hp = AccountSecret.hash_password(pass,salt)
    rescue Exception => ex
      assert_match 'Password Salt cannot', ex.message
    end
  end

  
  test "self.get_by_user_id" do
    as = account_secrets( :james )
    as2 = AccountSecret.get_by_user_id( as.account_id )
    assert_equal as.account_id, as2.account_id
  end


  test "self.authenticate" do
    # get object from fixtures
    as = account_secrets( :suzanna )

#    # make new password
#    newPassword = "newPass"
#    as.password = newPassword
#
#    # save into DB
#    status = as.save!
#    assert true, status
#    assert_equal 0, as.errors.size
    
    # call authenticate (which reads DB)
    as2 = AccountSecret.authenticate( as.account_name, as.account_name )
    assert_not_nil as2

    # make sure what we read from DB and what we had before are the same thing
    assert_equal as, as2
  end

  test "self.authenticate invalid user (neg)" do
    as = account_secrets( :james )
    a = AccountSecret.authenticate( as.account_name<<"a", as.account_name )
    assert_nil a
  end

  test "self.authenticate invalid pass (neg)" do
    as = account_secrets( :james )
    a = AccountSecret.authenticate( as.account_name, as.account_name<<"a" )
    assert_nil a
  end

  test "password=" do
    as = account_secrets( :james )
    oldhash = as.password_hash
    as.password="abc"
    assert_not_equal oldhash, as.password_hash
  end

  test "password=nil (neg)" do
    begin
      as = account_secrets( :james )
      as.password=nil
    rescue RuntimeError => ex
      assert_match 'Password', ex.message
      assert_match 'nil', ex.message
    end
  end

  test "password=empty (neg)" do
    begin
      as = account_secrets( :james )
      as.password=""
    rescue RuntimeError => ex
      assert_match 'Password', ex.message
      assert_match 'length', ex.message
    end
  end

  test "clear_password!" do
    as = account_secrets( :james )
    assert as.password_salt.length > 0
    assert as.password_hash.length > 0
    as.clear_password!
    assert as.password_salt.length == 0
    assert as.password_hash.length == 0
    assert as.password_salt.empty?
    assert as.password_hash.empty?
  end


end

