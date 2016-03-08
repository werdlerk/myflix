include ActionDispatch::TestProcess

Fabricator(:video) do
  title Faker::Lorem.words(3).join(' ')
  description Faker::Lorem.paragraph
  category # { Fabricate(:category) }
  video_url "https://videourl.com"
end

Fabricator(:video_with_covers, from: :video) do
  small_cover { fixture_file_upload 'public/tmp/monk.jpg', 'image/jpg' }
  large_cover { fixture_file_upload 'public/tmp/monk_large.jpg', 'image/jpg' }
end
