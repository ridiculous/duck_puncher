require_relative '../test_helper'

class DuckPuncherTest < MiniTest::Test
  def test_register
    refute_respond_to [], :tap_tap
    DuckPuncher.register :CustomPunch, class: 'Array'
    DuckPuncher.punch! :CustomPunch
    assert_respond_to [], :tap_tap
    DuckPuncher.punch! :Object, only: :punch
    assert_respond_to [].punch(:CustomPunch), :tap_tap
  end

  def test_register_with_array
    refute_respond_to [], :quack
    refute_respond_to [], :wobble
    DuckPuncher.register [:CustomPunch2, :CustomPunch3], class: 'Array'
    DuckPuncher.punch! :CustomPunch2
    assert_respond_to [], :quack
    refute_respond_to [], :wobble
    DuckPuncher.punch! :CustomPunch3
    assert_respond_to [], :wobble
  end
end
