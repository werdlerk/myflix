require "spec_helper"

feature 'User signs in' do
  given(:user) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }

  scenario 'with valid email and password' do
    log_in_user(user)

    expect(page).to have_content "John Doe"
  end

  scenario 'with invalid e-mail' do
    visit login_path
    fill_in "Email Address", with: "test@example.com"
    fill_in "Password", with: "Password"
    click_button "Sign in"

    expect(page).not_to have_content "John Doe"
  end

  scenario 'with invalid password' do
    visit login_path
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "pass"
    click_button "Sign in"

    expect(page).not_to have_content "John Doe"
  end
end