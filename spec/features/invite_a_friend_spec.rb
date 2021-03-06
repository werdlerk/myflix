require "spec_helper"

feature "Invite a friend", :vcr, js: true do
  given(:user) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }
  given(:friend) { { name: "Bob Hope", email: "Bob@example.org", message: "This is awesome!", password: "My_Awesome_Password_9876" } }

  scenario "invite a friend to signup for MyFlix" do
    log_in_user(user)

    user_sends_invitation

    friend_opens_email
    friend_signs_up
    friend_logs_in
    expect_to_follow(friend[:name])

    log_out

    log_in_user(user)
    expect_to_follow(user.name)
  end

  def user_sends_invitation
    click_link "Welcome, #{user.name}"
    click_link "Invite friend"
    expect(page).to have_content "Invite a friend to join MyFlix!"

    fill_in "Friend's Name", with: friend[:name]
    fill_in "Friend's Email Address", with: friend[:email]
    fill_in "Invitation Message", with: friend[:message]
    click_button "Send Invitation"

    log_out
  end

  def friend_opens_email
    open_email friend[:email]
    expect(current_email).to have_content "Invitation to MyFliX!"
    expect(current_email).to have_content friend[:message]
    current_email.click_link "Sign up"
  end

  def friend_signs_up
    expect(page).to have_content "Register"
    expect(page).to have_field "Email Address", with: friend[:email]
    expect(page).to have_field "Full Name", with: friend[:name]

    fill_in "Password", with: friend[:password]
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "3 - March", from: "date_month"
    select 1.year.from_now.year, from: "date_year"
    click_button "Sign Up"

    expect(page).to have_content "Welcome, #{friend[:name]}! Your account has been created, please login below."
  end

  def friend_logs_in
    fill_in "Email Address", with: friend[:email]
    fill_in "Password", with: friend[:password]
    click_button "Sign in"
    expect(page).to have_content "Welcome back, #{friend[:name]}"
  end

  def expect_to_follow(user_name)
    click_link "People"
    expect(page).to have_content "People I Follow"
    expect(page).to have_link user_name
  end

end
