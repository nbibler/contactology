require 'contactology/version'
require 'contactology/errors'
require 'contactology/campaigns/standard'
require 'contactology/campaigns/transactional'
require 'contactology/contact'
require 'contactology/transactional_message'
require 'contactology/configuration'
require 'contactology/list'
require 'contactology/list_proxy'

##
# This library provides an interface to the
# Contactology[http://www.contactology.com/] v2, "REST-based"
# {email marketing API}[http://www.contactology.com/email-marketing-api/].
#
# Example usage:
#
#   require 'contactology'
#
#   Contactology.configuration do |config|
#     config.key = 'aBcDeFg12345'
#   end
#
#   list = Contactology::List.find(4)
#   # => #<Contactology::List:0x000... @list_id="4" @name="test list" ...>
#
#   list.subscribe('joe@example.local')
#   # => true
#
#   contact = Contactology::Contact.find('joe@example.local')
#   # => #<Contactology::Contact:0x000... @email="joe@example.local" ...>
#
#   contact.lists
#   # => [#<Contactology::List:0x000... @list_id="4" ...>]
#
module Contactology
  ##
  # Public: Primary accessor for reading or manipulating the default
  # configuration.
  #
  # Examples
  # 
  #   Contactology.configuration do |config|
  #     config.key = 'newkey'
  #   end
  #
  #   Contactology.configuration
  #   # => #<Contactology::Configuration:0x000...>
  #
  # Returns the default Contactology::Configuration instance.
  #
  def self.configuration
    @@_configuration ||= Contactology::Configuration.new
    yield @@_configuration if block_given?
    @@_configuration
  end

  ##
  # Public: Explicitly sets the default configuration by replacing it with the
  # instance given.
  #
  # configuration - A Contactology::Configuration instance.
  #
  # Examples
  #
  #   Contactology.configuration = Contactology::Configuration.new
  #   # => #<Contactology::Configuration:0x000...>
  #
  # Returns nothing.
  # Raises ArgumentError unless given a Contactology::Configuration instance.
  #
  def self.configuration=(configuration)
    raise ArgumentError, 'Expected a Contactology::Configuration instance' unless configuration.kind_of?(Configuration)
    @@_configuration = configuration
  end

  ##
  # Public: Alias to Contactology.configuration.
  #
  # Returns the default Contactology::Configuration instance.
  #
  def self.configure(&block)
    configuration(&block)
  end

  ##
  # Public: Shorthand reader of the default configuration's endpoint.
  #
  # Returns the String endpoint from the default configuration.
  #
  def self.endpoint
    configuration.endpoint
  end

  ##
  # Public: Shorthand writer to the default configuration's endpoint.
  #
  # endpoint = The String to use for the API endpoint.
  #
  # Returns nothing.
  #
  def self.endpoint=(endpoint)
    configuration.endpoint = endpoint
  end

  ##
  # Public: Shorthand reader of the default configuration's key.
  #
  # Returns the String key from the default configuration.
  #
  def self.key
    configuration.key
  end

  ##
  # Public: Shortand writer to the default configuration's key.
  #
  # key - The String to use for the API key.
  #
  # Returns nothing.
  #
  def self.key=(key)
    configuration.key = key
  end
end
