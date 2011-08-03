require 'contactology/stash'

module Contactology
  class Campaign
    class Preview < Contactology::Stash
      property :html
      property :text
      property :links
    end
  end
end
