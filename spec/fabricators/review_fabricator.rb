Fabricator(:review) do
  description { Faker::Lorem.sentence }
  rating { rand(1..5) }
end
