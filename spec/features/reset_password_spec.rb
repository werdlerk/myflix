require "spec_helper"

feature 'Reset password' do
  given(:user) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }

  scenario 'unable to reset password with a bad email address' do
    visit login_path
    click_link "Forgot password?"

    fill_in "Email Address", with: 'bob@example.com'
    click_button "Send Email"

    expect(page).to have_content "The given e-mail address can't be found."
  end

  scenario 'successfully reset password using the link in the email' do
    visit login_path
    click_link "Forgot password?"

    fill_in "Email Address", with: user.email
    click_button "Send Email"
    expect(page).to have_content "We have send an email with instructions to reset your password."

    open_email user.email
    expect(current_email).to have_content "Please click on the link below to set a new password."

    current_email.click_link 'Reset password'
    expect(page).to have_content "Reset Your Password"

    fill_in "New Password", with: 'New Password123'
    click_button "Reset Password"

    expect(page).to have_content "Your password has been changed."
    expect(page).to have_content "Sign in"

    fill_in "Email Address", with: user.email
    fill_in "Password", with: "New Password123"
    click_button "Sign in"

    expect(page).to have_content "Welcome back, #{user.name}"
  end

end
