Fabricator(:video) do
  title { (Faker::Company.name).gsub(/[']/, '') }
  description { Faker::Lorem.sentence }
end
