class Armor
	@@names = [
		"speedo",
		"board shorts",
		"parachute pants",
		"white t-shirt",
		"collared shirt",
		"utili-kilt",
		"leather jacket",
		"skinny jeans",
		"wizard robe",
		"leather armor",
		"letterman jacket",
		"metal plates and super glue",
		"plated mail",
		"chainmail bikini",
		"Jason's black hoodie",
		"space pants",
		"platinum plating",
		"diamond armor",
		"dragon mail",
		"dragon plate"
	]
	@@descriptors = [
		"Raggedy",
		"Dilapidated",
		"Torn",
		"Tight",
		"Worn",
		"Average",
		"Very Nice",
		"Layered",
		"Reinforced",
		"Golden",
		"Platinum",
		"Mighty",
		"Epic",
		"Legendary"
	]
	@@suffixes = [
		"Death",
		"Flames",
		"Poison",
		"Vileness",
		"Tightness",
		"Jankyness",
		"Awesome",
		"Wonders",
		"Chocolate Syrup",
		"Caesar Dressing",
		"Unobtainium",
		"Ermergerd"
	]
	def initialize(armorType, typeLowerRange, typeUpperRange, qualityLowerRange, qualityUpperRange)

		if armorType == -1
			@objectType = "armor"
			@type = "Buck Naked"
			@defense = 0
			@fullName = "Buck Naked"
		else
			if typeLowerRange > @@names.length || typeLowerRange < 0
				typeLowerRange = 0
			end

			if typeUpperRange > @@names.length || typeUpperRange <= 0
				typeUpperRange = @@names.length - 1
			end

			if qualityUpperRange > @@descriptors.length || qualityUpperRange <= 0
				qualityUpperRange = @@descriptors.length
			end

			if qualityLowerRange > @@descriptors.length || qualityLowerRange < 0
				qualityLowerRange = 0
			end

			@modiferAmt = rand(0..4)

			@objectType = "armor"
			@nameInt = rand(@@names.length)
			@nameDefense = (@nameInt * 1.2).to_i
			@type = @@names.at(@nameInt)
			@descInt = rand(@@descriptors.length)
			@defense = (@nameDefense + (@descInt * 0.3)).to_i + @modiferAmt
			@descriptor = @@descriptors.at(@descInt)

			if @modiferAmt != 0
				@fullName = "+" + @modiferAmt.to_s + " " + @descriptor + " " + @type + " of " + @@suffixes.at(rand(@@suffixes.length))
			else
				@fullName = @descriptor + " " + @type + " of " + @@suffixes.at(rand(@@suffixes.length))
			end
		end
	end
	def describe
		return @fullName
	end
	
	attr_accessor :objectType
	attr_accessor :type
	attr_accessor :defense
	attr_accessor :descriptor
	attr_accessor :fullName
end