require_relative '../../test_helper'
DuckPuncher.punch! :Object

class ObjectTest < MiniTest::Test

  def setup
    Object.const_set :User, Class.new
    @subject = Object.new
    @user = User.new
  end

  def teardown
    DuckPuncher::Ducks.list.delete_if { |duck| [:admin, :super_admin, :User].include?(duck.name) }
    Object.send :remove_const, :User
  end

  def test_clone!
    cloned = @subject.clone!
    assert_equal cloned.class, @subject.class
    refute_equal cloned, @subject
  end

  def test_punch_on_a_core_duck
    refute [].respond_to?(:m)
    assert [].respond_to?(:punch)
    assert [].punch.respond_to?(:m)
  end

  def test_punch_with_a_core_duck
    assert [].punch(:Array).respond_to?(:m)
  end

  def test_punch_on_a_custom_duck
    DuckPuncher.register :User, mod: 'CustomPunch2'
    assert @user.punch.respond_to?(:quack)
  end

  def test_punch_with_a_custom_duck
    refute @user.respond_to?(:quack)
    DuckPuncher.register :admin, mod: 'CustomPunch2'
    assert @user.punch(:admin).respond_to?(:quack)

    refute @user.respond_to?(:wobble)
    DuckPuncher.register :super_admin, mod: 'CustomPunch3'
    assert @user.punch(:super_admin).respond_to?(:wobble)
  end

  def test_punch_call_stack
    User.send(:define_method, :foo) { quack }
    User.send(:define_method, :quack) { 'foo' }
    assert_equal 'foo', @user.foo
    DuckPuncher.register :User, mod: 'CustomPunch2'
    assert_equal 'quack', @user.punch.foo
    User.send(:remove_method, :foo)
    User.send(:remove_method, :quack)
  end
end
