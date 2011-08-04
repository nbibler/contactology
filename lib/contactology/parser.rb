# encoding: UTF-8

module Contactology
  class Parser < HTTParty::Parser
    SupportedFormats.merge!({'text/plain' => :json})
  end
end
