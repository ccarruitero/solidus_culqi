# frozen_string_literal: true

module PaymentDecorator
  Spree::Payment.include SolidusCulqi::InjectInstallmentsConcern
end
