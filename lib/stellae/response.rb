module Stellae
  class Response

    CODES = {
      "0001" => "success",
      "0002" => "Bad login information",
      "0003" => "Login points to multiple databases",
      "0005" => "Invalid order type must be OO or CM",
      "0006" => "Error creating order header",
      "0007" => "Bad UPC/EAN13",
      "0008" => "Duplicate order – order number exists in database",
      "0009" => "Problem with line item import"
    }

    attr_accessor :response, :status, :result

    def initialize(raw_response, type)
      build_response(raw_response)
      @type = type
    end

    def build_response(raw_response)
      @response ||= {
        raw:    raw_response,
        parsed: parse_response(raw_response)
      }
    end

    def error
      "Stellae::Error - #{status}"
    end

    def failure?
      !success?
    end

    def status
      @status = CODES[raw_status] || raw_status
    end

    def raw_status
      result['status'][0]
    end

    def result
      @response[:parsed]['Body'][0]["#{@type}Response"][0]["#{@type}Result"][0]
    end

    def success?
      status == 'success'
    end

    def parse_response(xml_response)
      return nil if xml_response.empty?
      XmlSimple.xml_in(xml_response)
    end

  end
end