# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#   Category(id: integer, name: string, created_at: datetime, updated_at: datetime)

User.create([
  { name: "John Doe", email: "john@doe.com", password: "password" },
  { name: "Jane Doe", email: "jane@doe.com", password: "password" }
])

Category.create([
  { name: 'TV Comedies' },
  { name: 'TV Dramas' }
])


#   Video(id: integer, title: string, description: text,
#         small_cover_url: string, large_cover_url: string,
#         created_at: datetime, updated_at: datetime)

counter = 1
days_counter = 10
9.times do
  Video.create(
    title: "The Big Bang Theory E0#{counter}",
    description: "A woman who moves into an apartment across the hall from two brilliant but socially awkward physicists shows them how little they know about life outside of the laboratory.",
    small_cover_url: 'bang_theory.jpg',
    large_cover_url: 'bang_theory_large.jpg',
    category: Category.first,
    created_at: days_counter.days.ago)
  days_counter -= 1
  counter += 1
end

counter = 1
days_counter = 70
9.times do
  Video.create(
    title: "The Walking Dead E0#{counter}",
    description: "Rick Grimes is a former Sheriff's deputy who has been in a coma for several months after being shot while on duty. When he wakes, he discovers that the world has been taken over by zombies, and that he seems to be the only person still alive.",
    small_cover_url: 'walking_dead.jpg',
    large_cover_url: 'walking_dead_large.jpg',
    category: Category.last,
    created_at: days_counter.days.ago)
  days_counter -= 7
  counter += 1
end

counter = 1
days_counter = 63
9.times do
  Video.create(
    title: "Forever E0#{counter}",
    description: "A 200-year-old man works in the New York City Morgue trying to find a key to unlock the curse of his immortality.",
    small_cover_url: 'forever.jpg',
    large_cover_url: 'forever_large.jpg',
    category: Category.last,
    created_at: days_counter.days.ago)
  days_counter -= 7
  counter += 1
end

Review.create(
  user: User.first,
  video: Video.last,
  description: "I love this show!!",
  rating: 5)

Review.create(
  user: User.last,
  video: Video.last,
  description: "I am not smart enough to watch this show!!",
  rating: 1)

Review.create(
  user: User.first,
  video: Video.last,
  description: "I changed my mind. I am much less of a fan now.",
  rating: 2)
