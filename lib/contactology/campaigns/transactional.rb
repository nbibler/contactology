# encoding: UTF-8

require 'contactology/campaign'
require 'contactology/campaigns'

class Contactology::Campaigns::Transactional < Contactology::Campaign
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
      :on_timeout => process_send_campaign_result('success' => false, 'issues' => [{'text' => 'Connection error'}]),
      :on_success => Proc.new { |response| self.id = response; self }
    }))
  end


  private


  def process_send_campaign_result(data)
    Contactology::SendResult.new(data)
  end
end
