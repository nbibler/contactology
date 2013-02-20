# encoding: UTF-8

FactoryGirl.define do
  factory :campaign, :class => Contactology::Campaigns::Standard do
    name 'factory campaign'
    content 'text' => 'This is a good message! {COMPANY_ADDRESS}'
    sender_email 'sender@example.com'
    sender_name 'Sender Example'
    subject 'Factory Campaign Message'

    initialize_with { new(attributes) }

    factory :standard_campaign do
      association :recipients, :factory => :list
    end

    factory :transactional_campaign, :class => Contactology::Campaigns::Transactional do
      test_contact 'email' => 'test-contact@example.com'
      test_replacements 'first_name' => 'John'
    end
  end
end
