require "spec_helper"

feature 'People page' do
  given(:john) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }
  given(:bob) { Fabricate(:user, email: "bob@codefish.org", password: "Test123", name: "Bob Hope") }
  given!(:video1) { Fabricate(:video) }
  given!(:review1) { Fabricate(:review, video: video1, author: bob) }

  background { log_in_user john }

  scenario "start following bob, visit people page and unfollow bob" do
    visit root_path
    within(:css, "article.video_category .video") do
      find(:css, "a").click
    end

    expect(page).to have_content video1.title
    expect(page).to have_content "Rating: #{review1.rating} / 5"
    expect(page).to have_content "by #{bob.name}"
    click_link "Bob Hope"

    expect(page).to have_content "#{bob.name}'s video collection"
    click_link "Follow"

    expect(page).to have_content "You've started following Bob Hope."
    expect(page).to have_content "People I Follow"
    expect(page).to have_link "Bob Hope"

    within(:css, "table.table > tbody > tr td:last-child") do
      find(:css, "a").click
    end

    expect(page).to have_content "You've stopped following #{bob.name}."
  end

  scenario 'stop following bob' do
    Fabricate(:relationship, leader: bob, follower: john)

    visit people_path

    expect(page).to have_content "People I Follow"
    expect(page).to have_link "Bob Hope"

    within(:css, "table.table tr td:last-child") do
      find(:css, "a").click
    end

    expect(page).to have_content "You've stopped following Bob Hope."
  end


end