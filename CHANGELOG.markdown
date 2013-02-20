# contactology changelog

## [Unreleased][unreleased]

* Enhancement
  * Updated and/or loosened dependent library versions in runtime and
    development. This, though, means that **testing is no longer maintained for
    MRI 1.8.7 or REE**. Currently, the library does support them, but
    development dependencies will not install and therefore cannot be
    explicitly tested in those environments.
  * Removed json\_pure, watchr, and infinity\_test development dependencies.

## [0.1.2][v0.1.2] / 2011-08-25

* Enhancement
  * Campaign.find\_by\_name now returns the newest, matching campaign
  * Campaign#start\_time is now returned as a Time instance

* Bug fixes
  * SendResult now captures generic API errors
  * Campaign children now have proper reference of their parent properties

## [0.1.1][v0.1.1] / 2011-08-25

* Bug fixes
  * Return the correct campaign class from Campaign#find and
    Campaign#find\_by\_name

## [0.1.0][v0.1.0] / 2011-08-25

* Enhancements
  * Add Contactology::Campaigns::Transactional#send\_campaign
  * Allow Issues to be created from Hash-derived instances
  * Restrict versions of HTTParty and MultiJson

* Bug fixes
  * Fix failure messages for Campaign#create request timeouts

[unreleased]: http://github.com/nbibler/contactology/compare/v0.1.2...master
[v0.1.2]: http://github.com/nbibler/contactology/compare/v0.1.1...v0.1.2
[v0.1.1]: http://github.com/nbibler/contactology/compare/v0.1.0...v0.1.1
[v0.1.0]: http://github.com/nbibler/contactology/compare/v0.0.2...v0.1.0
