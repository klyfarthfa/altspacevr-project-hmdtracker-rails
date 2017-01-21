require 'test_helper'

class HmdStateTest < ActiveSupport::TestCase
  test "can create a HmdState" do
    hmd_state = HmdState.new
    hmd_state.state = :announced
    hmd_state.hmd_id = Hmd.first.id
    assert hmd_state.save
  end
end
