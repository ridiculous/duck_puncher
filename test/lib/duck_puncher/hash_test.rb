require_relative '../../test_helper'

DuckPuncher.punch :Hash

class HashTest < MiniTest::Test
  def setup
    @subject = DuckPuncher::HashDuck.new.merge({ a: 1, b: { c: 2 } })
  end

  def test_dig
    assert_equal @subject.dig(:a), 1
    assert_equal @subject.dig(:b, :a), nil
    assert_equal @subject.dig(:b, :c), 2
    assert_equal @subject.dig(:b), { c: 2 }
  end
end
