# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :development)
require 'hashie'
require 'stellae'
require 'support/vcr'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

def order_hash
{
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
  currency:     "USD",
  line_items: [
    {
      price:    "127.23",
      quantity: "1",
      sku:      "326604071",
      size:     "XS"
    }
  ],
  shipping_code: "90",
  invoice_url:   "http://example.com/R123123123/invoice",
  shipping_cost: 10,
  shipping_discount: -5,
  item_discount: 0,
  total_amount: 132.23
}
end
