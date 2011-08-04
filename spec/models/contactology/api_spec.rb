# encoding: UTF-8

require 'spec_helper'

class APIClient
  extend Contactology::API

  def self.go!
    query('call', {
      :on_timeout => 'timed out',
      :on_error => Proc.new { |response| response['result'] },
      :on_success => Proc.new { |response| 'successful' if response.kind_of?(TrueClass) }
    })
  end
end

class APIError
  def self.call(env)
    [200, {'Content-type' => 'text/plain'}, ["{\"result\":\"error\",\"message\":\"Input error: no contact found with that email\",\"code\":601}"]]
  end
end

class APISuccess
  def self.call(env)
    [200, {'Content-type' => 'text/plain'}, ['true']]
  end
end

describe Contactology::API do
  context 'handlers' do
    it 'executes the on_success handler for a successful response' do
      WebMock.stub_request(:get, /.*/).to_rack(APISuccess)
      APIClient.go!.should == 'successful'
    end

    it 'executes the on_error handler for an unsuccessful response' do
      WebMock.stub_request(:get, /.*/).to_rack(APIError)
      APIClient.go!.should == 'error'
    end

    it 'executes the on_timeout handler for connection timeout' do
      WebMock.stub_request(:get, /.*/).to_timeout
      APIClient.go!.should == 'timed out'
    end
  end

  context '#request_headers' do
    subject { APIClient.request_headers }

    its(['Accept']) { should == 'application/json' }
    its(['User-Agent']) { should match %r{^contactology/#{Regexp.escape(Contactology::VERSION)} \(Rubygems; Ruby #{Regexp.escape(RUBY_VERSION)} #{Regexp.escape(RUBY_PLATFORM)}\)$} }
  end
end
