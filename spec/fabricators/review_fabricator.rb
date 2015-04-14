Fabricator(:review) do
  rating { rand(5) + 1 }
  text Faker::Lorem.paragraph
  author { Fabricate(:user) }
end