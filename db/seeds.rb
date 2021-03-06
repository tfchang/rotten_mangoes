# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# clear the users table
User.destroy_all
Movie.destroy_all

FactoryGirl.define do
  factory :admin, class: User do
    firstname   "Admin"
    lastname    "Account"
    email       "admin@gmail.com"
    password    "admin1"
    admin       true
  end

  factory :test_user, class: User do
    firstname   "Test"
    lastname    "User"
    email       "test@gmail.com"
    password    "testing1"
    admin       false
  end

  factory :user, class: User do
    firstname   { Faker::Name.first_name }
    lastname    { Faker::Name.last_name }
    email       { Faker::Internet.email }
    password    { Faker::Internet.password(8) }
    admin       false
  end

  # factory :movie, class: Movie do
  #   title               { Faker::Commerce.product_name }
  #   director            { Faker::Name.name }
  #   runtime_in_minutes  { 70 + rand(80) }
  #   description         { Faker::Lorem.sentence }
  #   release_date        { Faker::Date.between(2.days.from_now, 30.days.from_now) }
  # end
end

FactoryGirl.create(:admin)
FactoryGirl.create(:test_user)
40.times { FactoryGirl.create(:user) }

# 40.times { FactoryGirl.create(:movie) }

