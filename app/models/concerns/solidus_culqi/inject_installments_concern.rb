module SolidusCulqi
  module InjectInstallmentsConcern
    extend ActiveSupport::Concern
    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def gateway_options
        options = super
        installments = order.installments
        options[:installments] = installments if installments
        options
      end
    end
  end
end
