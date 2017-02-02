require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  test "SetStatusRead" do
    m = messages( :james_two )
    assert_equal 0, m.status, "Initial state not as expected"  #is unread

    #go into DB and make sure status was saved
    m2 = Message.find(m.id)
    assert_equal 0, m2.status

    # change status    
    m.SetStatusRead
    assert_equal 1, m.status  #is read
    
    #go into DB and make sure status was saved
    m2 = Message.find(m.id)
    assert_equal 1, m2.status
  end

  test "SetStatus Read" do
    m = messages(:james_two)
    assert_equal 0, m.status, "Initial state not as expected"  #is unread

    #go into DB and make sure status was saved
    m2 = Message.find(m.id)
    assert_equal 0, m2.status

    # change status    
    m.SetStatus(1)
    assert_equal 1, m.status  #is read

    #go into DB and make sure status was saved
    m2 = Message.find(m.id)
    assert_equal 1, m2.status
  end

  test "SetStatus Unread" do
    m = messages(:james_one)
    assert_equal 1, m.status, "Initial state not as expected"  #is unread

    #go into DB and make sure status was saved
    m2 = Message.find(m.id)
    assert_equal 1, m2.status

    # change status    
    m.SetStatus(0)
    assert_equal 0, m.status  #is read

    #go into DB and make sure status was saved
    m2 = Message.find(m.id)
    assert_equal 0, m2.status
  end

  
end

