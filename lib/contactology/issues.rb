# encoding: UTF-8

require 'contactology/issue'

module Contactology
  class Issues < Array
    attr_reader :score

    def initialize(data = nil)
      data = Hash.new unless data.kind_of?(Hash)
      @score = data['score'] || 0
      (data['issues'] || []).each { |i| self << i }
    end


    def <<(o)
      super(Issue.new(o))
    end
  end
end
