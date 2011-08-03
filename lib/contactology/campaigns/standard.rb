require 'contactology/campaign'
require 'contactology/campaigns'

class Contactology::Campaigns::Standard < Contactology::Campaign
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
      :on_timeout => process_send_campaign_result({'success' => false, 'issues' => [{'text' => 'Connection timeout'}]}),
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
