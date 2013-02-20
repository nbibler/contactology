# encoding: UTF-8

require 'spec_helper'

describe Contactology::Campaign do
  context '.create' do
    it 'raises a NotImplementedError' do
      expect { Contactology::Campaign.create({}) }.to raise_error(NotImplementedError)
    end
  end

  context '.find' do
    context 'for a known campaign', :vcr => {:cassette_name => 'campaign/find/success'} do
      let(:list) { Factory :list }
      let(:campaign) { Factory :standard_campaign, :recipients => list }
      subject { Contactology::Campaign.find campaign.id }
      after(:each) { list.destroy; campaign.destroy }

      it { should be_a Contactology::Campaign }
    end

    context 'for an unknown campaign', :vcr => {:cassette_name => 'campaign/find/failure'} do
      subject { Contactology::Campaign.find 123456789 }

      it { should be_nil }
    end
  end

  context '.find_by_name' do
    context 'for a known campaign', :vcr => {:cassette_name => 'campaign/find_by_name/success'} do
      let(:list) { Factory :list }
      let(:campaign) { Factory :standard_campaign, :recipients => list, :name => 'test-find-by-name' }
      after(:each) { list.destroy; campaign.destroy }
      subject { Contactology::Campaign.find_by_name campaign.name }

      it { should be_a Contactology::Campaign }
      its(:name) { should == campaign.name }
    end

    context 'for an unknown campaign', :vcr => {:cassette_name => 'campaign/find_by_name/failure'} do
      subject { Contactology::Campaign.find_by_name 'unknown' }

      it { should be_nil }
    end
  end

  context '#destroy', :vcr => {:cassette_name => 'campaign/destroy'} do
    let(:list) { Factory :list }
    let(:campaign) { Factory :standard_campaign, :recipients => list }
    after(:each) { list.destroy }

    subject { campaign.destroy }

    it 'removes the campaign from Contactology' do
      expect { subject }.to change { Contactology::Campaign.find campaign.id }.to(nil)
    end

    it { should be_true }
  end

  context '#preview', :vcr => {:cassette_name => 'campaign/preview'} do
    let(:campaign) { Factory :transactional_campaign }
    after(:each) { campaign.destroy }

    subject { campaign.preview }

    it { should be_kind_of Contactology::Campaign::Preview }
    its(:text) { should_not be_nil }
    its(:html) { should_not be_nil }
    its(:links) { should be_kind_of Enumerable }
  end
end
