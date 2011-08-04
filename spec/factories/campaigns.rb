# encoding: UTF-8

Factory.define :standard_campaign, :class => Contactology::Campaigns::Standard do |c|
  c.content 'text' => 'This is a good message! {COMPANY_ADDRESS}'
  c.name 'factory campaign'
  c.recipients { Factory.build_via_new :list }
  c.sender_email 'nate@envylabs.com'
  c.sender_name 'Nate Bibler'
  c.subject 'Factory Campaign Message'
end

Factory.define :transactional_campaign, :class => Contactology::Campaigns::Transactional do |c|
  c.content 'text' => 'This is a good email. {COMPANY_ADDRESS}'
  c.name 'factory campaign'
  c.sender_email 'sender@example.com'
  c.sender_name 'Sender Example'
  c.subject 'Test Creation'
  c.test_contact 'email' => 'test-contact@example.com'
  c.test_replacements 'first_name' => 'John'
end
