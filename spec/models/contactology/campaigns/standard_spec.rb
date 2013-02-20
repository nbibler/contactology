# encoding: UTF-8

require 'spec_helper'

describe Contactology::Campaigns::Standard do
  context '.create' do
    context 'when successful', :vcr => {:cassette_name => 'campaigns/standard/create/success'} do
      let(:list) { Factory :list, :name => 'campaign-standard-create-success' }
      let(:campaign) { create_campaign :recipients => list }
      after(:each) { list.destroy; campaign.destroy }

      subject { campaign }

      it { should be_instance_of Contactology::Campaigns::Standard }
      its(:id) { should_not be_nil }
    end

    context 'with invalid data', :vcr => {:cassette_name => 'campaigns/standard/create/invalid'} do
      let(:list) { Factory :list, :name => 'campaign-standard-create-invalid' }
      let(:campaign) { create_campaign :sender_email => 'bad@example', :recipients => list }
      after(:each) { list.destroy }

      subject { campaign }

      it { should be_false }
    end

    context 'with required attributes missing', :vcr => {:cassette_name => 'campaigns/standard/create/failure'} do
      let(:list) { Factory :list, :name => 'campaign-standard-create-failure' }
      let(:campaign) { create_campaign :name => nil, :recipients => list }
      after(:each) { list.destroy }

      subject { campaign }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, /The property 'name' is required/)
      end
    end
  end

  context '#send_campaign' do
    context 'when successful', :vcr => {:cassette_name => 'campaigns/standard/send_campaign/success'} do
      let(:list) { Factory :list, :name => 'send-standard-campaign-success' }
      let(:contact) { Factory :contact }
      let(:campaign) { Factory :standard_campaign, :recipients => list }

      before(:each) { list.subscribe contact }
      after(:each) { list.destroy; contact.destroy; campaign.destroy }

      subject { campaign.send_campaign }

      it { should be_instance_of Contactology::SendResult }
      it { should be_successful }
      its(:issues) { should be_empty }
    end

    context 'when unsuccessful (high spam score)', :vcr => {:cassette_name => 'campaigns/standard/send_campaign/failure'} do
      let(:list) { Factory :list, :name => 'send-standard-campaign-failure' }
      let(:contact) { Factory :contact }
      let(:campaign) { Factory :standard_campaign, :recipients => list, :content => {'text' => 'OMG BUY VIAGRA'} }

      before(:each) { list.subscribe(contact) }
      after(:each) { list.destroy; contact.destroy; campaign.destroy }

      subject { campaign.send_campaign }

      it { should be_instance_of Contactology::SendResult }
      its(:score) { should be < 100 }

      it 'should not be successful' do
        pending('This is incorrectly passing successfully on Contactology.') do
          should_not be_successful
        end
      end

      it 'should have reported issues' do
        pending('This is incorrectly passing successfully on Contactology.') do
          subject.issues.should_not be_empty
        end
      end
    end

    context 'when unsuccessful (attributes missing)', :vcr => {:cassette_name => 'campaigns/standard/send_campaign/failure_missing_attributes'} do
      let(:list) { Factory :list, :name => 'send-standard-campaign-failure' }
      let(:contact) { Factory :contact }
      let(:campaign) { Factory :standard_campaign, :recipients => list }

      before(:each) { list.subscribe(contact); campaign.id = nil }
      after(:each) { list.destroy; contact.destroy; campaign.destroy }

      subject { campaign.send_campaign }

      it { should be_instance_of Contactology::SendResult }
      it { should_not be_successful }

      context 'issues' do
        subject { campaign.send_campaign.issues }

        it { should_not be_empty }

        it 'contains a message about the missing ID' do
          subject.any? { |i|
            i.text == 'Missing parameter campaignId for Campaign_Send'
          }.should be_true
        end
      end
    end
  end


  private


  def create_campaign(attributes = {})
    Contactology::Campaigns::Standard.create Factory.attributes_for(:standard_campaign).merge(attributes)
  end
end
