# frozen_string_literal: true

module SolidusCulqi
  module PermittedAttributesConcern
    def checkout_attributes
      super | [:installments]
    end
  end
end
