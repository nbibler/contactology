require 'contactology/stash'
require 'contactology/api' 

module Contactology
  ##
  # Represents a subscription List in Contactology. Lists are a convenient way
  # to organize groups of Contacts in order to send large numbers of contacts
  # a Campaign, easily.
  #
  class List < Contactology::Stash
    extend API

    property :id, :from => :listId
    property :name, :required => true
    property :description
    property :type
    property :opt_in, :from => :optIn


    ##
    # Public: Returns a collection of all active lists on your account.
    #
    # Returns a collection of Contactology::List instances.
    #
    def self.all(options = {})
      query('List_Get_Active_Lists', options.merge({
        :on_timeout => [],
        :on_error => [],
        :on_success => Proc.new { |response| response.values.collect { |list| List.new(list) }}
      }))
    end

    ##
    # Public: Creates a new, public list on Contactology. The new list's :name
    # is the only required attribute.
    #
    # Returns a Contactology::List instance when successful.
    # Returns false when unsuccessful or a network failure occurs.
    #
    def self.create(attributes, options = {})
      raise ArgumentError, 'Expected an :name attribute' unless attributes.has_key?(:name)
      new(attributes).save(options)
    end

    ##
    # Public: Loads a Contactology list by ID.
    #
    # Returns a Contactology::List instance on success.
    # Returns nil for an unknown ID or network error.
    #
    def self.find(id, options = {})
      query('List_Get_Info', options.merge({
        'listId' => id,
        :on_timeout => nil,
        :on_error => nil,
        :on_success => Proc.new { |response| new(response) if response.kind_of?(Hash) }
      }))
    end


    ##
    # Public: Removes a list from Contactology.
    #
    # Returns true when successful.
    # Returns false when unsuccessful.
    #
    def destroy(options = {})
      self.class.query('List_Delete', options.merge({
        'listId' => id,
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response| response }
      }))
    end

    ##
    # Public: Imports contacts into a list using a prescribed contact
    # collection format.
    #
    # Examples
    #
    #   list = Contactology::List.create :name => 'import-test'
    #   # => #<Contactology::List:0x000... @name="import-test" ...>
    #   list.import([{'email' => 'import@example.local', 'first_name' => 'Imp', 'last_name' => 'Orted'}, {...}])
    #   # => true
    #
    # Returns true if all contacts imported successfully.
    # Returns false if any contact import failed or a network error occurred.
    #
    def import(contacts, options = {})
      self.class.query('List_Import_Contacts', options.merge({
        'listId' => id,
        'source' => options[:source] || 'Manual Entry',
        'contacts' => contacts,
        'optionalParameters' => {
          'activateDeleted' => true,
          'updateCustomFields' => true
        },
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response|
          response.kind_of?(Hash) && response['success'] == contacts.size
        }
      }))
    end

    def internal?
      type == 'internal'
    end

    def opt_in?
      opt_in
    end

    def public?
      type == 'public'
    end

    def private?
      type == 'private'
    end

    def save(options = {})
      self.class.query('List_Add_Public', options.merge({
        'listId' => id,
        'name' => name,
        'description' => description,
        'optionalParameters' => {
          'optIn' => opt_in
        },
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response|
          data = self.class.find(response)
          self.id = data.id
          self.description = data.description
          self.name = data.name
          self.type = data.type
          self.opt_in = data.opt_in
          self
        }
      }))
    end

    def save!(options = {})
      save(options) || raise(InvalidObjectError)
    end

    ##
    # Public: Adds an email address to the list.
    #
    # Examples
    #
    #   list = Contactology::List.find 1
    #   # => #<Contactology::List:0x000... @id="1" ...>
    #   list.subscribe 'new@example.local'
    #   # => true
    #
    # Returns true when the address is successfully added.
    # Returns false when the subscription fails or a network error occurs.
    #
    def subscribe(email, options = {})
      self.class.query('List_Subscribe', options.merge({
        'listId' => id,
        'email' => email.respond_to?(:email) ? email.email : email,
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response| response }
      }))
    end

    def test?
      type == 'test'
    end

    ##
    # Public: Unsubscribes an email address from the Contactology::List.
    #
    # Returns true when the address is removed.
    # Returns false when the removal fails or a network error occurs.
    #
    def unsubscribe(email, options = {})
      self.class.query('List_Unsubscribe', options.merge({
        'listId' => id,
        'email' => email,
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response| response }
      }))
    end
  end
end
