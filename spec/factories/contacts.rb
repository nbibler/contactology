# encoding: UTF-8

FactoryGirl.define do
  factory :contact, :class => Contactology::Contact do
    email 'factory-contact@example.com'

    initialize_with { new(attributes) }
  end
end
