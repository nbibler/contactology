# encoding: UTF-8

FactoryGirl.define do
  factory :list, :class => Contactology::List do
    name 'Factory List'

    initialize_with { new(attributes) }
  end
end
