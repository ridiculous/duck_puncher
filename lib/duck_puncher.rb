require 'pathname'
require 'fileutils'
require 'delegate'
require 'logger'
require 'usable'
require 'duck_puncher/version'

module DuckPuncher
  autoload :JSONStorage, 'duck_puncher/json_storage'
  autoload :GemInstaller, 'duck_puncher/gem_installer'
  autoload :Duck, 'duck_puncher/duck'
  autoload :Ducks, 'duck_puncher/ducks'

  class << self
    attr_accessor :log

    def delegations
      @delegations ||= {}
    end

    def classes
      @classes ||= {}
    end

    # @param [Symbol] duck_name
    # @param [Class] obj The object being punched
    def delegate_class(duck_name, obj = nil)
      delegations[duck_name] ||= const_set "#{duck_name}DuckDelegated", Ducks[duck_name].dup.delegated(obj)
    end

    def duck_class(name)
      classes[name] ||= const_set "#{name}Duck", Ducks[name].dup.classify
    end

    # @description Extends functionality to a copy of the specified class
    def punch(*names)
      singular = names.size == 1
      punched_ducks = names.map(&method(:duck_class)).compact
      if singular
        punched_ducks.first
      else
        punched_ducks
      end
    end

    def punch!(*names)
      options = names.last.is_a?(Hash) ? names.pop : {}
      names.each do |name|
        duck = Ducks[name]
        log.warn %Q(Punching#{" #{options[:only]} onto" if Array(options[:only]).any?} #{name})
        unless duck.punch(options)
          log.error %Q(Failed to punch #{name}!)
        end
      end
      nil
    end

    def punch_all!
      log.warn 'Punching all ducks!'
      Ducks.list.each &:punch
    end

    def register(*args)
      Ducks.list << Duck.new(*args)
    end
  end

  self.log = Logger.new(STDOUT).tap do |config|
    config.level = Logger::INFO
    config.formatter = proc { |*args| "#{args.first}: #{args.last.to_s}\n" }
  end

  log.level = Logger::ERROR
end
