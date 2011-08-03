require 'spec_helper'

class APIClient
  extend Contactology::API

  def query(method, attributes = {}, configuration = Contactology.configuration)
    super(method, attributes, configuration)
  end
  public :query
end

describe Contactology::API do
  context 'handlers' do
    it 'executes the on_success handler for a successful response'
    it 'executes the on_error handler for an unsuccessful response'
    it 'executes the on_timeout handler for connection timeout'
  end

  context '#request_headers' do
    subject { APIClient.request_headers }

    its(['Accept']) { should == 'application/json' }
    its(['User-Agent']) { should match %r{^contactology/#{Regexp.escape(Contactology::VERSION)} \(Rubygems; Ruby #{Regexp.escape(RUBY_VERSION)} #{Regexp.escape(RUBY_PLATFORM)}\)$} }
  end
end
