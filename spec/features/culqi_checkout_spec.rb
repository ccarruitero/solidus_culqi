# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Culqi checkout", :vcr, type: :feature, js: true do
  let(:zone) { create(:zone) }
  let(:country) { create(:country) }
  let(:product) { create(:product) }

  before do
    zone.members << Spree::ZoneMember.create!(zoneable: country)
    create(:store)
    create(:free_shipping_method)
    setup_culqi_gateway
  end

  context 'with unlogged user' do
    stub_authorization!

    before do
      checkout_until_payment(product)

      fill_in "Card Number", with: "4111 1111 1111 1111", visible: false
      page.execute_script("$('.cardNumber').trigger('change')")
      fill_in "Card Code", with: "123"
      fill_in "Expiration", with: "09 / 20"
      click_button "Save and Continue"
      sleep(5) # Wait for API to return + form to submit
      find(".culqiInstallments").select("2")
      click_button "Save and Continue"
    end

    context "with process checkout" do
      before do
        expect(page.current_url).to include("/checkout/confirm")
        click_button "Place Order"
      end

      it "process order" do
        expect(page).to have_content("Your order has been processed successfully")
        payment = Spree::Order.last.payments.last
        expect(payment.source.gateway_customer_profile_id).not_to be_nil
      end

      it "capture payment" do
        visit spree.admin_order_payments_path(Spree::Order.last)
        sleep(3)
        click_icon(:capture)
        expect(page).to have_content("Payment Updated")
      end

      it "voids a payment" do
        visit spree.admin_order_payments_path(Spree::Order.last)
        sleep(3)
        click_icon(:void)
        expect(page).to have_content("Payment Updated")
      end
    end
  end

  context 'with logged user' do
    let(:user) { create(:user) }

    before do
      visit spree.login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end

    it 'store card in wallet' do
      checkout_until_payment(product, user)

      fill_in "Card Number", with: "4111 1111 1111 1111", visible: false
      page.execute_script("$('.cardNumber').trigger('change')")
      fill_in "Card Code", with: "123"
      fill_in "Expiration", with: "09 / 20"
      click_button "Save and Continue"
      sleep(5)
      find(".culqiInstallments").select("2")
      click_button "Save and Continue"
      click_button "Place Order"
      expect(page).to have_content("Your order has been processed successfully")

      checkout_until_payment(product, user)
      if SolidusCulqi::Support.solidus_earlier('2.2.x')
        source = user.payment_sources.first
      else
        source = user.wallet.wallet_payment_sources.first.payment_source
      end

      expect(page).to have_content(source.name)
      expect(page).to have_content(source.display_number)
    end
  end
end
