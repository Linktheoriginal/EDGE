require_relative "Weapon"
require_relative "Armor"

class Inventory
	def initialize
		@weapon = nil
		@armor = nil
		@hat = nil
		@items = Array.new
	end
	def describe
		if !@weapon.nil?
			weaponString = weapon.describe
		else
			weaponString = "nothing"
		end

		if !@armor.nil?
			armorString = armor.describe
		else
			armorString = "nothing"
		end

		if !@hat.nil?
			hatString = hat.describe
		else
			hatString = "nothing"
		end

		returnString =  "You rifle around in your pack and find:\n\n" + \
						"Your backup weapon -- (a) " + weaponString + "\n" + \
						"Your backup armor --- (b) " + armorString + "\n" + \
						"Your backup hat ----- (c) " + hatString + "\n" + \
						"In your item pouch, you have:\n"
		i = 0
		for item in @items
			returnString += "	(" + i.to_s + ") " + item.describe + "\n"
			i += 1
		end

		returnString += "\nUse 'R' or 'Return' to return to the game.\n\n"

		return returnString
	end
	attr_accessor :weapon
	attr_accessor :armor
	attr_accessor :hat
	attr_accessor :items
end