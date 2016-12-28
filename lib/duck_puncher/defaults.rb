DuckPuncher.logger = Logger.new(STDOUT).tap do |config|
  config.formatter = proc { |*args| "[DuckPuncher] #{args[0]}: #{args[-1]}\n" }
  config.level = Logger::ERROR
end

# [Target, Extensions]
ducks = [
  [String, DuckPuncher::Ducks::String],
  [Enumerable, DuckPuncher::Ducks::Enumerable, {
    after: proc { |target|
      # Re-include Enumerable in these classes to pick up the new extensions
      hosts = [Array, Set, Range, Enumerator]
      hosts = [target] if hosts.include?(target)
      hosts.each do |k|
        DuckPuncher.logger.debug("Sending include to #{k} with Enumerable") and k.send(:include, Enumerable)
      end
    }
  }],
  [Numeric, DuckPuncher::Ducks::Numeric],
  [Hash, DuckPuncher::Ducks::Hash],
  [Object, DuckPuncher::Ducks::Object],
  [Module, DuckPuncher::Ducks::Module],
  [Method, DuckPuncher::Ducks::Method, { before: ->(_target) { DuckPuncher::GemInstaller.initialize! } }],
]
ducks << [ActiveRecord::Base, DuckPuncher::Ducks::ActiveRecord] if defined?(Rails) && defined?(ActiveRecord) && defined?(ActiveRecord::Base)
ducks.each do |duck|
  DuckPuncher.register *duck
end
