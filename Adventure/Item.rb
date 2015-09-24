require_relative 'Player'

class Item

	@@types = [
		"Buffalo Wild Wings Gift Card",
		"Potion of Might",
		"Potion of Healing",
		"Potion of Defense",
		"Potion of Cure Disease",
		"Bottle of Tabasco Sauce",
		"Case of Beer",
		"Appletini",
		"Tabasco Smothered Taco",
		"Fanny pack full of spaghetti",
		"Pack of Twizzlers",
		"Jar of Pickles",
		"Wallet",
		"Pile of Gold",
		"Bandages",
		"Potion of Vigor",
		"Potion of Stamina",
		"Steroids",
		"Quest"
	]

	@@descriptors = [
		"moldy",
		"rancid",
		"gross",
		"stinky",
		"foul",
		"lumpy",
		"perfect",
		"mint",
		"golden",
		"smelly",
		"crusty",
		"legendary"
	]

	@@consumeDescriptors = [
		"gulp down",
		"consume",
		"swallow",
		"devour",
		"gobble up"
	]

	def initialize
		@type = @@types.at(rand(@@types.length - 1))
		@descriptor = @@descriptors.at(rand(@@descriptors.length))
		@fullName = @descriptor + " " + @type
		@objectType = "item"
		case @type
		when "Potion of Might"
			@effect = "damage"
			@effectAmt = rand(1..3)
		when "Potion of Healing", "Pack of Twizzlers"
			@effect = "health"
			@effectAmt = rand(5..25) + 1
		when "Potion of Defense", "Bottle of Tabasco Sauce"
			@effect = "defense"
			@effectAmt = 2
		when "Tabasco Smothered Taco", "Jar of Pickles"
			@effect = "health"
			@effectAmt = 10
		when "Fanny pack full of spaghetti"
			@effect = "health"
			@effectAmt = rand(6) + 2
		when "Case of Beer", "Appletini"
			@effect = "drunk"
			@effectAmt = rand(3) + 1
		when "Wallet"
			@effect = "money"
			@effectAmt = rand(10) + 5
		when "Buffalo Wild Wings Gift Card"
			@effect = "money"
			@effectAmt = rand(20) + 5
		when "Potion of Cure Disease"
			@effect = "cure"
			@effectAmt = 1
		when "Pile of Gold"
			@effectAmt = rand(10..25)
			@effect = "money"
		when "Quest"
			@effect = "win"
			@effectAmt = 1
		when "Bandages"
			@effect = "bleeding"
			@effectAmt = -1
		when "Potion of Vigor", "Potion of Stamina"
			@effect = "maxhealth"
			@effectAmt = rand(1..3)
		when "Steroids"
			@effect = "maxhealth"
			@effectAmt = rand(3..5)		
		else
			@effect = "nothing"
			@effectAmt = 0
		end
	end
	def describe
		return @fullName
	end
	attr_accessor :objectType
	attr_accessor :type
	attr_accessor :descriptor
	attr_accessor :fullName
	attr_accessor :effect
	attr_accessor :effectAmt
end