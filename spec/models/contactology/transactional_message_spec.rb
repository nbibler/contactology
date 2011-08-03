require 'spec_helper'

describe Contactology::TransactionalMessage do
  let(:message) { Factory.build_via_new :transactional_message }
  subject { message }

  context '#campaign' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new Factory.attributes_for(:transactional_message).merge(:campaign => nil)
      }.to raise_error(ArgumentError)
    end
  end

  context '#contact' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new Factory.attributes_for(:transactional_message).merge(:contact => nil)
      }.to raise_error(ArgumentError)
    end
  end

  context '#replacements' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new Factory.attributes_for(:transactional_message).merge(:replacements => nil)
      }.to raise_error(ArgumentError)
    end
  end

  context '#send_message' do
    context 'when successful' do
      use_vcr_cassette 'transactional_message/send_message/success'
      let(:contact) { Factory :contact }
      let(:campaign) { Factory :transactional_campaign }
      let(:message) { Factory.build_via_new :transactional_message, :campaign => campaign, :contact => contact }
      after(:each) { contact.destroy; campaign.destroy }

      subject { message.send_message }

      it { should be_true }
    end

    context 'when unsuccessful' do
      use_vcr_cassette 'transactional_message/send_message/failure'
      let(:contact) { Factory :contact }
      let(:campaign) { Factory :transactional_campaign }
      let(:message) { Factory.build_via_new :transactional_message, :campaign => campaign, :contact => contact }
      before(:each) { campaign.destroy }
      after(:each) { contact.destroy }

      subject { message.send_message }

      it { should be_false }
    end
  end

  context '#source' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new Factory.attributes_for(:transactional_message).merge(:source => nil)
      }.to raise_error(ArgumentError)
    end
  end
end
