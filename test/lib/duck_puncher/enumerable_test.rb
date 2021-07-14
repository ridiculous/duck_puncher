require_relative '../../test_helper'

DuckPuncher.punch! Object

class EnumerableTest < MiniTest::Test
  attr_reader :subject

  def setup
    @subject = ('a'..'m').to_a
  end

  def test_m
    subject.punch!
    assert_equal subject.map(&:upcase), subject.m(:upcase)
    refute_equal subject.object_id, subject.m(:upcase).object_id
    assert_equal subject.map!(&:upcase), subject.m!(:upcase)
    assert_equal subject.object_id, subject.m!(:upcase).object_id
  end

  def test_m_with_range
    @subject = ('a'..'f')
    assert_equal %w[A B C D E F], @subject.punch.m(:upcase)
    assert_equal %w[A B C D E F], @subject.to_a.punch!.m(:upcase)
  end

  def test_m_with_enum
    @subject = ('A'..'F').to_enum
    assert_equal %w[B C D E F G], @subject.punch.m(:next)
    assert_equal %w[B C D E F G], @subject.punch!.m(:next)
  end

  def test_mm_with_set
    @subject = Set.new %w[a b c d e f]
    assert_equal %w[A B C D E F], @subject.punch.m(:upcase)
    assert_equal %w[A B C D E F], @subject.punch!.m(:upcase)
    assert_equal %w[B C D E F G], @subject.punch!.m!(:upcase).m(:next)
  end

  def test_mm_with_two_args
    subject.punch!
    assert_equal subject.map { |x| x.prepend('btn-') }, subject.mm(:prepend, 'btn-')
    refute_equal subject.object_id, subject.mm(:prepend, 'btn-')
    assert_equal subject.map! { |x| x.prepend('btn-') }, subject.mm!(:prepend, 'btn-')
    assert_equal subject.object_id, subject.mm!(:prepend, 'btn-').object_id
  end

  def test_mm_with_three_args
    @subject = @subject.punch
    assert_equal subject.map { |x| x.sub(/[aeiou]/, '*') }, subject.mm(:sub, /[aeiou]/, '*')
  end

  def test_except
    @subject = @subject.punch
    assert_equal subject.except('a'), %w[b c d e f g h i j k l m]
    assert_equal subject.except('a', 'b', 'c'), %w[d e f g h i j k l m]
    assert_equal subject.except, subject
  end

  def test_map_keys
    @subject = [{ id: 1, name: 'a' }, { id: 2, name: 'b' }, { name: 'c' }]
    assert_respond_to @subject.punch, :map_keys
    assert_equal %w[a b c], @subject.punch.map_keys(:name)
  end
end
