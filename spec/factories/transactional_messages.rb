# encoding: UTF-8

FactoryGirl.define do
  factory :transactional_message, :class => Contactology::TransactionalMessage do
    association :campaign, :factory => :transactional_campaign
    contact { FactoryGirl.attributes_for :contact }
    source 'Factory Created'

    initialize_with { new(attributes) }
  end
end
