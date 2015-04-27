require 'duck_puncher/version'
require 'duck_puncher/array'
require 'duck_puncher/numeric'
require 'duck_puncher/hash'
require 'duck_puncher/string'

module DuckPuncher
end

require 'duck_puncher/active_record_extensions' if defined? ActiveRecord
