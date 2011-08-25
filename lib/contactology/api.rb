# encoding: UTF-8

require 'httparty'
require 'contactology/parser'

module Contactology::API
  def query(method, attributes = {})
    configuration = extract_configuration!(attributes)
    handlers = extract_handlers!(attributes)
    remove_empty_values!(attributes)

    response = HTTParty.get(configuration.endpoint, {
      :query => {:key => configuration.key, :method => method}.merge(attributes),
      :headers => request_headers,
      :parser => request_parser
    })

    handle_query_response(response, handlers)
  rescue Timeout::Error
    call_response_handler(handlers[:on_timeout], nil)
  end

  def request_headers
      { 'Accept' => 'application/json', 'User-Agent' => user_agent_string }
  end


  protected


  def call_response_handler(handler, response)
    unless handler.nil?
      case handler
      when Proc
        handler.call(response)
      when NilClass
        response
      else
        handler
      end
    end
  end

  def extract_configuration!(hash)
    hash.delete(:configuration) || Contactology.configuration
  end

  def extract_handlers!(hash)
    handlers = {}
    [:on_timeout, :on_success, :on_error].each { |key| handlers[key] = hash.delete(key) }
    handlers
  end

  def handle_query_response(response, handlers)
    case
    when response.code == 200
      if response.parsed_response.kind_of?(Hash) &&
        (response['result'] == 'error' || response['success'].kind_of?(FalseClass) || (response['errors'] && !response['errors'].empty?))
        call_response_handler(handlers[:on_error], response)
      else
        call_response_handler(handlers[:on_success], response)
      end
    else
      call_response_handler(handlers[:on_error], response)
    end
  end

  def remove_empty_values!(hash)
    hash.each_pair do |k,v|
      hash.delete(k) if v.nil?
      remove_empty_values!(v) if v.kind_of?(Hash)
    end
  end

  def request_parser
    Contactology::Parser
  end

  def user_agent_string
    "contactology/#{Contactology::VERSION} (Rubygems; Ruby #{RUBY_VERSION} #{RUBY_PLATFORM})"
  end
end
