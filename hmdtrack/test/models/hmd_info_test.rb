require 'test_helper'

class HmdInfoTest < ActiveSupport::TestCase
  test "can create a hmd" do
    hmd = Hmd.new
    hmd.name = 'Rift'
    hmd.company = 'Oculus'
    hmd.image_url = 'http://i.imgur.com/EY3KHSz.jpg'
    hmd.announced_at = Time.now
    hmd.state = :announced
    hmd.save!

    assert hmd
  end

  test "hmd state starts with :announced" do
    hmd = Hmd.new
    hmd.name = 'Rift'
    hmd.company = 'Oculus'
    hmd.image_url = 'http://i.imgur.com/EY3KHSz.jpg'
    hmd.announced_at = Time.now
    hmd.save!

    assert_equal :announced, hmd.state
  end

  test "state is a symbol" do
    hmd = Hmd.first
    assert hmd.state.is_a? Symbol
  end

  test "updating to an invalid state creates a verification error" do
    hmd = Hmd.first
    hmd.state = :unannounced
    assert_not hmd.valid?
    assert_not hmd.save
    assert_not_equal :unannounced, hmd.reload.state
  end

  test "can change state properly" do
    hmd = Hmd.first
    hmd.state = :devkit
    hmd.save!

    assert_equal :devkit, hmd.reload.state

    hmd.state = :announced
    hmd.save!

    assert_equal :announced, hmd.reload.state
  end

  test "can change state with string" do
    hmd = Hmd.first
    hmd.state = "devkit"
    hmd.save!
    assert_equal :devkit, hmd.reload.state
  end

  test "changing states creates a new state model" do
    hmd = Hmd.first
    hmd.state = :announced
    hmd.save!

    state_count = hmd.hmd_states.count

    hmd.state = :devkit
    hmd.save!

    assert hmd.hmd_states.count > state_count
  end

end
