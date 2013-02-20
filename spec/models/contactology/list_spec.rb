# encoding: UTF-8

require 'spec_helper'

describe Contactology::List do
  context '.all', :vcr => {:cassette_name => 'list/all'} do
    let!(:list) { Contactology::List.create :name => 'all-test-list' }
    after(:each) { list.destroy }

    subject { Contactology::List.all }

    it { should be_kind_of Enumerable }
    it { should_not be_empty }

    it 'contains List instances' do
      subject.each do |o|
        o.should be_kind_of Contactology::List
      end
    end

    it 'contains the created list' do
      subject.any? { |remote_list|
        remote_list.id == list.id &&
          remote_list.name == list.name
      }.should be_true
    end
  end

  context '.create' do
    it 'raises an ArgumentError without a name given' do
      expect {
        Contactology::List.create
      }.to raise_error(ArgumentError)
    end

    context 'when successful', :vcr => {:cassette_name => 'list/create'} do
      let(:list) { Contactology::List.create :name => 'creationtest' }
      subject { list }
      after(:each) { list.destroy }

      it { should be_instance_of Contactology::List }
      it { should be_public }

      its(:name) { should eql 'creationtest' }
      its(:id) { should_not be_empty }
      its(:type) { should eql 'public' }
    end
  end

  context '.find' do
    context 'when successful', :vcr => {:cassette_name => 'list/find/success'} do
      let(:list) { Contactology::List.create :name => 'find-success' }
      subject { Contactology::List.find list.id }
      after(:each) { list.destroy }

      it { should be_kind_of Contactology::List }
      it { should be_public }
      it { should_not be_opt_in }
      its(:id) { should == list.id }
      its(:name) { should == list.name }
    end

    context 'for an unknown list', :vcr => {:cassette_name => 'list/find/unknown'} do
      subject { Contactology::List.find '123456789' }

      it { should be_nil }
    end
  end

  context '#destroy', :vcr => {:cassette_name => 'list/destroy'} do
    let(:list) { Contactology::List.create :name => 'destroy-list' }
    subject { list.destroy }

    it 'removes the list from Contactology and returns true' do
      # specs combined for VCR consistency.
      expect { subject }.to change { Contactology::List.find list.id }.to(nil)
      should be_true
    end
  end

  context '#import' do
    context 'when successful', :vcr => {:cassette_name => 'list/import/success'} do
      let(:list) { Contactology::List.create :name => 'import-test' }
      let(:email) { 'import@example.com' }
      let(:contact) { Contactology::Contact.find email }
      after(:each) { list.destroy; contact.destroy if contact }

      subject { list.import [{'email' => email}] }

      it { should be_true }
    end

    context 'with an failure' do
    end
  end

  context '#subscribe' do
    context 'when successful', :vcr => {:cassette_name => 'list/subscribe/success'} do
      let(:contact) { Contactology::Contact.create :email => 'successful-subscribe@example.com' }
      let(:list) { Contactology::List.create :name => 'subscribe-test' }
      after(:each) { contact.destroy; list.destroy }
      subject { list.subscribe contact.email }

      it { should be_true }
    end
  end

  context '#unsubscribe' do
    context 'when successful', :vcr => {:cassette_name => 'list/unsubscribe/success'} do
      let(:contact) { Contactology::Contact.create :email => 'successful-unsubscribe@example.com' }
      let(:list) { Contactology::List.create :name => 'unsubscribe-test' }
      before(:each) { list.subscribe contact.email }
      after(:each) { contact.destroy; list.destroy }
      subject { list.unsubscribe contact.email }

      it { should be_true }
    end
  end
end
