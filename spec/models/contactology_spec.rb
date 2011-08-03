require 'spec_helper'

describe Contactology do
  maintain_contactology_configuration

  let(:configuration) { Contactology.configuration }

  context '.configuration' do
    it 'yields a Contactology::Configuration instance' do
      Contactology.configuration do |yielded|
        yielded.should be_kind_of Contactology::Configuration
      end
    end

    it 'yields the same configuration instance across multiple calls' do
      Contactology.configuration do |config|
        Contactology.configuration do |config2|
          config.object_id.should == config2.object_id
        end
      end
    end

    it 'returns the configuration when queried' do
      Contactology.configuration do |config|
        Contactology.configuration.object_id.should == config.object_id
      end
    end

    it 'may be explicitly overridden' do
      configuration = Contactology::Configuration.new
      expect {
        Contactology.configuration = configuration
      }.to change(Contactology, :configuration).to(configuration)
    end

    it 'raises an ArgumentError when set to a non-Configuration object' do
      expect {
        Contactology.configuration = 'bad'
      }.to raise_error(ArgumentError)
    end
  end

  context '.endpoint' do
    it 'returns the configuration endpoint' do
      Contactology.endpoint.should == configuration.endpoint
    end

    it 'overrides the configuration endpoint' do
      expect {
        Contactology.endpoint = 'https://example.local/'
      }.to change(configuration, :endpoint).to('https://example.local/')
    end
  end

  context '.key' do
    it 'returns the configuration key' do
      configuration.key = 'test'
      Contactology.key.should == configuration.key
    end

    it 'overrides the configuration key' do
      expect {
        Contactology.key = 'testing'
      }.to change(configuration, :key).to('testing')
    end
  end
end
