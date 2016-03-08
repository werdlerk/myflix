require "spec_helper"

feature "Admin adds a video" do
  given(:admin) { Fabricate(:admin) }
  given!(:category) { Fabricate(:category) }

  given(:new_video) {
    {
      title: "Big Buck Bunny",
      description: "A large and lovable rabbit deals with three tiny bullies, led by a flying squirrel, who are determined to squelch his happiness.",
      large_cover: File.join(Rails.root, 'spec', 'assets', 'bigbuckbunny_large_cover.jpg'),
      small_cover: File.join(Rails.root, 'spec', 'assets', 'bigbuckbunny_small_cover.jpg'),
      video_url: "https://www.youtube.com/embed/YE7VzlLtp-4?autoplay=1"
    }
  }

  background do
    log_in_user(admin)
  end

  scenario "admin adds an invalid video" do
    expect(page).to have_link "Add a New Video"
    click_link "Add a New Video"

    fill_in "Title", with: new_video[:title]
    select category.name, from: "Category"
    attach_file "Large cover", new_video[:large_cover]
    attach_file "Small cover", new_video[:small_cover]
    fill_in "Video URL", with: new_video[:video_url]
    click_button "Add Video"

    expect(page).to have_content "The video could not be saved due to the following errors:"
    expect(page).to have_content "Description can't be blank"
  end

  scenario "admin adds a video" do
    expect(page).to have_link "Add a New Video"
    click_link "Add a New Video"

    fill_in "Title", with: new_video[:title]
    select category.name, from: "Category"
    fill_in "Description", with: new_video[:description]
    attach_file "Large cover", new_video[:large_cover]
    attach_file "Small cover", new_video[:small_cover]
    fill_in "Video URL", with: new_video[:video_url]
    click_button "Add Video"

    expect(page).to have_content "You have successfully added the video #{new_video[:title]}."

    log_out

    log_in_user

    click_link "Videos"

    expect(page).to have_content category.name
    find("section.content .video_category .video a").click

    expect(page).to have_content new_video[:title]
    expect(page).to have_selector(".video_large_cover img[src='/uploads/bigbuckbunny_large_cover.jpg']")
    expect(page).to have_link("Watch Now", href: new_video[:video_url])
  end

end
