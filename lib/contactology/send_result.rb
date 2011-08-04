# encoding: UTF-8

require 'contactology/issues'

module Contactology
  ##
  # Contains the campaign send request results which indicate success or
  # failure, as well as any issues found with the campaign.
  #
  class SendResult
    attr_reader :issues

    def initialize(response)
      @success = response['success']
      @issues = Issues.new(response['issues'])
    end

    ##
    # Public: Indicates whether or not the send was successful
    #
    # Returns true when successful.
    # Returns false when unsuccessful.
    #
    def successful?
      !!@success
    end

    ##
    # Public: Returns the spam score of the campaign.
    #
    # Returns a numeric from 0 to 100 (where higher is better).
    #
    def score
      @issues.score
    end
  end
end
