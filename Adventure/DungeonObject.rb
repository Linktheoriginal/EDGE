class DungeonObject
	@@types = [
		"chest",
		"bench",
		"couch",
		"set of chains",
		"statue of a man wearing a horse head",
		"bed",
		"flag",
		"altar",
		"spaceship launch pad",
		"pillar",
		"cot",
		"piggy bank",
		"chalkboard",
		"child's cradle",
		"stockade",
		"hat rack",
		"desk",
		"chair",
		"serving bowl",
		"leg irons",
		"enchanted scroll",
		"dinner bell",
		"pot",
		"child's toy",
		"map",
		"weapon rack",
		"window",
		"loose floorplate",
		"epitaph",
		"Med-Pod",
		"Explosive Barrel",
		"Item Vending Machine",
		"Vending Machine of Ranged Weapons",
		"Melee Madness Vending Machine",
		"Armor Vending Machine"
	]
	@@actions = [
		["open", "use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"],
		["use", "examine"]
	]

	@@descriptors = [
		"dirty", 
		"slimy", 
		"long", 
		"dented", 
		"jewel encrusted",
		"moss covered",
		"taco sauce covered",
		"smelly",
		"broken",
		"stubby",
		"transparent",
		"strange",
		"rotten",
		"worn",
		"fresh",
		"janky",
		"overwrought",
		"poorly made",
		"wannabe",
		"magical",
		"nacho cheese covered",
		"badly repaired",
		"barely functional",
		"pristine",
		"acid washed",
		"spongelike",
		"moldy",
		"stacked",
		"crumbling",
		"solidly built",
		"chipotle flavored",
		"magically delicious",
		"hairy",
		"microscopic",
		"poorly lit",
		"intimidating",
		"delapidated",
		"red",
		"yellow",
		"green",
		"blue",
		"orange",
		"purple",
		"puce colored",
		"maroon",
		"aquamarine",
		"chartreuse",
		"stale"
	]
	@@materials = [
		"steel",
		"gold",
		"silver", 
		"stone", 
		"glass",
		"fabric",
		"copper",
		"wood",
		"cheese whiz",
		"dryer lint",
		"abandoned hopes and dreams",
		"the tears of orphans",
		"toenail clippings",
		"trashcan bin covers",
		"light, puffy, airy clouds",
		"leather",
		"horribly long beard hair",
		"bone",
		"dirt",
		"dead skin",
		"satin",
		"plastic"
	]
	def initialize(objIndex)

		if objIndex == -1
			@objectIndex = rand(@@types.length)
		else
			@objectIndex = objIndex
		end
		@typeName = @@types[@objectIndex]
		@materialrand = rand(@@materials.length)
		@actions = @@actions[@objectIndex]
		@descrand = rand(@@descriptors.length)
		@objectType = "object"
		@used = false
		@firstDesc = true
		@descriptor = ""
		@used = false
		@itemText = ""

		@epitaphmaxhealth = 0
		@epitaphdamage = 0
		@epitaphattack = 0
		@epitaphmoney = 0
		@epitaphdefense = 0
		@epitaphmonster = false
		@epitaphmotto = ""

		rand(3).times {
			descriptorRand = rand(@@descriptors.length)
			if @firstDesc
				@descriptor = @@descriptors[descriptorRand]
				@firstDesc = false
			else
				@descriptor << ", " + @@descriptors[descriptorRand]
			end
		}

		if @objectIndex == 28 
			engraveEpitaph()
		end
	end
	def describe
		if objectIndex == 12 and @itemText != ""
			if @descriptor.to_s != ""
				return @descriptor + " " + @@types[@objectIndex] + " made of " + @@materials[@materialrand] + " with the words " + @itemText + " written on it"
			else
				return @@types[@objectIndex] + " made of " + @@materials[@materialrand] + " with the words " + @itemText + " written on it"
			end
		elsif objectIndex == 28 #epitaph
			if @descriptor.to_s != ""
				return @descriptor + " " + @@types[@objectIndex] + " made of " + @@materials[@materialrand] + ". " + @itemText
			else
				return @@types[@objectIndex] + " made of " + @@materials[@materialrand] + ". " + @itemText
			end
		elsif @descriptor.to_s != ""
			return @descriptor + " " + @@types[@objectIndex] + " made of " + @@materials[@materialrand]
		else
			return @@types[@objectIndex] + " made of " + @@materials[@materialrand]
		end
	end
	def engraveEpitaph()
		begin
			@itemText = "The letters written in the gravestone are too worn to read. You probably don't know him anyways."
			graveFile = File.open(File.expand_path("..\\graveyard.txt", __FILE__))
			fileContents = []

			graveFile.each_line { |line|
				fileContents.push line
			}
			
			#it's possible for the last line (which is a blank line) to get selected. In this case it will use the default message
			if fileContents.length > 0
				epitaphData = fileContents[rand(fileContents.length)].split("~")

				if epitaphData.length >= 3
					@epitaphname = epitaphData[0].to_s
					epitaphMsg = (epitaphData[1].to_s + " ")
					epitaphDate = epitaphData[2].to_s
					@epitaphmonster = true
					@epitaphmaxhealth = epitaphData[3].to_i
					@epitaphdamage = epitaphData[4].to_i
					@epitaphdefense = epitaphData[5].to_i
					@epitaphmoney = epitaphData[6].to_i
					@epitaphattack = epitaphData[7].to_i
					@epitaphmotto = epitaphData[8].gsub("\n", "").to_s
				else
					epitaphname = "John Doe"
					epitaphMsg = "Did you break the text file?"
					epitaphDate = "03/06/1989"
					@epitaphmonster = false
				end

				@itemText = "On the epitaph you see the date " + epitaphDate + " followed by the name " + @epitaphname + "."
				@itemText += " Under the name there is a message: " + epitaphMsg
			
			else
				#maybe generate random names to put on the epitaph? 

			end

		rescue

		end
	end
	attr_accessor :typeName
	attr_accessor :itemText
	attr_accessor :effect
	attr_accessor :effectAmt
	attr_accessor :used
	attr_accessor :actions
	attr_accessor :objectType
	attr_accessor :objectIndex
	attr_accessor :used
	attr_accessor :epitaphmaxhealth
	attr_accessor :epitaphdamage
	attr_accessor :epitaphname
	attr_accessor :epitaphattack
	attr_accessor :epitaphmoney
	attr_accessor :epitaphdefense
	attr_accessor :epitaphmonster
	attr_accessor :epitaphmotto
end