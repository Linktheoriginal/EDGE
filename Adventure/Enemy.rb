require_relative 'Color'

class Enemy
	@@types = [
		#type, health, damage, defense, attack
		["Elf", 1, 1, 4, 70],
		["Pony", 20, 1, 2, 10],
		["Goat", 22, 2, 2, 50],
		["Slime", 30, 3, 3, 50],
		["Mime", 50, 1, 3, 70],
		["Neckbeard", 45, 1, 10, 10],
		["Goblin", 100, 5, 12, 45],
		["Hobbit", 90, 2, 10, 60],
		["Imp", 110, 3, 6, 41],
		["Animated Garden Gnome", 90, 2, 10, 60],
		["Zombie", 96, 2, 5, 45],
		["Bandit", 120, 3, 20, 50],
		["Kobold", 70, 3, 3, 42],
		["Thief", 60, 3, 3, 65],
		["Hobo", 45, 3, 3, 40],
		["Marauder", 85, 1, 12, 70],
		["Wizard", 20, 8, 1, 60],
		["Sorcerer", 60, 3, 3, 20],
		["Troll", 210, 3, 3, 60],
		["Ogre", 200, 3, 3, 52],
		["Drake", 300, 2, 11, 40],
		["Mutant", 100, 5, 15, 40],
		["Alien", 170, 4, 20, 42],
		["Dungeon Keeper", 1000, 25, 25, 66]
	]
	@@descriptors = [
		"Dirty", 
		"Slimey", 
		"Elongated", 
		"Short", 
		"Rotten",
		"Stanky",
		"Crudy",
		"Cross-eyed",
		"Janky",
		"Lanky",
		"Fat",
		"Skinny",
		"Pasty",
		"Pale",
		"Noisey",
		"Limping",
		"Slow",
		"Chubby",
		"Moldy",
		"Smoldering",
		"Glowing",
		"Sarcastic",
		"Obnoxious",
		"Drooling",
		"Brain dead",
		"Emaciated",
		"Rotting",
		"Belching",
		"Sleepy"
	]
	@@names = [
		"John Mark",
		"Tristan",
		"Nathan",
		"Jon",
		"Joe",
		"Eric",
		"Jason",
		"Slandy",
		"Ed",
		"Louis",
		"Dan",
		"Brian",
		"Kristin",
		"Linda",
		"Gary",
		"Chris",
		"David"
	]
	@@weapons = [
		"Mace",
		"Broken piece of glass",
		"Sharpened toothbrush",
		"Sword",
		"Chainsaw",
		"Pen",
		"Broken Space Jam soundtrack disc",
		"Severed human leg",
		"Scissors",
		"Fork",
		"Spoon",
		"Butcher's knife",
		"Rocket Launcher",
		"Lawnchair",
		"Unidentifiable Long Pointy Thing",
		"Bottomless Bag of Grenades"
	]
	@@modLevels = [
		["ANGRY", 1.1],
		["SUPER", 1.2],
		["SUPER ANGRY", 1.3],
		["DANGEROUS", 1.4],
		["HYPER DANGEROUS", 1.5],
		["BAD-ASS", 1.6],
		["SUPER BAD-ASS", 1.7],
		["GODLIKE", 1.8],
		["GODLIKE WITH AN ATTITUDE", 1.9],
		["GODLIKE WITH A BAD ATTITUDE", 2.0]
	]
	@@modifiers = [
		"Undead",
		"Poisonous",
		"Flaming",
		"Radioactive"
	]
	@@evilAction = [
		"smash",
		"destroy",
		"devour",
		"cut",
		"eat",
		"punch",
		"erase",
		"poke",
		"mutilate",
		"molest",
		"steal",
		"chew up",
		"suck on",
		"break",
		"kick",
		"bite",
		"gnaw",
		"yank out"
	]
	@@objectsOfAttack = [
		"eyes",
		"arms",
		"toes",
		"wrist",
		"fingers",
		"soul",
		"intestines",
		"face",
		"nose",
		"guts",
		"feet",
		"ears",
		"body",
		"ankles",
		"neck",
		"earlobes",
		"pinky finger",
		"finger nails"
	]
	@@bloodTypes = [
		"Green Blood",
		"Purple Blood",
		"Orange Blood",
		"Blue Blood",
		"Red Blood",
		"Acid Blood",
		"Black Blood"
	]
	@@diseaseTypes = [
		"Insomnia", 		#Cant use beds/cots anymore
		"Pillarphobia",		#Cant use pillars anymore
		"Butterfingers",		#Cant equip items anymore
		"Theophobia",		#Cant use alters anymore
		"Cot Fever",			#Cant use cots specifically
		"Automatonophobia",	#Cant touch statues anymore
		"Tied Shoelaces",	#Chance to trip and fall in combat
		"Narcolepsy"		#Chance to fall asleep in combat
	]
	@@colors = [
		"blue",
		"baby blue",
		"green",
		"forest green",
		"red",
		"blood red",
		"orange",
		"purple",
		"black",
		"white",
		"yellow",
		"bright yellow"
	]
	@@activities = [
		"reading books",
		"playing text adventure games",
		"picking nose",
		"fishing",
		"playing D&D",
		"eating brains",
		"hot coffee",
		"smoking",
		"watching tv",
		"hacking the internet",
		"killing adventurers",
		"sleeping",
		"drink beer",
		"carving animals out of wood",
		"texting its friends"
	]
	@@generateDungeonKeeper = true
	def initialize

		if @@generateDungeonKeeper
		@typeInt = rand(@@types.length)
			@@generateDungeonKeeper = false
		else
			@typeInt = rand(@@types.length - 1)
		end

		
		@type = @@types.at(@typeInt)[0]
		@health = @@types.at(@typeInt)[1]
		@damage =  @@types.at(@typeInt)[2]
		@defense = @@types.at(@typeInt)[3]
		@attack = @@types.at(@typeInt)[4]
		@maxhealth = @health
		@name = @@names.at(rand(@@names.length))
		@descriptor = @@descriptors.at(rand(@@descriptors.length))
		@partialName = @name + " the " + @descriptor + " " + @type
		@weaponName = @@weapons.at(rand(@@weapons.length))
		@evilPhrase = "I'm going to " + @@evilAction[rand(@@evilAction.length)] + " your " + @@objectsOfAttack[rand(@@objectsOfAttack.length)] + "!!"
		@bloodType = @@bloodTypes[rand(@@bloodTypes.length)]
		@regen = false
		@blind = false
		@vomitFlag = false
		@bleedAmt = 0
		@poisonAmt = 0
		@paralyzed = false
		@muted = false
		@stunned = false
		@legsCrippled = false
		@armsCrippled = false
		@suffocationCount = -1
		@money = rand(1..12) * @typeInt
		@stance = "standing"
		@favoriteColor = @@colors[rand(@@colors.length)]
		@favoriteActivity = @@activities[rand(@@activities.length)]
		@causeOfDeath = ""
		@statusEffects = ""

		initializeBodyParts()

		if rand(10) < 3 
			@diseaseType = @@diseaseTypes[rand(@@diseaseTypes.length)]
			@contagionLevel = rand(1..4)
		else
			@diseaseType = ""
			@contagionLevel = 0
		end

		if rand(10) < 1 then
			modLevelInt = rand(@@modLevels.length)
			@level = @@modLevels[modLevelInt][0] + " "
			@health = (@health * @@modLevels[modLevelInt][1]).to_i
			@maxhealth = @health
			@damage = (@damage * @@modLevels[modLevelInt][1]).to_i
			@money = (@money * @@modLevels[modLevelInt][1]).to_i
		else
			@level = ""
		end

		if @diseaseType != ""
			diseaseString = "diseased "
		else
			diseaseString = ""
		end

		@fullName = @name + " the " + diseaseString + @level + " " +  @descriptor + " " + @type

		update()

	end
	def describe
		if @health <= 0
			return "a dead " + @type + " is lying on the floor, covered in " + @bloodType + ". "
		else

			if @diseaseType != ""
				diseaseString = "diseased "
			else
				diseaseString = ""
			end

			#return "a " + @descriptor + " " + @type + " named " + @name + ".[HP:" + @health.to_s + "|DFN:" + @defense.to_s + "|DMG:" + @damage.to_s + "] It's wielding a " + @weaponName 
			return "a " + diseaseString + @level + @descriptor + " " + @type + " named " + @name + ". It's wielding a " + @weaponName + ". It is screaming '" + @evilPhrase + "'"
		end
	end
	def convertTo(enemyToCreate)
		@typeInt = enemyToCreate
		@type = @@types.at(@typeInt)[0]
		@health = @@types.at(@typeInt)[1]
		@damage =  @@types.at(@typeInt)[2]
		@defense = @@types.at(@typeInt)[3]
		@attack = @@types.at(@typeInt)[4]
		@maxhealth = @health
		@name = @@names.at(rand(@@names.length))
		@descriptor = @@descriptors.at(rand(@@descriptors.length))
		@partialName = @name + " the " + @descriptor + " " + @type

	end
	def getWeaponName 

		return _weapons.at(rand(_weapons.length))
	end
	def initializeBodyParts()
		@bodyParts = {
			:head => [
					#Part  Integrity  status  side affect  material type  bonus damage
					["left eye", 3, "healthy", :sight, :tissue, 2], 
					["right eye", 3, "healthy", :sight, :tissue, 2], 
					["nose",3, "healthy", :nothing, :bone, 0], 
					["mouth", 3, "healthy", :speech, :tissue, 0], 
					["left ear", 3, "healthy", :nothing, :tissue, 0], 
					["right ear", 3, "healthy", :nothing, :tissue, 0], 
					["jaw", 3, "healthy", :nothing, :bone, 1], 
					["brain", 3, "healthy", :vital, :tissue, 50], 
					["left cheek muscle", 3, "healthy", :nothing, :tissue, 0],
					["right cheek muscle", 3, "healthy", :nothing, :tissue, 0],
					["front teeth", 3, "healthy", :nothing, :bone, 0],
					["skull", 3, "healthy", :nothing, :bone, 0],
					["left molar", 3, "healthy", :nothing, :bone, 0],
					["right molar", 3, "healthy", :nothing, :bone, 0]],
			:neck => [
					["jugular", 3, "healthy", :bleeding, :tissue, 5], 
					["throat muscle", 3, "healthy", :bleeding, :tissue, 1], 
					["vocal cord", 3, "healthy", :speech, :tissue, 0], 
					["neck spine", 3, "healthy", :paralysis, :bone, 3]],
			:torso => [
					["ribs", 3, "healthy", :nothing, :bone], 
					["trachea", 3, "healthy", :suffocation, :bone], 
					["left lung", 3, "healthy", :suffocation, :tissue], 
					["right lung", 3, "healthy", :suffocation, :tissue], 
					["stomach", 3, "healthy", :vomitting, :tissue], 
					["sternum", 3, "healthy", :suffocation, :bone],
					["kidney", 3, "healthy", :bleeding, :tissue], 
					["spine", 3, "healthy", :paralysis, :bone], 
					["torso muscle", 3, "healthy", :nothing, :tissue],
					["torso flesh", 3, "healthy", :nothing, :tissue],  
					["intestines", 3, "healthy", :vomitting, :tissue], 
					["heart", 3, "healthy", :vital, :tissue], 
					["liver", 3, "healthy", :bleeding, :tissue]],
			:leftarm => [
					["left lower arm bone", 3, "healthy", :attack, :bone], 
					["left upper arm bone", 3, "healthy", :attack, :bone], 
					["left lower arm flesh", 3, "healthy", :nothing, :tissue], 
					["left upper arm flesh", 3, "healthy", :nothing, :tissue], 
					["left wrist", 3, "healthy", :attack, :bone], 
					["left thumb", 3, "healthy", :nothing, :bone], 
					["left middle finger", 3, "healthy", :nothing, :bone],
					["left pinky", 3, "healthy", :nothing, :bone]],
			:rightarm => [
					["right lower arm bone", 3, "healthy", :attack, :bone], 
					["right upper arm bone", 3, "healthy", :attack, :bone], 
					["right lower arm flesh", 3, "healthy", :nothing, :tissue], 
					["right upper arm flesh", 3, "healthy", :nothing, :tissue],
					["right wrist", 3, "healthy", :attack, :bone], 
					["right thumb", 3, "healthy", :nothing, :bone], 
					["right middle finger", 3, "healthy", :nothing, :bone],
					["right pinky", 3, "healthy", :nothing, :bone]],
			:rightleg => [
					["upper right leg muscle", 3, "healthy", :nothing, :tissue], 
					["upper right leg flesh", 3, "healthy", :nothing, :tissue], 
					["lower right leg muscle", 3, "healthy", :nothing, :tissue], 
					["lower right leg flesh", 3, "healthy", :nothing, :tissue], 
					["right pinky toe", 3, "healthy", :nothing, :bone], 
					["right big toe", 3, "healthy", :nothing, :bone],
					["right foot", 3, "healthy", :stance, :bone], 
					["right knee", 3, "healthy", :stance, :bone], 
					["right ankle", 3, "healthy", :stance, :bone], 
					["right upper leg bone", 3, "healthy", :stance, :bone], 
					["right lower leg bone", 3, "healthy", :stance, :bone]],
			:leftleg => [
					["upper left leg muscle", 3, "healthy", :nothing, :tissue], 
					["upper left leg flesh", 3, "healthy", :nothing, :tissue], 
					["lower left leg muscle", 3, "healthy", :nothing, :tissue],
					["lower left leg flesh", 3, "healthy", :nothing, :tissue],
					["left pinky toe", 3, "healthy", :nothing, :bone],
					["left big toe", 3, "healthy", :nothing, :bone], 
					["left foot", 3, "healthy", :stance, :bone], 
					["left ankle", 3, "healthy", :stance, :bone], 
					["left knee", 3, "healthy", :stance, :bone], 
					["left upper leg bone", 3, "healthy", :stance, :bone], 
					["left lower leg bone", 3, "healthy", :stance, :bone]]
		}
	end
	def detailStatus()
		description = ""
		damageDescription = ""


		description = "This creature is a " + @level + @descriptor + " " + @type + " named " + @name + ". It's wielding a " + @weaponName + ". " 

		if @diseaseType != ""

			if @contagionLevel == 1 
				contagiousString = " lightly contagious. "
			elsif @contagionLevel == 2
				contagiousString = " moderately contagious. "
			else
				contagiousString = " highly contagious! "
			end

			description = description + "It's diseased with " + @diseaseType + "! " + "Its disease is" + contagiousString

		end

		description = description + "Its favorite color is " + @favoriteColor + ". It likes " + @favoriteActivity + ". "

		if vomitFlag 
			description = description + "It's covered in vomit. "
		end

		if bleedAmt > 0
			description = description + "It has wounds that are spraying " + @bloodType + ". "
		end

		if @health <= 0
			description = "This creature was a " + @level.blue.bold + @descriptor.white.bold + " " + @type.white.bold + " named " + @name.white.bold + ". " +
			              "It is deceased. "
		end

		#Get body part damage descriptions
		@bodyParts.each { |part, value|
			value.each { |attribute|
				if attribute[1] < 3
					description = description + "Its " + attribute[0].cyan.bold + " is " + attribute[2].red.bold + ". "
				end
			}
		}

		description = description + "\n\n"
		description = description + \
					  "\n=======Stats=======" + \
					  "\nHealth: -------- " + @health.to_s + \
					  "\nDamage: -------- " + @damage.to_s + \
					  "\nDefense: ------- " + @defense.to_s + \
					  "\nAttack: -------- " + @attack.to_s + "% chance to hit."

		return description
	end
	def update()
		@statusEffects = ""

		if @health <= 0
			@statusEffects = " !DEAD! ".red.bold
		end

		if @poisonAmt > 0
			@statusEffects += " !POISONED! ".green.bold
		end

		if @legsCrippled 
			@statusEffects += " !LEGS CRIPPLED! ".magenta.bold
		end

		if @armsCrippled
			@statusEffects += " !ARMS CRIPPLED! ".magenta.bold
		end

		if @diseaseType != ""
			@statusEffects += " !DISEASED! ".yellow.bold
		end

		if @bleedAmt > 0
			@statusEffects += " !BLEEDING! ".red.bold
		end

		if @blind 
			@statusEffects += " !BLIND! ".white.bold
		end

		if @stunned 
			@statusEffects += " !STUNNED! ".white.bold
		end

		if @muted
			@statusEffects += " !MUTED! ".white.bold
		end

		if @paralyzed 
			@statusEffects += " !PARALYZED! ".blue.bold
		end

		if @vomitFlag 
			@statusEffects += " !SICK! ".green.bold
		end

		if @suffocationCount > -1
			@statusEffects += " !SUFFOCATING! "
		end

	end
	attr_accessor :health
	attr_accessor :maxhealth
	attr_accessor :damage
	attr_accessor :level
	attr_accessor :attack
	attr_accessor :defense
	attr_accessor :regen
	attr_accessor :weaponName
	attr_accessor :type
	attr_accessor :name
	attr_accessor :partialName
	attr_accessor :drunk
	attr_accessor :descriptor
	attr_accessor :evilPhrase
	attr_accessor :bodyParts
	attr_accessor :vomitFlag
	attr_accessor :bleedAmt
	attr_accessor :diseaseType
	attr_accessor :contagionLevel
	attr_accessor :poisonAmt
	attr_accessor :blind
	attr_accessor :fullName
	attr_accessor :paralyzed
	attr_accessor :muted
	attr_accessor :stance
	attr_accessor :bloodType
	attr_accessor :stunned
	attr_accessor :legsCrippled
	attr_accessor :armsCrippled
	attr_accessor :money
	attr_accessor :causeOfDeath
	attr_accessor :statusEffects
	attr_accessor :suffocationCount
end