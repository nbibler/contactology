# encoding: UTF-8

require 'spec_helper'

describe Contactology::TransactionalMessage do
  let(:message) { build :transactional_message }
  subject { message }

  context '#campaign' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new attributes_for(:transactional_message).merge(:campaign => nil)
      }.to raise_error(ArgumentError)
    end
  end

  context '#contact' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new attributes_for(:transactional_message).merge(:contact => nil)
      }.to raise_error(ArgumentError)
    end
  end

  context '#replacements' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new attributes_for(:transactional_message).merge(:replacements => nil)
      }.to raise_error(ArgumentError)
    end
  end

  context '#send_message' do
    context 'when successful', :vcr => {:cassette_name => 'transactional_message/send_message/success'} do
      let(:contact) { create :contact }
      let(:campaign) { create :transactional_campaign }
      let(:message) { build :transactional_message, :campaign => campaign, :contact => contact }
      after(:each) { contact.destroy; campaign.destroy }

      subject { message.send_message }

      it { should be_true }
    end

    context 'when unsuccessful', :vcr => {:cassette_name => 'transactional_message/send_message/failure'} do
      let(:contact) { create :contact }
      let(:campaign) { create :transactional_campaign }
      let(:message) { build :transactional_message, :campaign => campaign, :contact => contact }
      before(:each) { campaign.destroy }
      after(:each) { contact.destroy }

      subject { message.send_message }

      it { should be_false }
    end
  end

  context '#source' do
    it 'is required' do
      expect {
        Contactology::TransactionalMessage.new attributes_for(:transactional_message).merge(:source => nil)
      }.to raise_error(ArgumentError)
    end
  end
end
