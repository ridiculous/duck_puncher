require 'duck_puncher/version'

module DuckPuncher
  autoload :Array, 'duck_puncher/array'
  autoload :Numeric, 'duck_puncher/numeric'
  autoload :Hash, 'duck_puncher/hash'
  autoload :String, 'duck_puncher/string'
  autoload :Object, 'duck_puncher/object'

  if defined? ActiveRecord
    autoload :ActiveRecordExtensions, 'duck_puncher/active_record_extensions'
  end

  def self.load!(*names)
    names.each &method(:const_get)
  end

  def self.load_all!
    constants.each &method(:const_get)
  end
end
