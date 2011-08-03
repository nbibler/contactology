Factory.define :transactional_message, :class => Contactology::TransactionalMessage do |m|
  m.campaign { Factory.build_via_new :transactional_campaign }
  m.contact { Factory.attributes_for :contact }
  m.source 'Factory Created'
end
