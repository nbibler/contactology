# encoding: UTF-8

require 'spec_helper'

describe Contactology::Campaigns::Transactional do
  context '.create' do
    context 'when successful', :vcr => {:cassette_name => 'campaigns/transactional/create/success'} do
      let(:campaign) { Contactology::Campaigns::Transactional.create attributes_for(:transactional_campaign) }
      after(:each) { campaign.destroy }

      subject { campaign }

      it { should be_instance_of Contactology::Campaigns::Transactional }
      its(:id) { should_not be_nil }
      its(:object_id) { should == campaign.object_id }
    end

    context 'when unsuccessful', :vcr => {:cassette_name => 'campaigns/transactional/create/failure'} do
      let(:campaign) { Contactology::Campaigns::Transactional.create attributes_for(:transactional_campaign).merge(:content => {:text => 'bad'}) }

      subject { campaign }

      it 'returns a Contactology::SendResult' do
        pending('This is incorrectly passing successfully on Contactology.') do
          should be_kind_of Contactology::SendResult
        end
      end

      it 'should not be successful' do
        pending('This is incorrectly passing successfully on Contactology.') do
          should_not be_successful
        end
      end

      it 'should contain issues' do
        pending('This is incorrectly passing successfully on Contactology.') do
          subject.issues.should_not be_empty
        end
      end
    end
  end


  context '#send_campaign' do
    context 'when successful', :vcr => {:cassette_name => 'campaigns/transactional/send_campaign/success'} do
      let(:contact) { create :contact }
      let(:campaign) { create :transactional_campaign }

      after(:each) do
        campaign.destroy
        contact.destroy
      end

      subject { campaign.send_campaign(contact) }

      it { should be_instance_of Contactology::SendResult }
      it { should be_successful }
      its(:issues) { should be_empty }
    end

    context 'when unsuccessful', :vcr => {:cassette_name => 'campaigns/transactional/send_campaign/failure'} do
      let(:campaign) { create :transactional_campaign }
      after(:each) { campaign.destroy }

      subject { campaign.send_campaign(Struct.new(:email).new('bad')) }

      it { should be_kind_of Contactology::SendResult }
      it { should_not be_successful }
      its(:issues) { should_not be_empty }
    end
  end
end
