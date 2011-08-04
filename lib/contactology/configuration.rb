# encoding: UTF-8

##
# Holds configuration objects used by the library.  The Contactology module
# holds reference to a default Configuration, which will be used when no
# explicit configurations are given to a particular query.
#
class Contactology::Configuration
  ##
  # Public: Set the API endpoint to be used.
  #
  # endpoint - The String to use for the API endpoint.
  #
  # Returns nothing.
  #
  attr_writer :endpoint

  ##
  # Public: Get the API key used for queries.
  #
  # Returns the String of the key.
  #
  attr_reader :key
  #
  ##
  # Public: Set the API key used for queries.
  #
  # key - The String to use for the API key.
  #
  # Returns nothing.
  #
  attr_writer :key

  ##
  # Public: Get the API endpoint used by the configuration.  Unless explicitly
  # set, the endpoint will default to the official production endpoint at
  # "https://api.emailcampaigns.net/2/REST/".
  #
  # Returns the String for the API endpoint.
  #
  def endpoint
    @endpoint ||= 'https://api.emailcampaigns.net/2/REST/'
  end
end
