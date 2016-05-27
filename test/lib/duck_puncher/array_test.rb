require_relative '../../test_helper'

DuckPuncher.punch! :Object

class ArrayTest < MiniTest::Test
  attr_reader :subject

  def setup
    @subject = ('a'..'m').to_a.punch
  end

  def test_m
    assert_equal subject.map(&:upcase), subject.m(:upcase)
  end

  def test_mm_with_two_args
    assert_equal subject.map { |x| x.prepend('btn-') }, subject.mm(:prepend, 'btn-')
  end

  def test_mm_with_three_args
    assert_equal subject.map { |x| x.sub(/[aeiou]/, '*') }, subject.mm(:sub, /[aeiou]/, '*')
  end

  def test_except
    assert_equal subject.except('a'), %w[b c d e f g h i j k l m]
    assert_equal subject.except('a', 'b', 'c'), %w[d e f g h i j k l m]
    assert_equal subject.except, subject
  end
end
