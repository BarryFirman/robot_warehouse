# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Robot.destroy_all
Position.destroy_all
Crate.destroy_all

p = Position.new current_position: '10,10'
Robot.create! position: p

position_one = Position.new current_position: '5,5'
position_two = Position.new current_position: '1,1'
Crate.create position: position_one
Crate.create position: position_two


