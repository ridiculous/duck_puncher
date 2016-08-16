require_relative '../../test_helper'

DuckPuncher.punch! Object

class ArrayTest < MiniTest::Test
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
end
