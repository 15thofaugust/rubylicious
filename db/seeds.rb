# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create! fullname:  "Admin",
  email: "admin@gmail.com",
  password: "admin123",
  password_confirmation: "admin123",
  username: "administrator",
  avatar: "avatar/default.png",
  permission: 1
User.create! fullname:  "Pham Hoang Anh", email: "hoanganh.pham.12327@gmail.com",
  password: "123456", password_confirmation: "123456", username: "hoanganh123",
  avatar: "avatar/default.png"
User.create! fullname:  "Nguyen Thu Duc Trung", email: "the15thofaug@gmail.com",
  password: "abc123", password_confirmation: "abc123", username: "15thofaugust",
  avatar: "avatar/default.png"
User.create! fullname:  "Nguyen Thuy Chi", email: "mitzu9xx@gmail.com",
  password: "abc123", password_confirmation: "abc123", username: "its.Cheese",
  avatar: "avatar/default.png"
20.times do
  name = Faker::Name.name
  email = Faker::Internet.email
  username = Faker::Internet.user_name(8)
  User.create! fullname:  name, email: email,
  password: "123456", password_confirmation: "123456",
  username: username,
  avatar: "avatar/default.png"
end
