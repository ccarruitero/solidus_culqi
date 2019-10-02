# frozen_string_literal: true

module Solidus
  class Gateway::CulqiGateway < SolidusCulqi::Gateway.parent_class
    extend SolidusCulqi::Gateway

    preference :public_key, :string
    preference :secret_key, :string

    partial_method 'culqi'
    provider_method self.class

    def default_currency
      "PEN"
    end

    def authorize(amount, creditcard, gateway_options)
      init_culqi
      commit(amount, creditcard, gateway_options, false)
    end

    def purchase(amount, creditcard, gateway_options)
      init_culqi
      commit(amount, creditcard, gateway_options, true)
    end

    def capture(_amount, response_code, _gateway_options)
      init_culqi
      charge = Culqi::Charge.capture(response_code)
      parse_response(charge)
    end

    def credit(amount, _creditcard, response_code, _gateway_options)
      init_culqi
      # Culqi only accepts 'duplicado','fraudulento' o 'solicitud_comprador'
      # like reason's value
      refund = Culqi::Refund.create(
        amount: amount,
        charge_id: response_code,
        reason: "solicitud_comprador"
      )
      parse_response(refund)
    end

    def void(response_code, creditcard, gateway_options)
      amount = gateway_options[:subtotal].to_i
      credit(amount, creditcard, response_code, gateway_options)
    end

    def payment_profiles_supported?
      true
    end

    def create_profile(payment)
      return unless payment.source.gateway_customer_profile_id.nil?

      init_culqi
      customer = get_customer(payment)
      token = payment.source.gateway_payment_profile_id
      card_token = generate_card(customer, token)
      unless customer.nil? || card_token.nil?
        payment.source.update(
          gateway_customer_profile_id: customer,
          gateway_payment_profile_id: card_token
        )
      end
    end

    private

    def init_culqi
      Culqi.public_key = preferred_public_key
      Culqi.secret_key = preferred_secret_key
    end

    def commit(amount, creditcard, gateway_options, capture)
      installments = gateway_options.try(:installments)
      authorization = creditcard[:gateway_payment_profile_id]
      charge = Culqi::Charge.create(
        amount: amount,
        capture: capture,
        currency_code: default_currency,
        description: gateway_options[:description],
        email: gateway_options[:email],
        installments: installments || 0,
        source_id: authorization
      )
      parse_response(charge)
    end

    def parse_response(response)
      res = JSON.parse(response)
      ActiveMerchant::Billing::Response.new(
        res["object"] != "error",
        res["merchant_message"],
        res,
        authorization: res["id"]
      )
    end

    def find_customer(email)
      res = Culqi::Customer.list
      customers = JSON.parse(res)["data"]
      customers.select { |customer| customer["email"] == email }.first
    end

    def get_customer(payment)
      address = payment.order.bill_address
      email = payment.order.email
      customer = find_customer(email)
      customer = generate_customer(address, email) if customer.nil?
      customer["id"]
    end

    def generate_customer(address, email)
      culqi_customer = Culqi::Customer.create(
        address: address.address1,
        address_city: address.state.name,
        country_code: address.country.iso,
        email: email,
        first_name: address.first_name,
        last_name: address.last_name,
        phone_number: address.phone.tr("/() -/", "")
      )
      JSON.parse(culqi_customer)
    end

    def generate_card(customer, token)
      card = Culqi::Card.create(
        customer_id: customer,
        token_id: token,
        validate: false
      )
      JSON.parse(card)["id"]
    end
  end
end
