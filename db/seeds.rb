# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#   Category(id: integer, name: string, created_at: datetime, updated_at: datetime)
require 'faker'

User.create([
  { name: "John Doe", email: "john@doe.com", password: "password" },
  { name: "Jake Doe", email: "jake@doe.com", password: "password" },
  { name: "Jane Doe", email: "jane@doe.com", password: "password" }
])

Category.create([
  { name: 'TV Comedies' },
  { name: 'TV Dramas' }
])

Relationship.create([
  { leader: User.first, follower: User.last },
  { leader: User.last, follower: User.first }
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

Video.all.each do |video|
  Review.create(
    user: User.first,
    video: video,
    description: Faker::Hacker.say_something_smart,
    rating: rand(1..5))
  unless video == Video.last || video == Video.offset(1).last
    Review.create(
      user: User.last,
      video: video,
      description: Faker::Hacker.say_something_smart,
      rating: rand(1..5))
  end
end

QueueItem.create(
  user: User.first,
  video: Video.last,
  position: 2)

QueueItem.create(
  user: User.first,
  video: Video.offset(1).last,
  position: 1)
QueueItem.create(
  user: User.first,
  video: Video.where("title LIKE ?", "%heory%").first,
  position: 4)
QueueItem.create(
  user: User.first,
  video: Video.where("title LIKE ?", "%alking%").first,
  position: 3)

QueueItem.create(
  user: User.last,
  video: Video.last,
  position: 4)

QueueItem.create(
  user: User.last,
  video: Video.offset(1).last,
  position: 1)
QueueItem.create(
  user: User.last,
  video: Video.all.sample,
  position: 2)
QueueItem.create(
  user: User.last,
  video: Video.all.sample,
  position: 3)
