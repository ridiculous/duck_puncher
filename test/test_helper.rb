require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'duck_puncher'

Minitest::Reporters.use!

DuckPuncher.log.level = Logger::INFO

module CustomPunch
  def tap_tap
    p self
    self
  end
end

module CustomPunch2
  def quack
  end
end

module CustomPunch3
  def wobble
  end
end
