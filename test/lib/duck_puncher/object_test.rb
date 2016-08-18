require_relative '../../test_helper'
DuckPuncher.punch! Object

class ObjectTest < MiniTest::Test
  def setup
    @animal = Animal.new
    @dog = Dog.new
    @kaia = Kaia.new
  end

  def teardown
    DuckPuncher.deregister Animal, Dog, Kaia
  end

  def test_clone!
    cloned = @dog.clone!
    assert_equal cloned.class, @dog.class
    refute_equal cloned, @dog
  end

  def test_punch_with_a_core_duck
    assert [].punch.respond_to?(:m)
  end

  def test_punch_on_a_custom_duck
    DuckPuncher.register Animal, CustomPunch2
    assert @animal.punch.respond_to?(:quack)
  end

  def test_punch_with_multiple_custom_duck
    DuckPuncher.register Animal, CustomPunch2
    DuckPuncher.register Animal, CustomPunch3
    assert @animal.punch.respond_to?(:wobble)
  end

  def test_punch_call_stack
    Animal.send(:define_method, :foo) { quack }
    Animal.send(:define_method, :quack) { 'foo' }
    assert_equal 'foo', @animal.foo
    DuckPuncher.register Animal, CustomPunch2
    @animal.punch!
    assert_equal 'quack', @animal.foo
  end

  def test_punch_on_ancestor_only
    DuckPuncher.register Dog, CustomPunch2
    assert_respond_to @dog.punch, :quack
  end

  def test_punch_includes_all_ancestors
    DuckPuncher.register Animal, CustomPunch2
    DuckPuncher.register Dog, CustomPunch
    DuckPuncher.register Kaia, CustomPunch3
    @kaia = Kaia.new
    @kaia.punch!
    assert_respond_to @kaia, :wobble
    assert_respond_to @kaia, :talk
    assert_respond_to @kaia, :quack
  end

  def test_soft_punch_includes_all_ancestors
    DuckPuncher.register Animal, CustomPunch2
    DuckPuncher.register Dog, CustomPunch
    DuckPuncher.register Kaia, CustomPunch3
    @kaia = Kaia.new.punch
    assert_respond_to @kaia, :wobble
    assert_respond_to @kaia, :talk
    assert_respond_to @kaia, :quack
  end

  def test_soft_punch_with_parent_override
    DuckPuncher.register Animal, CustomPunch
    DuckPuncher.register Kaia, ModWithOverride
    refute_respond_to @kaia, :talk
    @kaia = Kaia.new.punch
    assert_respond_to @kaia, :talk
    assert_equal @kaia.talk, 'talk is cheap'
  end
end
