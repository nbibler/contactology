# encoding: UTF-8

require 'contactology/campaign'
require 'contactology/campaigns'

class Contactology::Campaigns::Transactional < Contactology::Campaign
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
  property :test_contact, :from => :testContact
  property :test_replacements, :from => :testReplacements


  def self.create(attributes, options = {})
    new(attributes).save(options)
  end


  ##
  # Public: Stores the campaign information onto Contactology.
  #
  # Returns a Transactional instance with the campaign ID when successful.
  # Returns a Contactology::SendResult instance with issues on failure.
  #
  def save(options = {})
    self.class.query('Campaign_Create_Transactional', options.merge({
      'campaignName' => name,
      'content' => content,
      'senderEmail' => sender_email,
      'senderName' => sender_name,
      'subject' => subject,
      'testContact' => test_contact,
      'testReplacements' => test_replacements,
      'optionalParameters' => {
        'authenticate' => authenticate,
        'automaticTweet' => automatic_tweet,
        'clickTaleCustomFields' => click_tale_custom_fields,
        'clickTaleName' => click_tale_name,
        'googleAnalyticsName' => google_analytics_name,
        'recipientName' => recipient_name,
        'replyToEmail' => reply_to_email,
        'replyToName' => reply_to_name,
        'showInArchive' => show_in_archive,
        'trackClickThruHTML' => track_click_thru_html,
        'trackClickThruText' => track_click_thru_text,
        'trackOpens' => track_opens,
        'trackReplies' => track_replies,
        'viewInBrowser' => view_in_browser
      },
      :on_error => Proc.new { |response| process_send_campaign_result response },
      :on_timeout => Proc.new { process_send_campaign_result('success' => false, 'issues' => {'issues' => [{'text' => 'Connection error'}]}) },
      :on_success => Proc.new { |response| self.id = response; self }
    }))
  end


  ##
  # Public: Sends the campaign.
  #
  # Returns an empty collection when successful.
  # Returns a collection of issues when unsuccessful.
  #
  def send_campaign(*contacts)
    options = contacts.extract_options!
    replacements = [options.delete(:replacements)].flatten.compact

    self.class.query('Campaign_Send_Transactional_Multiple', options.merge({
      'campaignId' => id,
      'contacts' => contacts.collect { |c| {'email' => c.email} },
      'source' => options[:source] || 'Customer',
      'replacements' => replacements,
      'optionalParameters' => { 'continueOnError' => true },
      :on_error => Proc.new { |response| process_send_campaign_result response },
      :on_timeout => Proc.new { process_send_campaign_result('success' => false, 'issues' => {'issues' => [{'text' => 'Connection error'}]}) },
      :on_success => Proc.new { process_send_campaign_result({'success' => true}) }
    }))
  end


  private


  def process_send_campaign_result(data)
    if data['errors'].nil?
      Contactology::SendResult.new(data)
    else
      Contactology::SendResult.new('success' => false, 'issues' => {'issues' => data['errors'].collect { |e| {'type' => "#{e['_msg_']} (##{e['_err_']})", 'text' => "#{e['email']} (from #{e['source']})"}} })
    end
  end
end
