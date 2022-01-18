# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# coding: utf-8

User.create!(name: "管理者",
             email: "admin@email.com",
             affiliation: "総務部",
             employee_number: 0,
             uid: "0",
             basic_work_time: Time.current.change(hour: 8, min: 0, sec: 0),
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 18, min: 0, sec: 0),
             password: "password",
             password_confirmation: "password",
             admin: true)

User.create!(name: "上長A",
             email: "superior-1@email.com",
             affiliation: "経営企画部",
             employee_number: 1,
             uid: "A001",
             basic_work_time: Time.current.change(hour: 8, min: 0, sec: 0),
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 18, min: 0, sec: 0),
             password: "password",
             password_confirmation: "password",
             superior: true)

User.create!(name: "上長B",
             email: "superior-2@email.com",
             affiliation: "マーケティング部",
             employee_number: 2,
             uid: "B002",
             basic_work_time: Time.current.change(hour: 8, min: 0, sec: 0),
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 18, min: 0, sec: 0),
             password: "password",
             password_confirmation: "password",
             superior: true)

6.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               employee_number: n+3,
               basic_work_time: Time.current.change(hour: 8, min: 0, sec: 0),
               designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
               designated_work_end_time: Time.current.change(hour: 18, min: 0, sec: 0),
               password: password,
               password_confirmation: password)
end