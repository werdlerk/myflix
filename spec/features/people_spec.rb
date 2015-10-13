require "spec_helper"

feature 'People page' do
  given(:john) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }
  given(:bob) { Fabricate(:user, email: "bob@codefish.org", password: "Test123", name: "Bob Hope") }
  given!(:video1) { Fabricate(:video) }
  given!(:video2) { Fabricate(:video) }
  given!(:video3) { Fabricate(:video) }
  given!(:review1) { Fabricate(:review, video: video1, author: bob) }

  background { log_in_user john }

  scenario "start following bob" do
    visit video_path(video1)
    expect(page).to have_content "Bob Hope"

    click_link "Bob Hope"
    expect(page).to have_link "Follow"
    click_link "Follow"

    expect(page).to have_content "You've started following Bob Hope."
    expect(page).to have_content "People I Follow"

    expect(page).to have_link "Bob Hope"
  end

  scenario 'stop following bob' do
    Fabricate(:followship, user: john, follower: bob)

    visit people_path

    expect(page).to have_content "People I Follow"
    expect(page).to have_link "Bob Hope"

    within(:css, "table.table tr td:last-child") {
      find(:css, "a").click
    }

    expect(page).to have_content "You've stopped following Bob Hope."
  end


end