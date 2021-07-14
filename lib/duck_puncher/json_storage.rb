module DuckPuncher
  module JSONStorage
    require 'json'

    def self.dir_name
      Pathname.new('.duck_puncher')
    end

    def self.write(file_name, key, load_path)
      FileUtils.mkdir(dir_name) unless File.exist?(dir_name)
      data = read(file_name)
      key = key.to_sym
      data[key] ||= {}
      data[key][:require_with] ||= key.to_s.tr('-', '/')
      data[key][:load_paths] ||= []
      data[key][:load_paths] << load_path.to_s unless data[key][:load_paths].include?(load_path.to_s)
      File.open(dir_name.join(file_name), 'wb') { |f| f << data.to_json }
    end

    def self.read(file_name)
      if File.exist?(dir_name.join file_name)
        JSON.parse File.read(dir_name.join file_name), symbolize_names: true
      else
        {}
      end
    end
  end
end
