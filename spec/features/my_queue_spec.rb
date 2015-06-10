require "spec_helper"

feature 'My Queue'do
  given(:user) { Fabricate(:user) }
  given(:video) { Fabricate(:video, title: "Lord of the Rings") }
  given!(:video2) { Fabricate(:video, title: "Friends")}
  given!(:video3) { Fabricate(:video, title: "The Office")}
  given!(:video4) { Fabricate(:video, title: "Dharma and Greg")}

  background do
    visit login_path
    fill_in "Email Address", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"

    expect(page).to have_content user.name
  end

  scenario 'add videos to my queue' do
    visit video_path(video)
    expect(page).to have_content video.title

    click_link "+ My Queue"
    expect(page).to have_content "My Queue"
    expect(page).to have_content "List Order"
    expect(page).to have_content video.title

    click_link video.title
    expect(page).to have_link "Watch Now"
    expect(page).to have_content video.title
    expect(page).to have_no_link "+ My Queue"

    visit videos_path
    expect(page).to have_content video.category.name

    click_link "video_#{video2.title.parameterize}"
    expect(page).to have_content video2.title

    click_link "+ My Queue"
    expect(page).to have_content "My Queue"
    expect(page).to have_content "List Order"
    expect(page).to have_content video2.title

    visit videos_path

    click_link "video_#{video3.title.parameterize}"
    expect(page).to have_content video3.title

    click_link "+ My Queue"
    expect(page).to have_content "My Queue"
    expect(page).to have_content "List Order"
    expect(page).to have_content video3.title

    within("form table tbody") do
      expect(page.all("input.form-control[name='queue_item[][position]']")[0].value).to eq "1"
      expect(page.all("#video_link")[0].text).to eq "Lord of the Rings"

      expect(page.all("input.form-control[name='queue_item[][position]']")[1].value).to eq "2"
      expect(page.all("#video_link")[1].text).to eq "Friends"

      expect(page.all("input.form-control[name='queue_item[][position]']")[2].value).to eq "3"
      expect(page.all("#video_link")[2].text).to eq "The Office"
    end

    within("form table tbody") do
      page.all("tr")[0].fill_in("queue_item__position", with:"3")
      page.all("tr")[1].fill_in("queue_item__position", with:"2")
      page.all("tr")[2].fill_in("queue_item__position", with:"1")
    end
    find("input.btn[name=commit]").click

    within("form table tbody") do
      expect(page.all("input.form-control[name='queue_item[][position]']")[0].value).to eq "1"
      expect(page.all("#video_link")[0].text).to eq "The Office"

      expect(page.all("input.form-control[name='queue_item[][position]']")[1].value).to eq "2"
      expect(page.all("#video_link")[1].text).to eq "Friends"

      expect(page.all("input.form-control[name='queue_item[][position]']")[2].value).to eq "3"
      expect(page.all("#video_link")[2].text).to eq "Lord of the Rings"
    end
  end

end