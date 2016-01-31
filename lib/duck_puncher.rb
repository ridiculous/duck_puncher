require 'pathname'
require 'fileutils'
require 'logger'
require 'duck_puncher/version'

module DuckPuncher
  autoload :JSONStorage, 'duck_puncher/json_storage'
  autoload :GemInstaller, 'duck_puncher/gem_installer'
  autoload :Duck, 'duck_puncher/duck'
  autoload :Ducks, 'duck_puncher/ducks'

  def self.punch(*names)
    singular = names.size == 1
    punched_ducks = names.map do |name|
      if duck = Ducks[name]
        duck_class = Class.new(duck.klass)
        if duck.punch duck_class
          duck_class
        else
          log.error %Q(Failed to punch #{name}!)
        end
      end
    end
    punched_ducks.compact!
    punched_ducks = punched_ducks.first if singular
    punched_ducks
  end

  def self.punch!(*names)
    names.each do |name|
      if duck = Ducks[name]
        if duck.punched?
          log.info %Q(Already punched #{name})
        else
          log.warn %Q(Punching the #{name} ducky)
          unless duck.punch
            log.error %Q(Failed to punch #{name}!)
          end
        end
      end
    end
    nil
  end

  def self.punch_all!
    log.warn 'Punching all ducks! Watch out!'
    Ducks.list.each &:punch
  end

  class << self
    attr_accessor :log
  end

  self.log = Logger.new(STDOUT).tap do |config|
    config.level = Logger::INFO
    config.formatter = proc { |*args| "#{args.first}: #{args.last.to_s}\n" }
  end
end
