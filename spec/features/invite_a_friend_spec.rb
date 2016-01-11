require "spec_helper"

feature 'Invite a friend' do
  given(:user) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }
  given(:friend) { { name: "Bob Hope", email: "Bob@example.org", message: "This is awesome!", password: "My_Awesome_Password_9876" } }

  background do
    clear_emails
  end

  scenario 'invite a friend to signup for MyFlix' do
    log_in_user(user)

    # Send invitation e-mail to friend
    click_link 'Invite a friend'
    expect(page).to have_content 'Invite a friend to join MyFlix!'

    fill_in 'Friend\'s Name', with: friend[:name]
    fill_in 'Friend\'s Email Address', with: friend[:email]
    fill_in 'Invitation Message', with: friend[:message]
    click_button 'Send Invitation'

    click_link 'Sign Out'

    # Friend opens the e-mail
    open_email friend[:email]
    expect(current_email).to have_content "Invitation to MyFliX!"
    expect(current_email).to have_content friend[:message]
    current_email.click_link 'Sign up'

    # Friend signs up using link in e-mail
    expect(page).to have_content "Register"
    expect(page).to have_field 'Email Address', with: friend[:email]
    expect(page).to have_field 'Full Name', with: friend[:name]
    fill_in 'Password', with: friend[:password]
    click_button 'Sign Up'

    # Successfully signed up
    expect(page).to have_content "Welcome, #{friend[:name]}! Your account has been created, please login below."

    # Friend logs in
    fill_in 'Email Address', with: friend[:email]
    fill_in 'Password', with: friend[:password]
    click_button 'Sign in'
    expect(page).to have_content "Welcome back, #{friend[:name]}"

    # Friend follows user
    click_link "People"
    expect(page).to have_content "People I Follow"
    expect(page).to have_link user.name

    click_link "Sign Out"

    # User follows friend
    log_in_user(user)

    click_link "People"
    expect(page).to have_content "People I Follow"
    expect(page).to have_link friend[:name]
  end

end
