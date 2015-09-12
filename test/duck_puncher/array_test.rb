require_relative '../test_helper'

class ArrayTest < MiniTest::Test
  attr_reader :subject

  def setup
    @subject = ('a'..'m').to_a
  end

  def test_m
    assert_equal subject.map(&:upcase), subject.m(:upcase)
  end

  def test_m_with_two_args
    assert_equal subject.map { |x| x.prepend('btn-') }, subject.m(:prepend, 'btn-')
  end

  def test_m_with_many_args
    assert_equal subject.map { |x| x.sub(/[aeiou]/, '*') }, subject.m(:sub, /[aeiou]/, '*')
  end

  def test_get
    assert_equal [].methods.get(/ty\?/), [:empty?]
    assert_equal [].methods.get('ty?'), [:empty?]
  end
end
