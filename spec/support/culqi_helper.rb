# frozen_string_literal: true

require "spec_helper"

module CulqiHelper
  def setup_culqi_gateway
    Solidus::Gateway::CulqiGateway.create!(
      name: "Culqi",
      preferred_secret_key: "sk_test_96a3cgezoRsHb3SR",
      preferred_public_key: "pk_test_Fi1VHNShLrzIKmRi"
    )
  end

  def checkout_until_payment(product, user = nil)
    visit spree.product_path(product)
    click_button "Add To Cart"

    expect(page).to have_current_path("/cart")
    click_button "Checkout"

    # Address
    if user
      expect(page).to have_current_path("/checkout/address")
    else
      within("#guest_checkout") do
        find('#order_email')
        fill_in "Email", with: "han@example.com"
        click_button "Continue"
      end
      expect(page).to have_current_path("/checkout")
    end

    country = Spree::Country.first
    within("#billing") do
      fill_in "First Name", with: "Han"
      fill_in "Last Name", with: "Solo"
      fill_in "Street Address", with: "YT-1300"
      fill_in "City", with: "Mos Eisley"
      select "United States of America", from: "Country"
      select country.states.first, from: "order_bill_address_attributes_state_id"
      fill_in "Zip", with: "12010"
      fill_in "Phone", with: "(555) 555-5555"
    end
    click_on "Save and Continue"

    # Delivery
    expect(page).to have_current_path("/checkout/delivery")
    # expect(page).to have_content("UPS Ground")
    click_on "Save and Continue"

    expect(page).to have_current_path("/checkout/payment")
  end

  def fill_card(number, year = Time.now.year + 1)
    page.execute_script("$('#card_number').val('#{number}')")
    page.execute_script("$('#card_number').trigger('change')")
    fill_in "Card Code", with: "123"
    page.execute_script("$('#card_expiry').val('09 / #{year}')")
    page.execute_script("$('#card_expiry').trigger('change')")
    click_button "Save and Continue"
    sleep(5) # Wait for API to return + form to submit
    click_button "Save and Continue"
  end
end
