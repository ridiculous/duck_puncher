require_relative 'json_storage'

class DuckPuncher::GemInstaller
  def self.initialize!
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

  # @param [String] name of the gem
  # @param [String] version of the gem to install (e.g. '1.2.3')
  def perform(*args)
    require 'rubygems/dependency_installer'
    installer = Gem::DependencyInstaller.new(install_dir: Bundler.bundle_path.to_s, bin_dir: RbConfig::CONFIG['bindir'])
    installer.install *args.reject(&:empty?)
    installer.installed_gems.each do |gem|
      full_load_path = Bundler.bundle_path.join('gems', "#{gem.name}-#{gem.version}", "lib")
      next if $LOAD_PATH.include?(full_load_path.to_s)
      $LOAD_PATH.unshift full_load_path.to_s
      DuckPuncher::JSONStorage.write 'load_paths.json', args.first, full_load_path
    end
    installer.installed_gems.any?
  rescue => e
    puts "Failed to install #{args.first}. #{e.inspect}"
  end
end
