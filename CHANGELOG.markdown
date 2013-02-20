### 0.1.2 / 2011-08-25

[full changelog](http://github.com/nbibler/contactology/compare/v0.1.1...v0.1.2)

* Enhancement
  * Campaign.find_by_name now returns the newest, matching campaign
  * Campaign#start_time is now returned as a Time instance

* Bug fixes
  * SendResult now captures generic API errors
  * Campaign children now have proper reference of their parent properties

### 0.1.1 / 2011-08-25

[full changelog](http://github.com/nbibler/contactology/compare/v0.1.0...v0.1.1)

* Bug fixes
  * Return the correct campaign class from Campaign#find and Campaign#find_by_name

### 0.1.0 / 2011-08-25

[full changelog](http://github.com/nbibler/contactology/compare/v0.0.2...v0.1.0)

* Enhancements
  * Add Contactology::Campaigns::Transactional#send_campaign
  * Allow Issues to be created from Hash-derived instances
  * Restrict versions of HTTParty and MultiJson

* Bug fixes
  * Fix failure messages for Campaign#create request timeouts
