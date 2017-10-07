require 'solidus_culqi/support'

module SolidusCulqi
  module Gateway
    def self.parent_class
      if SolidusCulqi::Support.solidus_earlier('2.3.x')
        Spree::Gateway
      else
        Spree::PaymentMethod::CreditCard
      end
    end

    def partial_method(partial_name)
      if SolidusCulqi::Support.solidus_earlier('2.3.x')
        define_method('method_type') { partial_name }
      else
        define_method('partial_name') { partial_name }
      end
    end
  end
end
