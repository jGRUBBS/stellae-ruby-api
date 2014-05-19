# Stellae

[![Build Status](https://travis-ci.org/jGRUBBS/stellae-ruby-api.svg?branch=master)](https://travis-ci.org/jGRUBBS/stellae-ruby-api)
[![Code Climate](https://codeclimate.com/github/jGRUBBS/stellae-ruby-api.png)](https://codeclimate.com/github/jGRUBBS/stellae-ruby-api)

Ruby library for interfacing with the Stellae Fulfillment API

## Installation

Add this line to your application's Gemfile:

    gem 'stellae-ruby-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stellae-ruby-api

## Usage

```ruby

order = {
  carrier: "FEDEX",
  billing_address:  { 
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    address3:   "",
    city:       "New York",
    state:      "New York",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  shipping_address: {
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    address3:   "",
    city:       "New York",
    state:      "New York",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  gift_wrap:    "true",
  gift_message: "Happy Birthday!",
  email:        "someone@somehwere.com",
  number:       "R123123123",
  type:         "OO",
  line_items: [
    {
      price:    "127.23",
      quantity: "1",
      sku:      "123332211",
      size:     "XS"
    }
  ],
  shipping_code: "90",
  invoice_url:   "http://example.com/R123123123/invoice"
}

client   = Stellae::Client.new("username", "password")
response = client.send_order_request(order)

if response.success?
  # DO SOMETHING
else
  # QUEUE REQUEST, STORE AND RAISE ERRORS
end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
