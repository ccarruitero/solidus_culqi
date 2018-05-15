# frozen_string_literal: true

Spree::Payment.include SolidusCulqi::InjectInstallmentsConcern
