require 'spec_helper'

feature 'User registers an account', vcr: true, js: true do
  given(:user_details) { Fabricate.attributes_for(:user) }
  given(:credit_card_details) { { number: "4242424242424242", cvc: "123", expiration_month: "3 - March", expiration_year: 1.year.from_now.year }}

  background do
    visit root_path
    click_link "Sign Up Now!"
  end

  scenario 'Succesfully' do
    fill_in_user_details(user_details)
    fill_in_credit_card_details(credit_card_details)
    click_button "Sign Up"

    expect(page).to have_content "Welcome, #{user_details[:name]}! Your account has been created, please login below."
  end

  scenario 'Invalid user data with valid credit card details' do
    user_details[:password] = nil

    fill_in_user_details(user_details)
    fill_in_credit_card_details(credit_card_details)
    click_button "Sign Up"

    expect(page).to have_content "can't be blank"
  end

  scenario 'Valid user data with missing credit card details' do
    credit_card_details[:cvc] = nil

    fill_in_user_details(user_details)
    fill_in_credit_card_details(credit_card_details)
    click_button "Sign Up"

    expect(page).to have_content "Your card's security code is invalid."
  end

  scenario 'Valid user data with invalid credit card details' do
    credit_card_details[:number] = "4000000000000002"

    fill_in_user_details(user_details)
    fill_in_credit_card_details(credit_card_details)
    click_button "Sign Up"

    expect(page).to have_content "Your card was declined."
  end


  def fill_in_user_details(user_details = {})
    fill_in "Email Address", with: user_details[:email]
    fill_in "Password", with: user_details[:password]
    fill_in "Full Name", with: user_details[:name]
  end

  def fill_in_credit_card_details(credit_card_details = {})
    fill_in "Credit Card Number", with: credit_card_details[:number]
    fill_in "Security Code", with: credit_card_details[:cvc]
    select credit_card_details[:expiration_month], from: "date_month"
    select credit_card_details[:expiration_year], from: "date_year"
  end
end
