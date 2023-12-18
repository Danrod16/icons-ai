# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "destroying users"
User.destroy_all
puts "destroying requests"
Request.destroy_all
puts "destroying styles"
Style.destroy_all
puts "destroying transactions"
Transaction.destroy_all
puts "destroying wallets"
Wallet.destroy_all


puts "creating seeds"

User.create(email: "user1@gmail.com", password: "123123")
Style.create(name: "Metallic 3D")
Style.create(name: "Paul Klee")
Style.create(name: "Flat")




puts "#{Style.count} styles created"
