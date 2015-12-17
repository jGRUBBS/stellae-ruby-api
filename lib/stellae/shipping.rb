module Stellae

  module Shipping

    SHIPPING_MAP = {
      "Standard"          => "90",
      "Next Business Day" => "05"
    }

    def shipping_service(shipping_method)
      SHIPPING_MAP[shipping_method] || shipping_method
    end

  end

end
