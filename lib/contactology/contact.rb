# encoding: UTF-8

require 'contactology/stash'
require 'contactology/api' 

module Contactology
  ##
  # Represents a Contact on Contactology.  Contacts always must have an email
  # address and then may optionally carry other custom fields.
  #
  class Contact < Contactology::Stash
    extend API

    property :id, :from => :contactId
    property :email, :required => true
    property :status
    property :source
    property :custom_fields, :from => :customFields


    ##
    # Public: Create a new contact.  The only required attribute is an :email
    # address.
    #
    # Examples
    # 
    #   Contactology::Contact.create(:email => 'joe@example.local')
    #   # => #<Contactology::Contact:0x000... @email="joe@example.com" ...>
    #
    # Returns a Contactology::Contact instance when successful.
    # Returns false when unsuccessful or a network error occurs.
    #
    def self.create(attributes, options = {})
      contact = new(attributes)
      contact.save(options) ? contact : false
    end

    ##
    # Public: Lookup a contact's information by email address.
    #
    # Examples
    #
    #   Contactology::Contact.find('joe@example.local')
    #   # => #<Contactology::Contact:0x000... @email="joe@example.local" ...>
    #
    # Returns a Contactology::Contact instance when a match is found. Otherise,
    # returns nil.
    #
    def self.find(email, options = {})
      query('Contact_Get', options.merge({
        'email' => email,
        'optionalParameters' => {'getAllCustomFields' => true},
        :on_timeout => nil,
        :on_error => nil,
        :on_success => Proc.new { |response|
          Contact.new(response.values.first) if response.respond_to?(:values)
        }
      }))
    end


    ##
    # Public: Indicates whether or not the contact is active.  Active contacts
    # may receive mailings from your campaigns.
    #
    # Returns true if active.
    # Returns false if non-active.
    #
    def active?
      status == 'active'
    end

    ##
    # Public: Indicates whether or not the contact has a bounced address. This
    # means that mail delivery has failed in a way that Contactology is no
    # longer sending mailings to this contact.
    #
    # Returns true if bounced.
    # Returns false if non-bounced.
    #
    def bounced?
      status == 'bounced'
    end

    ##
    # Public: Changes the contact's email address to the new address given.
    #
    # Examples
    #
    #   contact = Contactology::Contact.find('joe@example.local')
    #   # => #<Contactology::Contact:0x000... @email="joe@example.local" ...>
    #   contact.change_email('jim@example.local')
    #   # => true
    #   contact.email
    #   # => 'jim@example.local'
    #
    # Returns true when successful.
    # Returns false when unsuccessful or for a network failure.
    #
    def change_email(new_email, options = {})
      self.class.query('Contact_Change_Email', options.merge({
        'email' => email,
        'newEmail' => new_email,
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response| self.email = new_email; true }
      }))
    end

    def deleted?
      status == 'deleted'
    end

    ##
    # Public: Removes the contact from Contactology and from your account.
    #
    # Examples
    #
    #   contact = Contactology::Contact.find('joe@example.local')
    #   # => #<Contactology::Contact:0x000... @email="joe@example.local" ...>
    #   contact.destroy
    #   # => true
    # 
    # Returns true when successful.
    # Returns false when unsuccessful or for a network failure.
    #
    def destroy(options = {})
      self.class.query('Contact_Delete', options.merge({
        :email => email,
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |r| self.status = 'deleted'; true }
      }))
    end

    def lists(options = {})
      self.class.query('Contact_Get_Subscriptions', options.merge({
        'email' => email,
        :on_timeout => [],
        :on_error => [],
        :on_success => Proc.new { |response|
          response.collect { |listid| ListProxy.new(listid) }
        }
      }))
    end

    def save(options = {})
      self.class.query('Contact_Add', {
        'email' => email,
        'customFields' => custom_fields,
        'optionalParameters' => {'updateCustomFields' => true},
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response| self.status = 'active'; self }
      })
    end

    def save!(options = {})
      save(options) || raise(InvalidObjectError)
    end

    ##
    # Public: Suppresses the contact, removing them from receiving campaign
    # mailings.
    #
    # Returns true when successful.
    # Returns false when unsuccessful.
    #
    def suppress(options = {})
      response = self.class.query('Contact_Suppress', options.merge({
        :email => email,
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response| response }
      }))

      if response
        self.status = 'suppressed'
      end

      response
    end

    ##
    # Public: Indicates whether or not the contact is suppressed.  Suppressed
    # contacts may not receive mailings from your campaigns.
    #
    # Returns true if suppressed.
    # Returns false if non-suppressed.
    #
    def suppressed?
      status == 'suppressed'
    end
  end
end
