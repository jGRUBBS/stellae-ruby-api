module Stellae
  class Order < Request

    def build_order_request(order)
      construct_xml "new_order_entry" do |xml|

        xml.ohn :"xmlns:b" => SCHEMA[:datacontract], :"xmlns:i" => SCHEMA[:instance] do
          xml.b :CARRIER,            order[:carrier]
          xml.b :CURRENCY,           order[:currency]
          build_address(xml, "CUSTOMER", order[:billing_address])
          xml.b :CUSTOMER_CODE
          xml.b :CUSTOMER_PO, :"i:nil" => "true"
          build_address xml, "DELIVERY", order[:shipping_address]
          xml.b :DELIVERY_DC_EDI,   :"i:nil" => "true"
          xml.b :DELIVERY_DOOR_EDI, :"i:nil" => "true"
          xml.b :DELIVERY_FROM,     :"i:nil" => "true"
          xml.b :DELIVERY_ID,       :"i:nil" => "true"
          xml.b :DELIVERY_MESSAGE do
            xml.cdata!(order[:gift_message])
          end
          xml.b :DELIVERY_TO,     :"i:nil" => "true"
          xml.b :DISCOUNT,           order[:item_discount] || 0
          xml.b :EMAIL,              order[:email]
          xml.b :FREIGHT_ACCOUNT, :"i:nil" => "true"
          xml.b :MISC1, 0
          xml.b :MISC1_REASON,    :"i:nil" => "true"
          xml.b :MISC2, 0
          xml.b :MISC2_REASON,    :"i:nil" => "true"
          xml.b :ORDER_ID,           order[:number]
          xml.b :ORDER_TYPE,         order[:type] || 'OO'
          build_line_items xml, order
          xml.b :SERVICE,            order[:shipping_code]
          xml.b :SHIPPING_FEES,      shipping_fees(order)
          xml.b :TAXES,              order[:tax] || 0
          xml.b :TOTAL_AMOUNT,       order[:total_amount] || 0
          xml.b :USER1 do
            xml.cdata!(order[:invoice_url])
          end
          xml.b :USER2,     :"i:nil" => "true"
          xml.b :USER3,     :"i:nil" => "true"
          xml.b :USER4,     :"i:nil" => "true"
          xml.b :USER5,     :"i:nil" => "true"
          xml.b :WAREHOUSE, :"i:nil" => "true"
        end

      end
    end

    private

    def build_address(xml, type, address)
      full_name = "#{address[:first_name]} #{address[:last_name]}"
      xml.b :"#{type}_NAME" do
        xml.cdata!(full_name)
      end
      xml.b :"#{type}_ADDRESS_1" do
        xml.cdata!(address[:address1])
      end
      xml.b :"#{type}_ADDRESS_2" do
        xml.cdata!(address[:address2])
      end
      xml.b :"#{type}_ADDRESS_3" do
        xml.cdata!(address[:address3]) if address[:address3]
      end
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
            xml.b :COST,         :"i:nil" => "true"
            xml.b :FLAGS,        :"i:nil" => "true"
            xml.b :LINE_ID,      :"i:nil" => "true"
            xml.b :LOT_NUMBER,   :"i:nil" => "true"
            xml.b :PRICE,        line_item[:price]
            xml.b :QUANTITY,     line_item[:quantity]
            xml.b :RETAIL_PRICE, :"i:nil" => "true"
            xml.b :SEASON,       :"i:nil" => "true"
            xml.b :SIZE,         line_item[:size]
            xml.b :SKU,          line_item[:sku]
          end
        end
      end
    end

    def shipping_cost(order)
      order[:shipping_cost] || 0
    end

    def shipping_discount(order)
      order[:shipping_discount] || 0
    end

    def shipping_fees(order)
      shipping_cost(order).abs - shipping_discount(order).abs
    end

  end
end
