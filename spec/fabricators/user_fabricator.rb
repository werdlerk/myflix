Fabricator(:user) do
  name Faker::Name.name
  password Faker::Internet.password
  email { Faker::Internet.email }
end
