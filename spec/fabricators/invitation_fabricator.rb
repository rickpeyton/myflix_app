Fabricator(:invitation) do
  friend_name { Faker::Name.name }
  friend_email { Faker::Internet.email }
  message { Faker::Lorem.sentence }
  token { SecureRandom.urlsafe_base64 }
end
