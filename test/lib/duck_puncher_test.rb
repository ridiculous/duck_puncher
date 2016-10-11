require_relative '../test_helper'

DuckPuncher.punch! Object, only: :punch

class DuckPuncherTest < MiniTest::Test
  def setup
    @subject = Animal.new
    @kaia = Kaia.new
  end

  def teardown
    DuckPuncher.deregister Animal, Kaia, Dog
  end

  def test_punch!
    refute_respond_to @kaia, :talk
    refute_respond_to @kaia.punch, :talk
    DuckPuncher.register Kaia, CustomPunch
    DuckPuncher.punch! Kaia, only: :talk
    assert_respond_to @kaia, :talk
    assert_respond_to @kaia.punch, :talk
  end

  def test_punch_all!
    DuckPuncher.()
    expected_methods = DuckPuncher::Ducks.list.values.m(:to_a).flatten.m(:mod).m(:local_methods).flatten
    assert expected_methods.size > 1
    good_ducks = DuckPuncher::Ducks.list.select { |_, ducks|
      ducks.all? { |duck| (duck.mod.local_methods - duck.target.instance_methods(:false)).size.zero? }
    }
    assert good_ducks.size > 5
  end

  def test_call
    DuckPuncher.()
    expected_methods = DuckPuncher::Ducks.list.values.m(:to_a).flatten.m(:mod).m(:local_methods).flatten
    assert expected_methods.size > 1
    # Find all ducks that have copied all their methods to the target class (e.g. String)
    good_ducks = DuckPuncher::Ducks.list.select { |_, ducks|
      ducks.all? { |duck| (duck.mod.local_methods - duck.target.instance_methods(:false)).size.zero? }
    }
    assert good_ducks.size == 6, "Good ducks should be equal to 6 but are #{good_ducks.size}"
  end

  def test_call_with_target

  end

  def test_register_with_multiple_mods
    refute_respond_to @subject, :talk
    refute_respond_to @subject, :wobble
    refute_respond_to @subject.punch, :talk
    refute_respond_to @subject.punch, :wobble
    DuckPuncher.register Animal, CustomPunch, CustomPunch3
    assert_respond_to @subject.punch, :talk
    assert_respond_to @subject.punch, :wobble
  end

  def test_deregister
    refute_respond_to @subject, :talk
    refute_respond_to @subject.punch, :talk
    DuckPuncher.register Animal, CustomPunch
    assert_respond_to @subject.punch, :talk
    refute_respond_to @subject, :talk
    DuckPuncher.deregister Animal
    refute_respond_to @subject.punch, :talk
  end
end
