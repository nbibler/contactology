# Contactology [![Build status][ci-image]][ci]

This library provides a Ruby interface to the [Contactology email marketing
API][api].

## Quick start

```ruby
require 'contactology'

Contactology.key = 'aBcDeFg12345'

list = Contactology::List.find(4)
# => #<Contactology::List:0x000... @list_id="4" @name="test list" ...>

list.subscribe('joe@example.local')
# => true

contact = Contactology::Contact.find('joe@example.local')
# => #<Contactology::Contact:0x000... @email="joe@example.local" ...>

contact.lists
# => [#<Contactology::List:0x000... @list_id="4" ...>]

campaign = Contactology::Campaign.find_by_name('test campaign')
# => #<Contactology::Campaign:0x000... @name="test campaign" ...>

result = campaign.send_campaign
# => #<Contactology::SendResult:0x000... @success=true @issues=[]>

result.successful?
# => true

result.issues
# => []
```

## API support

This library supports the Contactology V2, or "REST," API.

### Intentions

This library is not currently intended to fully implement all of the API
methods which Contactology makes available. Instead, it will focus on those
methods which are of immediate practical use in production applications. This
should ensure that the interface is well exercised and continuously updated.

Feel free to fork and submit pull requests to expand the feature set to meet
your needs.

## Ruby compatibility

This library uses [Travis CI][ci] to continuously test and remain compatible
with the following Rubies:

* MRI Ruby 1.8.7,
* MRI Ruby 1.9.2,
* MRI Ruby 1.9.3, and
* REE 1.8.7


[api]: http://www.contactology.com/email-marketing-api/ (Contactology API Documentation)
[ci]: http://travis-ci.org/nbibler/contactology
[ci-image]: https://secure.travis-ci.org/nbibler/contactology.png
