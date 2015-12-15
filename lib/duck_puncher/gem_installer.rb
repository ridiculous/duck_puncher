require_relative 'json_storage'

class DuckPuncher::GemInstaller
  module LoadPathInitializer
    def self.included(*)
      spec_data = DuckPuncher::JSONStorage.read('load_paths.json').values
      spec_data.each do |spec|
        spec[:load_paths].each do |load_path|
          next if $LOAD_PATH.include? load_path
          $LOAD_PATH.unshift load_path
        end
        begin
          require spec[:require_with]
        rescue LoadError => e
          puts "Failed to require #{spec[:require_with]}. #{e.inspect}"
        end
      end
    end
  end

  # @param [String] name of the gem
  # @param [String] version of the gem to install (e.g. '1.2.3')
  def perform(*args)
    require 'rubygems/dependency_installer'
    installer = Gem::DependencyInstaller.new(install_dir: load_path.to_s, bin_dir: RbConfig::CONFIG['bindir'])
    installer.install *args.reject(&:empty?)
    installer.installed_gems.each do |gem|
      full_load_path = load_path.join('gems', "#{gem.name}-#{gem.version}", "lib")
      next if $LOAD_PATH.include?(full_load_path.to_s)
      $LOAD_PATH.unshift full_load_path.to_s
      DuckPuncher::JSONStorage.write 'load_paths.json', args.first, full_load_path
    end
    installer.installed_gems.any?
  rescue => e
    puts "Failed to install #{args.first}. #{e.inspect}"
  end

  def load_path
    @load_path ||= begin
      spec = Bundler.definition.specs.first
      spec_pattern = %r[(gems/#{Regexp.escape(spec.name)}-[#{Regexp.escape(spec.version.to_s.tr(' ', '-'))}]+/.*)]
      current_load_path = find_load_path(spec_pattern)
      if current_load_path
        Pathname.new current_load_path.sub(spec_pattern, '')
      else
        fail "Coudn't find example load path to use for the download!"
      end
    end
  end

  def find_load_path(spec_pattern)
    load_paths = $LOAD_PATH + Bundler::RubygemsIntegration.new.loaded_gem_paths
    load_paths.find { |x| x =~ spec_pattern }
  end
end
