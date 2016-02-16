require_relative '../test_helper'

module CustomPunch
  def tap_tap
    p self
    self
  end
end

class DuckPuncherTest < MiniTest::Test
  def teardown
    Object.send :remove_const, :CustomPunch
  end

  def test_register
    refute_respond_to [], :tap_tap
    DuckPuncher.register :CustomPunch, class: 'Array'
    DuckPuncher.punch! :CustomPunch
    assert_respond_to [], :tap_tap
    DuckPuncher.punch! :Object, only: :punch
    assert_respond_to [].punch(:CustomPunch), :tap_tap
  end
end
