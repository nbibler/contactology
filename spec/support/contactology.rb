# encoding: UTF-8

require 'pathname'

path = Pathname.new(File.expand_path('../../contactology.yml', __FILE__))

if path.exist?
  begin
    CONTACTOLOGY_CONFIGURATION = YAML.load_file(path)
    Contactology.configure do |config|
      config.key = CONTACTOLOGY_CONFIGURATION['key'] || abort("Contactology configuration file (#{path}) is missing the key value.")
      config.endpoint = CONTACTOLOGY_CONFIGURATION['endpoint'] if CONTACTOLOGY_CONFIGURATION.has_key?('endpoint')
    end
  rescue NoMethodError
    abort "Contactology configuration file (#{path}) is malformatted or unreadable."
  end
else
  abort "Contactology test configuration (#{path}) not found."
end

module ConfigurationSpecHelpers
  def maintain_contactology_configuration
    before(:each) do
      @_isolated_configuration = Contactology.configuration
      Contactology.configuration = @_isolated_configuration.dup
    end

    after(:each) do
      Contactology.configuration = @_isolated_configuration
    end
  end
end

RSpec.configure do |config|
  config.extend ConfigurationSpecHelpers
end
