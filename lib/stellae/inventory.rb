module Stellae
  class Inventory < Request

    def build_inventory_request
      construct_xml "get_inventory_on_hand" do |xml|
        xml.upcs :"xmlns:b" => SCHEMA[:datacontract], :"xmlns:i" => SCHEMA[:instance]
      end
    end

  end
end