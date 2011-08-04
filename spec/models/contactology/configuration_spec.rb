# encoding: UTF-8

require 'spec_helper'

describe Contactology::Configuration do
  let(:configuration) { Contactology::Configuration.new }

  context '#endpoint' do
    it 'defaults to http://api.emailcampaigns.net/2/REST/' do
      configuration.endpoint.should == 'https://api.emailcampaigns.net/2/REST/'
    end

    it 'may be overridden' do
      expect {
        configuration.endpoint = 'https://example.local/'
      }.to change(configuration, :endpoint).to('https://example.local/')
    end
  end

  context '#key' do
    it 'is unset by default' do
      configuration.key.should be_nil
    end

    it 'may be set' do
      expect {
        configuration.key = 'abcdefg'
      }.to change(configuration, :key).to('abcdefg')
    end
  end
end
