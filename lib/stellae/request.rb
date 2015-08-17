require 'builder'

module Stellae
  class Request

    SCHEMA = {
      soap_envelop: "http://www.w3.org/2003/05/soap-envelope",
      addressing:   "http://www.w3.org/2005/08/addressing",
      datacontract: "http://schemas.datacontract.org/2004/07/",
      instance:     "http://www.w3.org/2001/XMLSchema-instance"
    }

    def initialize(client)
      @client = client
    end

    def construct_xml(type)
      @client.type = type
      xml = Builder::XmlMarkup.new
      xml.s :Envelope, :"xmlns:s" => SCHEMA[:soap_envelop], :"xmlns:a" => SCHEMA[:addressing] do
        build_header(xml, type)
        xml.s :Body do 
          xml.tag! type, :"xmlns" => "SII" do          
            build_user xml
            yield(xml)
          end
        end
      end
      xml.target!
    end

    def build_header(xml, action)
      xml.s :Header do
        xml.a :Action,    "SII/ISIIService/#{action}", :"s:mustUnderstand" => "1"
        xml.a :MessageID, "urn:uuid:56b55a70-8bbc-471d-94bb-9ca060bcf99f"
        xml.a :ReplyTo do
          xml.a :Address, "http://www.w3.org/2005/08/addressing/anonymous"
        end
        xml.a :To, @client.request_uri.split('?').first, :"s:mustUnderstand" => "1"
      end
    end

    def build_user(xml)
      xml.user :"xmlns:b" => SCHEMA[:datacontract], :"xmlns:i" => SCHEMA[:instance] do
        xml.b :user_name,     @client.username
        xml.b :user_password, @client.password
      end
    end

  end
end
