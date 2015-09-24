class Hat
	@@names = [
		"grocery bag",
		"paper bag",
		"headband",
		"shower cap",
		"doo-rag",
		"bandana",
		"poker visor",
		"bowler",
		"tin foil",
		"fedora",
		"scuba mask",
		"beanie",
		"beret",
		"bonnet",
		"wig",
		"wizard's hat",
		"toupee",
		"gas mask",
		"fez",
		"stovepipe hat",
		"top hat",
		"turban",
		"umbrella hat",
		"tiara",
		"crown"
	]
	@@descriptors = [
		"Torn",
		"Crushed",
		"Crumpled",
		"Flat",
		"Greasy",
		"Pointy",
		"Slick",
		"Shiny",
		"Towering",
		"Hair gel covered",
		"Spiky",
		"Ostentatious",
		"Genuine",
		"Vintage",
		"Strange",
		"Silly",
		"Taco sauce covered",
		"Totally-not-a-headcrab"
	]
	@@suffixes = [
		"felt",
		"meaning business",
		"geekiness",
		"double-crossing",
		"speeding",
		"console adventure game-playing",
		"sneakiness",
		"silliness",
		"ostentatiousness",
		"shininess",
		"dat ass",
		"stank",
		"hat-based economies",
		"very slightly higher jumping",
		"dungeon-crawling",
		"mimicry",
		"mime-tossing",
		"bravery",
		"tree-hugging",
		"frog-kissing",
		"stuttering",
		"double-jumping",
		"monster-slaying",
		"thorns",
		"mad-hatter's disease",
		"healthiness"
	]
	def initialize(hatType, typeLowerRange, typeUpperRange, qualityLowerRange, qualityUpperRange)
		if hatType == -1
			@objectType = "hat"
			@type = "Bald Head"
			@defense = 0
			@damage = 0
			@effectAmt = 0
			@fullName = "Bald Head"
			@effect = ""
			@descriptor = ""
		else
			@damage = 0
			@objectType = "hat"
			@nameInt = rand(@@names.length)
			@nameDamage = @nameInt * 0.3
			@type = @@names.at(@nameInt)
			@descInt = rand(@@descriptors.length)
			@defense = (@nameDamage + (@descInt * 0.1)).to_i
			@descriptor = @@descriptors.at(@descInt)
			@suffixrand = rand(@@suffixes.length)
			@fullName = @descriptor + " " + @type + " of " + @@suffixes.at(@suffixrand)

			if @@suffixes.at(@suffixrand) == "drunkenness"
				@effect = "drunk"
			elsif @@suffixes.at(@suffixrand) == "poison"
				@effect = "poison"
			elsif @@suffixes.at(@suffixrand) == "healthiness"
				@effect = "maxhealth"
			else
				@effect = "defense"
			end

			if @@suffixes.at(@suffixrand) == "healthiness"
				@effectAmt = @defense
			else
				@effectAmt = 0
			end
		end
	end
	def describe
		return @fullName
	end
	attr_accessor :effect
	attr_accessor :effectAmt
	attr_accessor :objectType
	attr_accessor :type
	attr_accessor :defense
	attr_accessor :damage
	attr_accessor :descriptor
	attr_accessor :fullName
end