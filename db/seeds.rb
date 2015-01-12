# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Player.create!(name: "all3nvan", summonerId: 23472148)
#Player.create!(name: "edzwoo", summonerId: 38049106)

$champion_map.each do |id, name|
	Champion.create!(champ_id: id, name: name)
end