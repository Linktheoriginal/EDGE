require_relative 'Enemy'
require_relative 'DungeonObject'
require_relative 'Armor'
require_relative 'Weapon'
require_relative 'Item'
require_relative 'Hat'

class Room
	@@sizes = [ 
		"Tiny",
		"Small",
		"Normal sized",
		"Large",
		"Huge",
		"Gargantuan"
	]
	@@heights = 
	[
		"really short",
		"short",
		"of average height",
		"tall",
		"massively tall"
	]
	@@shapes = [
		"Octangular",
		"Triangular",
		"Square",
		"Rounded",
		"Odd Shaped"
	]
	@@smells = [
		"flesh",
		"tacos",
		"sausages",
		"peanuts",
		"bacon",
		"chocolate",
		"acorns",
		"nachos",
		"hot sauce",
		"cigarettes",
		"sadness",
		"failure",
		"hotdogs",
		"oil",
		"patchouli"
	]
	@@smellDescriptors = [
		"smoldering",
		"burning",
		"sweaty",
		"moldy",
		"soggy",
		"spoiled",
		"rotten",
		"charred",
		"marinated",
		"stale",
		"disgusting",
		"sun baked"
	]
	@@boundaryDescriptors = 
	[
		"smooth",
		"rough",
		"jaggedy",
		"bumpy",
		"dull",
		"cracked",
		"old",
		"blood covered",
		"ash covered",
		"cold",
		"moss covered",
		"crumbling",
		"glossy",
		"ribbed",
		"mushy",
		"fuzzy",
		"razor sharp"
	]
	@@materials = [
		"stone",
		"gold",
		"alienlike organic tissue",
		"organic tissue",
		"silver",
		"rock",
		"human flesh",
		"bone",
		"lead",
		"metal",
		"cement"
	]
	@@names = [
		"Museum",
		"Hall",
		"Room",
		"Crypt",
		"Pit",
		"Hole",
		"Dungeon",
		"Holding Cell",
		"Prison",
		"Catacomb",
		"Monument",
		"Amphitheater",
		"Stadium",
		"Temple",
		"Colosseum",
		"Library",
		"Auditorium",
		"Kitchen",
		"Nexus"
	]
	@@nameSuffixes = [
		"Sin",
		"Death",
		"Stars",
		"Statues",
		"Fire",
		"Doom",
		"Sausages",
		"Power",
		"Mutilation",
		"Blasphemy",
		"Radiation",
		"Constipation",
		"STDs",
		"Colon Cancer",
		"Vomit",
		"Spaghetti",
		"Toilet Bowls",
		"Weakness",
		"Severed Legs",
		"Hair Scrunchies",
		"Goat Hair",
		"Ear Wax",
		"Ruptured Bowels",
		"Herpes",
		"Mold",
		"Baby Tears",
		"Acid",
		"Broken Legs",
		"Text Adventuring",
		"Infinity",
		"Raw Meat",
		"Dinner Rolls",
		"Cardboard Boxes",
		"Virginity",
		"Nipple Clamps",
		"Torture",
		"Power",
		"Dim Lights"
	]
	@@namePrefixes = [
		"Forsaken",
		"Forgotten",
		"Lonely",
		"Burning",
		"Smoldering",
		"Crumbling",
		"Decrepit",
		"Moldy",
		"Hot",
		"Twisting",
		"Grand",
		"Great",
		"Lesser",
		"Holy",
		"Defiled",
		"Frozen",
		"Lost",
		"Unholy",
		"Infinite",
		"Poisoned",
		"Ransacked",
		"Nasty",
		"Rancid"
	]
	@@floorTextures = [
		"carpet",
		"tiles",
		"cement slabs",
		"wooden planks",
		"spikes",
		"glowing grass",
		"weeds",
		"dead grass",
		"dirt",
		"mud",
		"alien hive organic tissue",
		"leaves",
		"dead leaves"
	]
	@@lights = [
		"nothing",
		"flickering torches",
		"large disco ball",
		"rave strobe lights",
		"dangly fluorescent lights",
		"sunbeams coming through cracks in the ceiling",
		"a potato hooked to a lightbulb"
	]
	@@decorations =
	[
		"a large water fountain filled with a strange liquid",
		"are numerous bookcases",
		"are barrels full of unknown liquids",
		"is a broken sword with a rusty shield",
		"is a burning pile of books",
		"are crosses that are set ablaze",
		"is a pile of skull and bones",
		"is a rusted cage used to hold a prisoner",
		"is a rusted cage containing a dead skeleton wearing sunglasses",
		"is a campfire",
		"are dead trees",
		"is a glowing orb that gently bounces up and down",
		"are chained up skeletons",
		"is a broken down mech suit with the words Der Fuehrer engraved on it",
		"is a broken plasma rifle and pieces of a torn green space suit",
		"are rusted, crumbling coins",
		"is a pile of guts",
		"are leathery eggs with an open top. They are all empty...",
		"a set of broken zip ties and duct tape. That can't be good",
		"are burning, broken down cars",
		"are empty cardboard boxes",
		"are piles of trash",
		"is a smashed space helmet",
		"is a broken wrist watch",
		"is a broken chainsaw and a double barrel sawed-off",
		"is an ugly book with a face on the cover",
		"are rusted chains with severed arms stuck in the wrist locks",
		"are heads on pikes. Hey I think I know this guy",
		"are heads on pikes",
		"is a dead adventurer clenching a book entitled The Dungeon Navigator",
		"is a dead adventurer clenching an empty potion bottle",
		"is a pit full of blood",
		"is a pit full of blood and guts",
		"is an iron maiden",
		"is an iron maiden surrounded by a puddle of blood",
		"is a moss covered dead adventurer",
		"is a dead monk",
		"is a dead warrior",
		"is a dead man in a hazmat suit",
		"are a set of blood shoes",
		"is a powerless metal skeleton with red eyes",
		"is a dead aventurer",
		"is a dead space marine",
		"is a raggedy scarecrow",
		"is a knocked over trashcan",
		"is a blood soaked shirt",
		"is a chess set missing most of the pieces",
		"is a dead wizard",
		"is a dead wizard with a knife in his back",
		"is a decapitated warrior",
		"are broken beer bottles",
		"a snapped in half king's crown",
		"is a large pit of spikes",
		"is a large pit of spiders",
		"is large deep pit full of skeletons",
		"is a clump of tangled cables",
		"is a moustache",
		"is a group of large, ancient trees",
		"is a smashed bed",
		"is a goblin skeleton",
		"is a broken TV and VCR. Wow, how old is this place?",
		"is various pieces of garbage",
		"is glowing fungi",
		"is a ripped tent",
		"is a destroyed tent with an adventurers boots sticking out from under it",
		"are large mushrooms",
		"are large glowing mushrooms",
		"is a broken cryo chamber. Its occupant is missing",
		"is a powerless cryo chamber. It is full of dust and contains a skeleton",
		"are piles of dust",
		"is a rusted piece of chest armor",
		"is a busted knight helmet",
		"is a pair of smashed sunglasses and pieces of a metal endoskeleton",
		"is a table used for torture",
		"is a table with empty potion bottles",
		"is an empty gun cabinet",
		"is a smashed pub sign",
		"is a broken thermostat",
		"is a rusted fence",
		"is a dead man holding a uzi with a bandana over his face",
		"is a dead man holding a bag of white powdery stuff",
		"are smashed barrels",
		"is a pile snapped in half toothpicks",
		"are chained up dead adventurers"
	]
	@@locations = 
	[
		"In the center of the room", 
		"Against the back wall", 
		"Against the right wall",
		"Against the left wall",
		"In the corner of the room", 
		"In the left corner of the room",
		"in the right corner of the room",
		"On the left side of the room", 
		"On the Right side of the room", 
		"Hanging from the ceiling", 
		"Sticking out of the ground in center of the room", 
		"Sticking out of the ground on the left side of the room",
		"Sticking out of the ground on the right side of the room",
		"At your right diagonal",
		"At your left diagonal",
		"On the ground to your right",
		"On the ground to your left",
		"On the ground in front of you"
	]
	@@wallEngravings = 
	[
		"I took all of the treasure - BJ Blaz.", 
		"SAVE YOURSELF!", 
		"THE END IS HERE", 
		"There's no way out of here...", 
		"Meet me at the Pit of Doom and bring Christine", 
		"I'm lost", 
		":(){ :|:& };:", 
		"Wizard needs food badly",
		"Warrior needs food badly",
		"I killed John Mark because he shot the food",
		"|||| Has it really only been 4 days?",
		"I need a drink",
		"I lost my pocket change, maybe I should go back and check that couch...",
		"COT FEVER IS TAKING OVER. OH GOD IT BURNS!",
		"Oh god I hear the mutants coming for me! Please tell my wif",
		"BYOB",
		"I saw a ghost once",
		"Diversify your bonds",
		"I lost my meaty fists when I picked up this dagger...I miss those meaty fists",
		"The next room smells awful. Prepare yourself",
		"Prepare to Die",
		"You did it!",
		"Don't eat the spaghetti",
		"I came here to get away from the memes",
		"I came here for great treasures, I found misery",
		"Hold me",
		"I've killed at least 10 hobos by now"
	]
	@@reverseLookupHash = {
		0 => "a",
		1 => "b",
		2 => "c",
		3 => "d",
		4 => "e",
		5 => "f",
		6 => "g",
		7 => "h",
		8 => "i",
		9 => "j",
		10 => "k",
		11 => "l",
		12 => "m",
		13 => "n",
		14 => "o",
		15 => "p",
		16 => "q",
		17 => "r",
		18 => "s",
		19 => "t",
		20 => "u",
		21 => "v",
		22 => "w",
		23 => "x",
		24 => "y",
		25 => "z"
	}
	def initialize(roomdoors)
		@objects = Array.new
		@doors = roomdoors
		@enemies = Array.new

		@items = Array.new

		createItems
		createObjects
		createEnemies

		@size = @@sizes[rand(@@sizes.length)]
		@shape = @@shapes[rand(@@shapes.length)]
		@smell = @@smellDescriptors[rand(@@smellDescriptors.length)] + " " + @@smells[rand(@@smells.length)]
		@wallDescriptor = @@boundaryDescriptors[rand(@@boundaryDescriptors.length)]  
		@wallHeight = @@heights[rand(@@heights.length)]
		@wallMaterial = @@materials[rand(@@materials.length)]
		@floorMaterial = @@materials[rand(@@materials.length)]
		@floorDescriptor = @@boundaryDescriptors[rand(@@boundaryDescriptors.length)]  
		@floorTexture = @@floorTextures[rand(@@floorTextures.length)] 
		@lightSource = @@lights[rand(@@lights.length)]
		@name = generateRoomName()
		@generalDescription = generateRoomDescription()
	
	end
	def describe(alldoors, lastdoor)
		@description = ""

		@description << @generalDescription << "\n\nLined along the ".white.bold + @wallDescriptor.white.bold + " walls you see the following doors: \n".white.bold

		@doors.each_with_index { |door, i|
			@description << '(' + i.to_s + ') '
			if i == lastdoor
				@description << "The door behind you is "
			end
			@description << alldoors[door].describe
			@description << "\n"
		}
		if @enemies.length > 0
			@description << "\nLooking around, you see that there are ". red.bold
			@description << @enemies.length.to_s.white.bold
			@description << " creatures in the room.\n".red.bold
			@enemies.each_with_index { |enemy, i|
				@description << '(' + i.to_s + ') '
				@description << enemy.describe
				@description << "\n"
			}
		end
		if @objects.length > 0
			@description << "\nScattered around the room, there are ".green.bold + @objects.length.to_s.white.bold + " useful objects.\n".green.bold
			@objects.each_with_index { |object, i|
				@description << "(" + @@reverseLookupHash[i] + ") A "
				@description << object.describe
				@description << "\n"
			}
		end
		if @items.length > 0
			@description << "\nAround the room you see some items that could be useful:\n".yellow.bold
			@items.each_with_index { |item, i|
				@description << "(" + i.to_s + ") "
				@description << item.describe
				@description << "\n"
			}
		end

		return @description
	end
	def createObjects
		rand(5).times {
			@objects.push DungeonObject.new(-1)
		}
	end
	def createEnemies
		rand(3).times {
			@enemies.push Enemy.new
		}
	end
	def createItems
		rand(3).times {
			@items.push Item.new
		}
		(rand(10) - 7).times {
			@items.push Armor.new(0,0,0,0,0)
		}
		(rand(10) - 7).times {
			@items.push Weapon.new(0,0,5,0,0,0,1)
		}
		(rand(10) - 7).times {
			@items.push Hat.new(0, 0, 0, 0, 0)
		}
	end
	def generateRoomName()
		nameStr = @@namePrefixes[rand(@@namePrefixes.length)] + " " + @@names[rand(@@names.length)]

		if rand(100) > 20 then
			nameStr = nameStr + " of " + @@nameSuffixes[rand(@@nameSuffixes.length)]
		end

		return nameStr
	end
	def generateSpecialRoom()
		roomType = 1

		case roomType
		when 1 #graveyard
			generateGraveYard()
		end

	end
	def generateGraveYard()
		@generalDescription = ""
		@name = @@namePrefixes[rand(@@namePrefixes.length)].white.bold + " Graveyard ".yellow.bold + " of " + @@nameSuffixes[rand(@@nameSuffixes.length)].white.bold
		@generalDescription = "You are inside the " + @name.blue.bold + ". "

		blankRoomDescriptions()
		if rand(1..4) < 3
			fogTypes = [ "dense fog", "dark fog", "thick smog"]
			@generalDescription += "The room is full of " + fogTypes[rand(fogTypes.length)] + ". "
		end
		floorType = ["dirt", "mud", "dead grass"]
		miscObjs = ["dead trees", "a rusted fence", "a massive mausoleum", "a nonfunctioning water fountain", "pile of skulls & bones"]
		@generalDescription += "The air is cold and cools your lungs as you inhale. The floor consists of " + floorType[rand(floorType.length)] + ". " \
							   "In the center of the room you see " + miscObjs[rand(miscObjs.length)] + "." + \
							   " Throughout the room you see many gravestones."
		rand(1..3).times {
			indexCounter = 0
			@enemies.push Enemy.new
			@enemies[indexCounter].convertTo(9) #Create Zombies Specifically
			indexCounter += 1
		}

		rand(3..5).times {
			@objects.push DungeonObject.new(28)
		}

	end
	def generateRoomDescription
		sizeDescriptions = ["expansive", "massive", "enclosed", "extremely wide", "small", "tiny", ""]
		
		roomDescription = "You are in the " + @name.blue.bold + ". The room is " + @shape + " and " + @size + \
						  ". The walls are " + @wallHeight + ", " + @wallDescriptor + " and made of " + @wallMaterial + \
						  ". The floors consists of " + @floorTexture + ". "

		if rand(1..10) < 4
			liquids = ["blood", "salt water", "toilet water", "toilet water. At least you think so based on the smell of the room", "clear water", "murky water", "sludge", "swamp mud", "what looks like chocolate syrup but you don't want to taste it and find out.", "beer. Looks like those goblins were partying pretty hard.", "gasoline", "oil"]
			roomDescription += "The floor is submerged in " + liquids[rand(liquids.length)] + ". "
		end

		if rand(1..10) < 5
			temperatures = ["extremely hot", "freezing", "cool", "cold", "temperate", "room temperature", "hot", "boiling"]
			airTempPhrase = ["The room's air is ", "The room is "]
			roomDescription += airTempPhrase[rand(airTempPhrase.length)] + temperatures[rand(temperatures.length)] + ". "
		end

		if rand(1..10) < 5
			smellPhrases = ["The room smells of ", "The dungeon room has an uninviting smell of ", "Filling the air is the smell of "]
			roomDescription += "You inhale. " + smellPhrases[rand(smellPhrases.length)] +  @smell + ". "
		end
		if rand(1..4) < 3
			fogTypes = [ "dense fog", "dark fog", "thick smog", "smoke", "thick smoke", "low floating fog", "gun smoke", "visible purple miasma", "visible black miasma"]
			roomDescription += "The room is full of " + fogTypes[rand(fogTypes.length)] + ". "
		end

		if rand(1..4) < 2
			roomDescription += "On the wall you see an engraving: " + @@wallEngravings[rand(@@wallEngravings.length)] + ". "
		end

		rand(1..4).times {
			roomDescription += @@locations[rand(@@locations.length)] + " there " + @@decorations[rand(@@decorations.length)] + ". "
		}

		return roomDescription
	end
	def blankRoomDescriptions
		@size = ""
		@shape = ""
		@smell = ""
		@wallDescriptor = ""
		@wallHeight = ""
		@wallMaterial = ""
		@floorMaterial = ""
		@floorDescriptor = ""
		@floorTexture = "" 
		@lightSource = ""
	end
	attr_accessor :doors
	attr_accessor :enemies
	attr_accessor :items
	attr_accessor :objects
	attr_accessor :name
end