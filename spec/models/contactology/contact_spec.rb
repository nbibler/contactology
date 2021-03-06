# encoding: UTF-8

require 'spec_helper'

describe Contactology::Contact do
  context '.create', :vcr => {:cassette_name => 'contact/create'} do

    it 'raises an ArgumentError without an :email given' do
      expect {
        Contactology::Contact.create
      }.to raise_error(ArgumentError)
    end

    context 'when successful' do
      let(:contact) { Contactology::Contact.create :email => 'created@example.com' }
      subject { contact }
      after(:each) { contact.destroy }

      it 'creates a new contact and returns a Contactology::Contact' do
        # Combined specs for VCR recording consistency.
        should be_a Contactology::Contact
        Contactology::Contact.find('created@example.com').should_not be_nil
      end

      its(:email) { should eql 'created@example.com' }
      its(:active?) { should be_true }
    end
  end

  context '.find' do
    context 'for a matching, active contact', :vcr => {:cassette_name => 'contact/find/active'} do
      let(:contact) { Contactology::Contact.create(:email => 'found@example.com') }
      after(:each) { contact.destroy }
      subject { Contactology::Contact.find(contact.email) }

      it { should be_kind_of Contactology::Contact }
      its(:email) { should eql 'found@example.com' }
      it { should be_active }
    end

    context 'for a matching, suppressed contact', :vcr => {:cassette_name => 'contact/find/suppressed', :match_requests_on => [:api_uri]} do
      let(:contact) { Contactology::Contact.create(:email => "found-suppressed-%0.2f-%d@example.com" % [Time.now.to_f, rand(100_000)]) }
      before(:each) { contact.suppress }
      after(:each) { contact.destroy }
      subject { Contactology::Contact.find('found-suppressed@example.com') }

      it { should be_kind_of Contactology::Contact }
      its(:email) { should eql 'found-suppressed@example.com' }

      it 'should be suppressed' do
        pending("Contactology is incorrectly indicating that the user is suppressed, but leaving them active.") do
          should be_suppressed
        end
      end
    end

    context 'for an unknown email', :vcr => {:cassette_name => 'contact/find/unknown'} do
      subject { Contactology::Contact.find('unknown@example.com') }
      it { should be_nil }
    end
  end

  context '#active?', :vcr => {:cassette_name => 'contact/active'} do
    let(:contact) do
      Contactology::Contact.create :email => 'active@example.com'
      Contactology::Contact.find 'active@example.com'
    end
    subject { contact.active? }
    after(:each) { contact.destroy }

    it { should be_true }
  end

  context '#change_email' do
    context 'for a known contact', :vcr => {:cassette_name => 'contact/change_email/success', :match_requests_on => [:api_uri]} do
      let(:contact) { Contactology::Contact.create :email => 'change-email-3@example.com' }
      let(:new_email) { "changed-%d-%d@example.com" % [Time.now.to_f, rand(100_000)] }
      subject { contact.change_email new_email }
      after(:each) { contact.destroy }

      it 'updates the Contactology email' do
        expect { subject }.to change { Contactology::Contact.find new_email }.from(nil)
      end

      it { should be_true }

      it 'updates the local contact email' do
        expect { subject }.to change(contact, :email).to(new_email)
      end
    end

    context 'for an unknown contact', :vcr => {:cassette_name => 'contact/change_email/unknown'} do
      let(:contact) { Contactology::Contact.new(:email => 'unknown@example.com') }
      subject { contact.change_email 'changefail@example.com' }

      it { should be_false }

      it 'does not update the local contact email' do
        expect { subject }.to_not change(contact, :email)
      end
    end
  end

  context '#destroy', :vcr => {:cassette_name => 'contact/destroy'} do

    context 'when successful' do
      let(:contact) { Contactology::Contact.create :email => 'destroy@example.com' }
      subject { contact.destroy }

      it 'deletes the contact on Contactology' do
        expect { subject }.to change(contact, :deleted?).to(true)
      end

      it { should be_true }
    end
  end

  context '#lists' do
    context 'for a known contact with subscription lists', :vcr => {:cassette_name => 'contact/lists/full'} do
      let(:contact) { Contactology::Contact.create :email => 'lists@example.com' }
      let(:list) { Contactology::List.create :name => 'contact-list-test' }
      before(:each) { list.subscribe contact.email }
      after(:each) { contact.destroy; list.destroy }

      subject { contact.lists }

      it 'contains the subscribed list' do
        # Combined specs for VCR recording consistency.
        should be_an Enumerable
        should_not be_empty
        subject.any? { |remote_list| remote_list.id == list.id }.should be_true
      end
    end

    context 'for a known contact without subscription lists', :vcr => {:cassette_name => 'contact/lists/empty'} do
      let(:contact) { Contactology::Contact.create :email => 'emptylists@example.com' }
      subject { contact.lists }
      after(:each) { contact.destroy }

      it { should be_kind_of Enumerable }
      it { should be_empty }
    end

    context 'for an unknown contact', :vcr => {:cassette_name => 'contact/lists/unknown'} do
      let(:contact) { Contactology::Contact.new :email => 'unknown@example.com' }
      subject { contact.lists }
      after(:each) { contact.destroy }

      it { should be_kind_of Enumerable }
      it { should be_empty }
    end
  end

  context '#suppress', :vcr => {:cassette_name => 'contact/suppress'} do
    let(:contact) do
      Contactology::Contact.create :email => 'suppressed@example.com'
      Contactology::Contact.find 'suppressed@example.com'
    end
    subject { contact.suppress }
    after(:each) { contact.destroy }

    it { should be_true }

    context 'the contact' do
      subject { contact.suppress; contact }

      its(:suppressed?) { should be_true }
    end
  end
end
