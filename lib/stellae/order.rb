module Stellae
  class Order < Request

    def build_order_request(order)
      construct_xml "new_order_entry" do |xml|

        xml.ohn :"xmlns:b" => SCHEMA[:datacontract], :"xmlns:i" => SCHEMA[:instance] do
          xml.b :SERVICE,            order[:shipping_code]
          xml.b :USER1,              "<![CDATA[#{order[:invoice_url]}]]>"
          xml.b :CARRIER,            order[:carrier]
          xml.b :CUSTOMER_CODE
          xml.b :DELIVERY_GIFT_WRAP, order[:giftwrap]
          xml.b :DELIVERY_MESSAGE,   "<![CDATA[#{order[:gift_message]}]]>"
          xml.b :EMAIL,              order[:email]
          xml.b :ORDER_ID,           order[:number]
          xml.b :ORDER_TYPE,         order[:type]
          xml.b :DELIVERY_FROM,   :"i:nil" => "true"
          xml.b :DELIVERY_TO,     :"i:nil" => "true"
          xml.b :DELIVERY_ID,     :"i:nil" => "true"
          xml.b :FREIGHT_ACCOUNT, :"i:nil" => "true"
          build_address xml, "CUSTOMER", order[:billing_address]
          build_address xml, "DELIVERY", order[:shipping_address]
          build_line_items xml, order
        end

      end
    end

    private

    def build_address(xml, type, address)
      full_name = "#{address[:first_name]} #{address[:last_name]}"
      xml.b :"#{type}_NAME",            "<![CDATA[#{full_name}]]>"
      xml.b :"#{type}_ADDRESS_1",       "<![CDATA[#{(address[:address1])}]]>"
      xml.b :"#{type}_ADDRESS_2",       "<![CDATA[#{(address[:address2])}]]>"
      xml.b :"#{type}_ADDRESS_3",       "<![CDATA[#{(address[:address3])}]]>"
      xml.b :"#{type}_ADDRESS_CITY",    address[:city]
      xml.b :"#{type}_ADDRESS_COUNTRY", address[:country]
      xml.b :"#{type}_ADDRESS_STATE",   address[:state]
      xml.b :"#{type}_ADDRESS_ZIP",     address[:zipcode]
      xml.b :"#{type}_TELEPHONE",       address[:phone]
    end

    def build_line_items(xml, order)
      xml.b :Order_Details do
        order[:line_items].each do |line_item|
          xml.b :Order_Detail_New do
            xml.b :PRICE,    line_item[:price]
            xml.b :QUANTITY, line_item[:quantity]
            xml.b :SIZE,     line_item[:size]
            xml.b :sku,      line_item[:sku]
          end
        end
      end
    end

  end
end
