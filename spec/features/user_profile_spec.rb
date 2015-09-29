require "spec_helper"

feature 'User signs in' do
  given(:john) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }
  given(:bob) { Fabricate(:user, email: "bob@codefish.org", password: "Test123", name: "Bob Hope") }
  given!(:video1) { Fabricate(:video) }
  given!(:video2) { Fabricate(:video) }
  given!(:video3) { Fabricate(:video) }
  given!(:queue_item1) { Fabricate(:queue_item, user: bob, video: video1) }
  given!(:queue_item2) { Fabricate(:queue_item, user: bob, video: video2) }
  given!(:queue_item3) { Fabricate(:queue_item, user: bob, video: video3) }
  given!(:review1) { Fabricate(:review, video: video1, author: bob) }

  background { log_in_user }

  scenario "visit John's user profile page" do
    visit user_path(john)

    expect(page).to have_content "#{john.name}'s video collection (0)"
    expect(page).to have_content "#{john.name}'s reviews (0)"
  end

  scenario "visit Bob's user profile page" do
    visit user_path(bob)

    expect(page).to have_content "#{bob.name}'s video collection (3)"
    expect(page).to have_content video1.title
    expect(page).to have_content video2.title
    expect(page).to have_content video3.title

    expect(page).to have_content "#{bob.name}'s reviews (1)"
    expect(page).to have_content review1.text
    expect(page).to have_content "Rating: #{review1.rating} / 5"
  end

end