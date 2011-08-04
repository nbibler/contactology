# encoding: UTF-8

require 'contactology/basic_object'
require 'contactology/list'

module Contactology
  class ListProxy < ::Contactology::BasicObject
    attr_reader :list_id

    def initialize(list_id)
      @list_id = list_id
    end


    private


    def get_list(id)
      List.find(id)
    end

    def method_missing(method, *args, &block)
      @list ||= get_list(list_id)
      @list.send(method, *args, &block) if @list
    end
  end
end
