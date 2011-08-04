# encoding: UTF-8

require 'hashie/trash'

module Contactology
  ##
  # A Stash is a 'suppressing' Hashie::Trash where keys that are not defined
  # are simply ignored and unavailable to the local object.
  #
  # A Stash is useful when you need to read data from another application,
  # but you only want a predefined subset of the returned data to become
  # available, locally.
  #
  class Stash < ::Hashie::Trash
    def []=(property, value)
      if self.class.translations.include? property.to_sym
        send("#{property}=", value)
      elsif property_exists? property
        super
      end
    end


    private


    def property_exists?(property)
      self.class.property?(property.to_sym)
    end
  end
end
