# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Culqi checkout autocapture", :vcr, type: :feature, js: true do
  let(:zone) { create(:zone) }
  let(:country) { create(:country) }
  let(:product) { create(:product) }

  before do
    zone.members << Spree::ZoneMember.create!(zoneable: country)
    create(:store)
    create(:free_shipping_method)
    Spree::Config.set(auto_capture: true)
    setup_culqi_gateway
    checkout_until_payment(product)
  end

  context "with valid credit card" do
    stub_authorization!

    before do
      fill_in "Card Number", with: "4111 1111 1111 1111"
      page.execute_script("$('.cardNumber').trigger('change')")
      fill_in "Card Code", with: "123"
      fill_in "Expiration", with: "09 / 20"
      click_button "Save and Continue"
      sleep(5) # Wait for API to return + form to submit
      click_button "Save and Continue"
    end

    it "can process a valid payment" do
      expect(page.current_url).to include("/checkout/confirm")
      click_button "Place Order"
      expect(page).to have_content("Your order has been processed successfully")
    end

    it "refunds a payment" do
      reason = FactoryBot.create(:refund_reason)

      click_button "Place Order"
      visit spree.admin_order_payments_path(Spree::Order.last)
      sleep(3)
      click_icon(:reply)
      fill_in "Amount", with: Spree::Order.last.amount.to_f
      select reason.name, from: "Reason", visible: false
      click_on "Refund"
      expect(Spree::Refund.count).to be(1)
    end
  end

  context "when missing credit card number" do
    it "shows an error" do
      fill_in "Expiration", with: "01 / #{Time.now.year + 1}"
      fill_in "Card Code", with: "123"
      click_button "Save and Continue"
      expect(page).to have_content("El numero de tarjeta de crédito o débito brindado no es válido.")
    end
  end

  context "when missing expiration date" do
    it "shows an error" do
      fill_in "Card Number", with: "4242 4242 4242 4242"
      fill_in "Card Code", with: "123"
      click_button "Save and Continue"
      expect(page).to have_content("de expiración de tu tarjeta es inválido.")
    end
  end

  context "with an invalid credit card number" do
    it "shows an error" do
      fill_in "Card Number", with: "1111 1111 1111", visible: false
      fill_in "Expiration", with: "02 / #{Time.now.year + 1}"
      fill_in "Card Code", with: "123"
      click_button "Save and Continue"
      expect(page).to have_content("El numero de tarjeta de crédito o débito brindado no es válido.")
    end
  end
end
