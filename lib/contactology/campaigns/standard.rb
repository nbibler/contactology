# encoding: UTF-8

require 'contactology/campaign'
require 'contactology/campaigns'

class Contactology::Campaigns::Standard < Contactology::Campaign
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
  property :content, :required => true
  property :name, :from => :campaignName, :required => true
  property :recipients, :required => true
  property :sender_email, :from => :senderEmail, :required => true
  property :sender_name, :from => :senderName, :required => true
  property :subject, :required => true


  def []=(property, value)
    if property.to_s == 'recipients'
      super 'recipients', normalize_recipients(value)
    else
      super
    end
  end

  def save(options = {})
    self.class.query('Campaign_Create_Standard', options.merge({
      'recipients' => recipients,
      'campaignName' => name,
      'subject' => subject,
      'senderEmail' => sender_email,
      'senderName' => sender_name,
      'content' => content,
      'optionalParameters' => {
        'authenticate' => authenticate,
        'replyToEmail' => reply_to_email,
        'replyToName' => reply_to_name,
        'trackReplies' => track_replies,
        'recipientName' => recipient_name,
        'showInArchive' => show_in_archive,
        'viewInBrowser' => view_in_browser,
        'trackOpens' => track_opens,
        'trackClickThruHTML' => track_click_thru_html,
        'trackClickThruText' => track_click_thru_text,
        'googleAnalyticsName' => google_analytics_name,
        'clickTaleName' => click_tale_name,
        'clickTaleCustomFields' => click_tale_custom_fields,
        'automaticTweet' => automatic_tweet
      },
      :on_error => false,
      :on_timeout => false,
      :on_success => Proc.new { |response| self.id = response; self }
    }))
  end

  ##
  # Public: Sends the campaign.
  #
  # Returns an empty collection when successful.
  # Returns a collection of issues when unsuccessful.
  #
  def send_campaign(options = {})
    self.class.query('Campaign_Send', options.merge({
      'campaignId' => id,
      :on_error => Proc.new { |response| process_send_campaign_result response },
      :on_timeout => process_send_campaign_result({'success' => false, 'issues' => {'issues' => [{'text' => 'Connection timeout'}]}}),
      :on_success => Proc.new { |response| process_send_campaign_result response }
    }))
  end


  private


  def normalize_recipients(input)
    input = [input].flatten.compact.uniq
    input = input.select { |i| i.kind_of?(Contactology::List) }.collect { |list| list.id }
    input = {'list' => input.size == 1 ? input.first : input}
    input
  end

  def process_send_campaign_result(data)
    Contactology::SendResult.new(data)
  end
end
