require_relative '../../test_helper'
require_relative '../../fixtures/wut'
DuckPuncher.punch! :Method

class MethodTest < MiniTest::Test

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @subject = Wut.new
  end

  def test_to_instruct
    assert_match /:to_a/, @subject.method(:to_a).to_instruct
    assert_match /newarray/, @subject.method(:to_a).to_instruct
    assert_match /opt_plus/, @subject.method(:to_a).to_instruct
    assert_equal nil, [].method(:to_s).to_instruct
  end

  def test_to_instruct_single_line
    assert_match /:to_f/, @subject.method(:to_f).to_instruct
    assert_match /getconstant\s*:INFINITY/, @subject.method(:to_f).to_instruct
  end

  def test_to_source
    assert_equal "def to_a\n  ['w'] + ['u'] + ['t']\nend\n", @subject.method(:to_a).to_source
  end

  def test_to_source_with_no_source
    assert_equal '', @subject.method(:object_id).to_source
  end
end