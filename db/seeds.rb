# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(name:"Harendra Student", contact: "1234567890", email: "harendra_student", password_digest: "password", type: "Student")
User.create(name:"Harendra Instructor", contact: "2345678901", email: "harendra_instructor", password_digest: "password", type: "Instructor")
User.create(name:"Harendra Admin", contact: "3456789012", email: "harendra_admin", password_digest: "password", type: "Admin")
