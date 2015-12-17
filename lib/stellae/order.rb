module Stellae
  class Order < Request

    include State
    include Shipping

    def build_order_request(order)

      construct_xml "new_order_entry" do |xml|

        xml.ohn :"xmlns:a" => SCHEMA[:datacontract], :"xmlns:i" => SCHEMA[:instance] do

          soap_field       xml, :CARRIER,          order[:shipping_carrier].upcase
          soap_field       xml, :CURRENCY,         order[:currency].upcase
          build_address    xml, "CUSTOMER",        order[:billing_address]
          soap_field       xml, :CUSTOMER_CODE
          build_name       xml, "CUSTOMER",        order[:billing_address]
          soap_field       xml, :CUSTOMER_PO
          build_telephone  xml, "CUSTOMER",        order[:billing_address]
          build_address    xml, "DELIVERY",        order[:shipping_address]
          soap_field       xml, :DELIVERY_DC_EDI
          soap_field       xml, :DELIVERY_DOOR_EDI
          soap_field       xml, :DELIVERY_FROM
          soap_field       xml, :DELIVERY_ID
          soap_field       xml, :DELIVERY_MESSAGE, order[:gift_message]
          build_name       xml, "DELIVERY",        order[:shipping_address]
          build_telephone  xml, "DELIVERY",        order[:shipping_address]
          soap_field       xml, :DELIVERY_TO
          soap_field       xml, :DISCOUNT,         order[:item_discount] || 0
          soap_field       xml, :EMAIL,            order[:email]
          soap_field       xml, :FREIGHT_ACCOUNT
          soap_field       xml, :MISC1,            0
          soap_field       xml, :MISC1_REASON
          soap_field       xml, :MISC2,            0
          soap_field       xml, :MISC2_REASON
          soap_field       xml, :ORDER_ID,         order[:number]
          soap_field       xml, :ORDER_TYPE,       order[:type] || 'OO'
          build_line_items xml,                    order
          soap_field       xml, :SERVICE,          shipping_service(order[:shipping_method])
          soap_field       xml, :SHIPPING_FEES,    shipping_fees(order)
          soap_field       xml, :TAXES,            order[:tax] || 0
          soap_field       xml, :TOTAL_AMOUNT,     order[:total_amount] || 0
          soap_field       xml, :USER1,            order[:invoice_url]
          soap_field       xml, :USER2
          soap_field       xml, :USER3
          soap_field       xml, :USER4
          soap_field       xml, :USER5
          soap_field       xml, :WAREHOUSE

        end

      end

    end

    private

    def build_name(xml, type, address)
      full_name = "#{address[:first_name]} #{address[:last_name]}"
      soap_field xml, :"#{type}_NAME", full_name
    end

    def build_telephone(xml, type, address)
      soap_field xml, :"#{type}_TELEPHONE", address[:phone]
    end

    def build_address(xml, type, address)
      soap_field xml, :"#{type}_ADDRESS_1",       address[:address1]
      soap_field xml, :"#{type}_ADDRESS_2",       address[:address2]
      soap_field xml, :"#{type}_ADDRESS_3",       address[:address3]
      soap_field xml, :"#{type}_ADDRESS_CITY",    address[:city]
      soap_field xml, :"#{type}_ADDRESS_COUNTRY", address[:country]
      soap_field xml, :"#{type}_ADDRESS_STATE",   state_abbr(address[:state])
      soap_field xml, :"#{type}_ADDRESS_ZIP",     address[:zipcode]
    end

    def build_line_items(xml, order)
      soap_field xml, :Order_Details do |xml|
        order[:line_items].each do |line_item|
          soap_field xml, :Order_Detail_New do |xml|
            soap_field xml, :COST
            soap_field xml, :FLAGS
            soap_field xml, :LINE_ID
            soap_field xml, :LOT_NUMBER
            soap_field xml, :PRICE,        line_item[:price]
            soap_field xml, :QUANTITY,     line_item[:quantity]
            soap_field xml, :RETAIL_PRICE
            soap_field xml, :SEASON
            soap_field xml, :SIZE,         line_item[:size]
            soap_field xml, :SKU,          line_item[:sku]
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
