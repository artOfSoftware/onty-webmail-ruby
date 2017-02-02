require 'test_helper'

class MessageStatusTest < ActiveSupport::TestCase

#  test "call helper" do
#    assert_equal "is present", TestHelper.Something
#  end
  
  test "self.GetStatusNameById Unread" do
    ms = MessageStatus.GetStatusNameById(0)
    assert_equal "Unread", ms
  end

  test "self.GetStatusNameById Read" do
    ms = MessageStatus.GetStatusNameById(1)
    assert_equal "Read", ms
  end

  test "self.GetStatusNameById non-existent (neg)" do
    begin
      ms = MessageStatus.GetStatusNameById(789)
      assert_nil ms
    rescue ActiveRecord::RecordNotFound => ex
      assert_match "Couldn't find", ex.message
    end
  end

  test "self.GetStatusNameById nil (neg)" do
    begin
      ms = MessageStatus.GetStatusNameById(nil)
      assert_nil ms
    rescue RuntimeError => ex
      assert_match "id must not be nil", ex.message
    end
  end


end

