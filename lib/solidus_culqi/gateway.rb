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
      common_method('method_type', 'partial_name', partial_name)
    end

    def provider_method(provider_class)
      common_method('provider_class', 'gateway_class', provider_class)
    end

    private

    def common_method(old_method, new_method, method_value)
      if SolidusCulqi::Support.solidus_earlier('2.3.x')
        define_method(old_method) { method_value }
      else
        define_method(new_method) { method_value }
      end
    end
  end
end
