# encoding: UTF-8

module Contactology
  class Issue
    attr_reader :type
    attr_reader :text
    attr_reader :message
    attr_reader :context
    attr_reader :col
    attr_reader :deduction

    def initialize(details)
      details = Hash.new unless details.kind_of?(Hash)
      @type = details['type']
      @text = details['text']
      @message = details['message']
      @context = details['context']
      @col = details['col']
      @deduction = details['deduction']
    end

    def to_s
      "%s: %s, %d point deduction" % [type, text || message, deduction]
    end
  end
end
