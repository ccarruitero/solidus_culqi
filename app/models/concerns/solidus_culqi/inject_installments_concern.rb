# frozen_string_literal: true

module SolidusCulqi
  module InjectInstallmentsConcern
    extend ActiveSupport::Concern
    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def gateway_options
        options = super
        installments = order.try(:installments)
        options[:installments] = installments if installments
        options
      end
    end
  end
end
