# encoding: UTF-8

require 'contactology/stash'
require 'contactology/api' 
require 'contactology/send_result'

module Contactology
  ##
  # Campaigns represent mailing objects on Contactology.  These objects may be
  # "standard," meaning that they go out to a List, or "transactional," meaning
  # that they're generated per recipient and used multiple times.
  #
  class Campaign < Contactology::Stash
    autoload :Preview, 'contactology/campaign/preview'

    extend API

    property :content
    property :content_type, :from => :contentType
    property :id, :from => :campaignId
    property :name, :from => :campaignName
    property :recipient_name, :from => :recipientName
    property :recipients
    property :reply_to_email, :from => :replyToEmail
    property :reply_to_name, :from => :replyToName
    property :sender_email, :from => :senderEmail
    property :sender_name, :from => :senderName
    property :status
    property :subject
    property :type
    property :start_time, :from => :startTime
    property :authenticate
    property :track_replies, :from => :trackReplies
    property :show_in_archive, :from => :showInArchive
    property :view_in_browser, :from => :viewInBrowser
    property :track_opens, :from => :trackOpens
    property :track_click_thru_html, :from => :trackClickThruHTML
    property :track_click_thru_text, :from => :trackClickThruText
    property :google_analytics_name, :from => :googleAnalyticsName
    property :automatic_tweet, :from => :automaticTweet
    property :click_tale_name, :from => :clickTaleName
    property :click_tale_custom_fields, :from => :clickTaleCustomFields
    property :custom_fields, :from => :customFields


    ##
    # Public: Creates a new Campaign on Contactology. This method should not
    # be directly called, but instead called through the Standard or
    # Transactional campaign classes.
    #
    # Returns a campaign instance when successful.
    # Returns false when unsuccessful.
    #
    def self.create(attributes, options = {})
      campaign = new(attributes)
      campaign.save(options) ? campaign : false
    end

    ##
    # Public: Load the campaign details for a given Contactology Campaign ID.
    #
    # Returns a Contactology::Campaign instance when found.
    # Returns nil for an unrecognized ID or network error.
    #
    def self.find(id, options = {})
      query('Campaign_Get_Info', options.merge({
        'campaignId' => id,
        :on_success => Proc.new { |r| new_campaign_from_response(r) }
      }))
    end

    def self.find_by_name(name, options = {})
      query('Campaign_Find', options.merge({
        'searchParameters' => {
          'campaignName' => name
        },
        :on_success => Proc.new { |r|
          unless r.nil?
            data = r.values.max { |a,b| a['startTime'] <=> b['startTime'] }
            new_campaign_from_response(data)
          end
        }
      }))
    end


    ##
    # Public: Removes the Campaign from Contactology.
    #
    # Returns true when successful.
    # Returns false when unsuccessful or for a network error.
    #
    def destroy(options = {})
      self.class.query('Campaign_Delete', options.merge({
        'campaignId' => id,
        :on_timeout => false,
        :on_error => false,
        :on_success => Proc.new { |response| response }
      }))
    end

    ##
    # Private: This method should be overridden by subclasses of Campaign.
    #
    # Raises NotImplementedError.
    #
    def save(options = {})
      raise NotImplementedError
    end

    ##
    # Public: Creates the instance on Contactology or raises an exception.
    #
    # Returns the campaign instance when successful.
    # Raises InvalidObjectError when unsuccessful.
    #
    def save!(options = {})
      save(options) || raise(InvalidObjectError)
    end

    def start_time
      if self['start_time']
        Time.strptime(self['start_time'] + 'Z', '%Y-%m-%d %H:%M:%S%Z')
      end
    end

    def preview(options = {})
      self.class.query('Campaign_Preview', options.merge({
        'campaignId' => id,
        :on_error => false,
        :on_timeout => false,
        :on_success => Proc.new { |response| Preview.new(response) }
      }))
    end


    private


    def self.new_campaign_from_response(response)
      case response['type']
      when 'transactional'
        Campaigns::Transactional.new(response)
      when 'standard'
        Campaigns::Standard.new(response)
      else
        Campaign.new(response)
      end
    end
  end
end
