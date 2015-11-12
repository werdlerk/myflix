require "spec_helper"

feature 'User following' do
  given(:john) { Fabricate(:user, email: "john@example.com", password: "Password", name: "John Doe") }
  given(:bob) { Fabricate(:user, email: "bob@codefish.org", password: "Test123", name: "Bob Hope") }
  given!(:video1) { Fabricate(:video) }
  given!(:review1) { Fabricate(:review, video: video1, author: bob) }

  background { log_in_user john }

  scenario "user can follow and unfollow bob" do
    visit root_path
    click_on_video_on_home_page(video1)

    expect(page).to have_content video1.title
    expect(page).to have_content "Rating: #{review1.rating} / 5"
    expect(page).to have_content "by #{bob.name}"
    click_link bob.name

    expect(page).to have_content "#{bob.name}'s video collection"
    click_link "Follow"

    expect(page).to have_content "You've started following Bob Hope."
    expect(page).to have_content "People I Follow"
    expect(page).to have_link bob.name
    unfollow(bob)

    expect(page).to have_content "You've stopped following #{bob.name}."
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end


end