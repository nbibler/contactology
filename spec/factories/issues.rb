# encoding: UTF-8

FactoryGirl.define do
  factory :issue, :class => Contactology::Issue do
    level ''
    type 'SPAM'
    text 'BODY: TVD_SPACE_RATIO'
    message ''
    context ''
    col ''
    deduction 29

    initialize_with { new(attributes) }
  end
end
