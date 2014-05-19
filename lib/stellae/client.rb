require 'net/http'
require 'xmlsimple'

module Stellae
  class Client

    TEST_HOST = "www.stellae.us"
    TEST_PATH = "/webservices/SIIService.svc?wsdl"
    LIVE_HOST = "www.stellae.us"
    LIVE_PATH = "/webservices/SIIService.svc?wsdl"

    attr_accessor :username, :password, :response, :type

    def initialize(username, password, options = {})
      raise "Username is required" unless username
      raise "Password is required" unless password

      @username = username
      @password = password
      @options  = default_options.merge!(options)
    end

    def send_order_request(order)
      request  = Order.new(self).build_order_request(order)
      response = post(request)
    end

    def get_inventory
      request  = Inventory.new(self).build_inventory_request
      response = post(request)
    end

    private
    def default_options
      { 
        verbose: true,
        test_mode: false
      }
    end

    def testing?
      @options[:test_mode]
    end

    def verbose?
      @options[:verbose]
    end

    def host
      testing? ? TEST_HOST : LIVE_HOST 
    end

    def path
      testing? ? TEST_PATH : LIVE_PATH
    end

    def log(message)
      return unless verbose?
      puts message
    end

    def post(xml_request)
      http     = Net::HTTP.new(host, 80)
      response = http.post(path, xml_request, {'Content-Type' => 'text/xml'})
      log response
      parse_response(response, @type)
    end

    def parse_response(xml_response)
      @response = Response.new(xml_response, @type)
    end

  end
end
