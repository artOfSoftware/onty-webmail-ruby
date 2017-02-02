require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  test "always passes" do
    assert true
  end

  
  test "make account" do
    a = Account.new
  end

  test "make account B" do
    a = Account.new
    a.name = "userC"
    a.fullname = "Full Name"
    a.email = "me@here.com"
    a.nr_logins = 14
    a.validate!
  end

  test "make account with bad Name (neg)" do
    begin
      a = Account.new
      a.name = "u"  #too short
      a.fullname = "Full Name"
      a.email = "me@here.com"
      a.nr_logins = 14
      a.validate!
      flunk "Expecting an exception but did not get one"
    rescue ActiveRecord::RecordInvalid =>ex
      assert_match "Name is too short", ex.message
    end
  end

  test "make account with bad Fullname (neg)" do
    begin
      a = Account.new
      a.name = "userC"
      a.fullname = "F"
      a.email = "me@here.com"
      a.nr_logins = 14
      a.validate!
      flunk "Expecting an exception but did not get one"
    rescue ActiveRecord::RecordInvalid => ex
      assert_match "Fullname is too short", ex.message
    end
  end

  test "make account with bad Email (neg)" do
    begin
      a = Account.new
      a.name = "userC"
      a.fullname = "Full Name"
      a.email = "a"
      a.nr_logins = 14
      a.validate!
      flunk "Expecting an exception but did not get one"
    rescue ActiveRecord::RecordInvalid => ex
      assert_match "invalid", ex.message
    end
  end

  test "make account with nil NrLogins (neg)" do
    begin
      a = Account.new
      a.name = "userC"
      a.fullname = "Full Name"
      a.email = "a@b.com"
      a.nr_logins = nil
      a.validate!
      flunk "Expecting an exception but did not get one"
    rescue ActiveRecord::RecordInvalid => ex
      assert_match "Nr logins is not a number, Nr logins can't be blank", ex.message
    end
  end

  test "make account with NrLogins<0 (neg)" do
    begin
      a = Account.new
      a.name = "userC"
      a.fullname = "Full Name"
      a.email = "a@b.com"
      a.nr_logins = -1
      a.validate!
      flunk "Expecting an exception but did not get one"
    rescue ActiveRecord::RecordInvalid => ex
      assert_match "Nr logins must be greater than or equal to 0", ex.message
    end
  end

  test "GetDisplayName" do
    a = Account.find(0)
    fn = a.GetDisplayName
    assert_equal "#{a.fullname} (#{a.name})", fn
  end

  test "GetDisplayNameById" do
    fn = Account.GetDisplayNameById(0)
    a = Account.find(0)
    assert_equal "#{a.fullname} (#{a.name})", fn
  end
  
    
end
