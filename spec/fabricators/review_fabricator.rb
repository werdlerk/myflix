Fabricator(:review) do
  rating 3
  text Faker::Lorem.paragraph
  author { Fabricate(:user) }
end