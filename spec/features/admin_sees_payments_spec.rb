require 'spec_helper'

feature 'Admin sees payments' do
  given(:bob) { Fabricate(:user, name: "Bob Bla", email: "bob@example.com") }

  background do
    Fabricate(:payment, user: bob, amount_cents: 999)
  end

  scenario 'admin can see payments' do
    log_in_user(Fabricate(:admin))

    visit admin_payments_path

    expect(page).to have_content "$9.99"
    expect(page).to have_content "Bob Bla"
    expect(page).to have_content "bob@example.com"
  end

  scenario 'user cannot see payments' do
    log_in_user

    visit admin_payments_path

    expect(page).not_to have_content "$9.99"
    expect(page).not_to have_content "Bob Bla"
    expect(page).to have_content "You are not authorized to do that."
  end

end
