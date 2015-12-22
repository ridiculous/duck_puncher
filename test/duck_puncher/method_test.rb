require_relative '../test_helper'
require_relative '../fixtures/wut'

class MethodTest < MiniTest::Test

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @subject = Wut.new
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_to_instruct
    assert_match /RubyVM::InstructionSequence:to_a/, @subject.method(:to_a).to_instruct
    assert_match /newarray/, @subject.method(:to_a).to_instruct
    assert_match /opt_plus/, @subject.method(:to_a).to_instruct
    assert_equal nil, [].method(:to_s).to_instruct
  end

  def test_to_instruct_single_line
    assert_match /RubyVM::InstructionSequence:to_f/, @subject.method(:to_f).to_instruct
    assert_match /getconstant\s*:INFINITY/, @subject.method(:to_f).to_instruct
  end
end