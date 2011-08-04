# encoding: UTF-8

require 'spec_helper'

describe Contactology::Campaigns::Transactional do
  context '.create' do
    context 'when successful' do
      use_vcr_cassette 'campaigns/transactional/create/success'
      let(:campaign) { Contactology::Campaigns::Transactional.create Factory.attributes_for(:transactional_campaign) }
      after(:each) { campaign.destroy }

      subject { campaign }

      it { should be_instance_of Contactology::Campaigns::Transactional }
      its(:id) { should_not be_nil }
      its(:object_id) { should == campaign.object_id }
    end

    context 'when unsuccessful' do
      use_vcr_cassette 'campaigns/transactional/create/failure'
      let(:campaign) { Contactology::Campaigns::Transactional.create Factory.attributes_for(:transactional_campaign).merge(:content => {:text => 'bad'}) }

      subject { campaign }

      it { should be_kind_of Contactology::SendResult }
      it { should_not be_successful }
      its(:issues) { should_not be_empty }
    end
  end
end
