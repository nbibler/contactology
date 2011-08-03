require 'contactology/stash'

module Contactology
  class TransactionalMessage < Contactology::Stash
    extend API

    property :campaign, :required => true
    property :contact, :required => true
    property :source, :required => true
    property :replacements, :required => true

    def replacements
      self['replacements'] || Hash.new
    end

    def send_message(options = {})
      self.class.query('Campaign_Send_Transactional', options.merge({
        'campaignId' => campaign.id,
        'contact' => normalize_contact(contact),
        'source' => source,
        'replacements' => {:_contactology => 'Contactology'}.merge(replacements),
        :on_error => false,
        :on_timeout => false,
        :on_success => true
      }))
    end


    private


    def normalize_contact(contact)
      return contact if contact.kind_of?(Hash)

      { 'email' => contact.email }
    end
  end
end
