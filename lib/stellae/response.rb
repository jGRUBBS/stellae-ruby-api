require 'hashie'
module Stellae
  class Response

    def initialize(raw_response, type)
      @response = build_response(raw_response)
      @type     = type
    end

    def build_response(raw_response)
      Hashie::Mash.new( 
        raw: raw_response,
        parsed: parse_response(raw_response)
      )
    end

    def failure?
      !success?
    end

    def success?
      @response.parsed["#{@type}_response"]["#{@type}_result"][:status] == '0001'
    end

    def parse_response(xml_response)
      XmlSimple.xml_in(xml_response)
    end

  end
end