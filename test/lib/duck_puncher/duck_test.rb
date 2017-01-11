require_relative '../../test_helper'

class DuckTest < MiniTest::Test
  def setup
    @class = Class.new
    @object = @class.new
    @mod = Module.new { %w[foo bar baz].each { |x| define_method(x, -> {}) } }
    @subject = DuckPuncher::Duck.new(@class, @mod)
  end

  def test_punch
    @subject.target = Kaia
    refute_respond_to Kaia.new, :baz
    @subject.call
    assert_respond_to Kaia.new, :foo
    assert_respond_to Kaia.new, :bar
    assert_respond_to Kaia.new, :baz
  end

  def test_punch_with_instance
    e = assert_raises ArgumentError do
      @subject.call target: @object
    end
    assert_match /Invalid target #<#{@class}:.*>\. Please pass a module as :target/,
                 e.message
  end

  def test_punch_with_only
    refute_respond_to @object, :foo
    refute_respond_to @object, :bar
    @subject.call(only: :foo)
    refute_respond_to @object, :bar
    assert_respond_to @object, :foo
    @subject.call(only: :bar)
    assert_respond_to @object, :bar
  end

  def test_punch_with_only_target
    refute_respond_to @object, :bar
    @subject.call target: @class, only: [:foo, :bar]
    assert_respond_to @object, :bar
    assert_respond_to @object, :foo
    refute_respond_to @object, :baz
  end
end
