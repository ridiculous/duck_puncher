require_relative '../../test_helper'

DuckPuncher.punch! Module

class ModuleTest < MiniTest::Test
  def test_local_methods
    assert_equal ModWithNestedMod.local_methods, [:instance_method_1, :class_method_1]
  end
end
