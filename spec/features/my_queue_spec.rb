require "spec_helper"

feature 'My Queue' do
  given!(:category) { Fabricate(:category, name: "My Category") }
  given!(:video) { Fabricate(:video, title: "Lord of the Rings", category: category) }
  given!(:video2) { Fabricate(:video, title: "Friends", category: category)}
  given!(:video3) { Fabricate(:video, title: "The Office", category: category)}
  given!(:video4) { Fabricate(:video, title: "Dharma and Greg", category: category)}

  background { log_in_user }

  scenario 'add and reorder videos in my queue' do
    add_video_to_queue(video)
    expect_video_in_queue(video)

    click_link video.title
    expect_no_link "+ My Queue"

    add_video_to_queue(video2)
    expect_video_in_queue(video2)

    add_video_to_queue(video3)
    expect_video_in_queue(video3)

    expect_video_position(video, 1)
    expect_video_position(video2, 2)
    expect_video_position(video3, 3)

    set_video_position(video, 3)
    set_video_position(video2, 2)
    set_video_position(video3, 1)
    find("input.btn[name=commit]").click

    expect_video_position(video, 3)
    expect_video_position(video2, 2)
    expect_video_position(video3, 1)
  end

  def expect_video_in_queue(video)
    expect(page).to have_content video.title
  end

  def expect_no_link(link_text)
    expect(page).to have_no_link link_text
  end

  def add_video_to_queue(video)
    visit videos_path
    find("a[href='#{video_path(video)}']").click
    expect(page).to have_content video.title
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in 'queue_item[][position]', with:position.to_s
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='number']").value).to eq position.to_s
  end

end