require_relative 'Color'

class Weapon
	@@meleeWeapons = [
		#name, damage, accuracy
		["Lamp", 5, 70],
		["Lawnchair", 5, 80],
		["Plank", 6, 80],
		["Shiv", 6, 80],
		["Shank", 8, 80],
		["Dagger", 9, 85],
		["Sword", 13, 80],
		["Hammer", 7, 80],
		["Baseball Bat", 10, 80],
		["Woodaxe", 13, 80],
		["Battle axe", 11, 80],
		["Powerglove", 14, 75],
		["Chainsaw", 15, 65],
		["Banhammer", 16, 70]
	]
	@@rangedWeapons = [
		["Dart Gun", 5, 50],
		["Tec-9", 7, 50],
		["Uzi", 11, 42],
		["MAC-10", 10, 40],
		["Revolver", 9, 60],
		["Handgun", 8, 65],
		["Sniper Rifle", 20, 65],
		["MP5", 15, 42],
		["Magnum", 18, 50],
		["Shotgun", 16, 63],
		["AK-47", 17, 65],
		["M-16", 16, 55],
		["M4", 18, 62],
		["Spread Gun", 14, 54],
		["BFG9001", 28, 30]
	]
	@@ammoTypes = [
		["armor piercing rounds", 6],
		["lead rounds", 4],
		["plasma rounds", 8],
		["jagged glass rounds", 2],
		["spiked lead rounds", 6],
		["razor blade rounds", 3],
		["gold rounds", 3],
		["mini-nuclear missiles", 10],
		["slug rounds", 5],
		["toenails", 1],
		["magic missiles", 7],
		["globs of sharp objects", 4],
		["nails", 3],
		["pennies", 1]
	]
	@@descriptors = [
		"Rusty",
		"Dirty",
		"Flimsy",
		"Firm",
		"Lumpy",
		"Rancid",
		"Average",
		"Quality",
		"Power",
		"Legendary"
	]
	def initialize(weaponType, weaponTypeLowRange, weaponTypeHighRange, weaponQualityLowRange, weaponQualityHighRange, modifierLowRange, modifierHighRange)

		@objectType = "weapon"

		if weaponType == -1
			@nameInt = 0
			@nameDamage = 0
			@type = "Meaty Fist"
			@descInt = 0
			@damage = 8
			@descriptor = ""
			@attackPhrase = ["bash", "jam", "slap", "smash", "sock" ]
			@ammoType = ""
			@attackType = "melee"
			@fullName = "Meaty Fist"
			@totalDamage = 8
			initWeaponMods()
			@attack = 70
		else
			generateBaseStats(weaponTypeLowRange, weaponTypeHighRange, weaponQualityLowRange, weaponQualityHighRange, weaponType)
			generateModifiers(modifierLowRange, modifierHighRange)

			if @damageModifer > 0 
				@fullName = "+ " + @damageModifer.to_s + " " + @descriptor + " " + @type 
			else
				@fullName = @descriptor + " " + @type
			end

			if @numOfModifers > 0 
				@fullName = @fullName + " of " + @modName
			end

			@totalDamage = @damage + @fireDamage + @radiationDamage + @deathDamage
		end
	end
	def describe
		if @attackType == "range"
			return @fullName + " that shoots " + @ammoType
		else	
			return @fullName
		end
	end
	def generateBaseStats(weaponTypeLowRange, weaponTypeHighRange, weaponQualityLowRange, weaponQualityHighRange, weaponType)

		if weaponType == 0
			weaponType = rand(1..2)
		end

		@damageModifer = rand(0..5)

		if weaponType == 1
			if weaponTypeHighRange > @@meleeWeapons.length || weaponTypeHighRange <= 0
				weaponTypeHighRange = @@meleeWeapons.length - 1
			end

			if weaponTypeLowRange < 0 || weaponTypeLowRange > @@meleeWeapons.length
				weaponTypeLowRange = 0
			end
		else
			if weaponTypeHighRange > @@rangedWeapons.length || weaponTypeHighRange <= 0
				weaponTypeHighRange = @@rangedWeapons.length - 1
			end

			if weaponTypeLowRange < 0 || weaponTypeLowRange > @@rangedWeapons.length
				weaponTypeLowRange = 0
			end
		end

		if weaponTypeLowRange > weaponTypeHighRange
			weaponTypeHighRange = weaponTypeLowRange
		end

		if weaponQualityLowRange > @@descriptors.length || weaponQualityLowRange < 0
			weaponQualityLowRange = 0
		end

		if weaponQualityHighRange <= 0 || weaponQualityHighRange > @@descriptors.length
			weaponQualityHighRange = @@descriptors.length - 1
		end

		if weaponType == 1 #melee weapon
			@typeInt = rand(weaponTypeLowRange..weaponTypeHighRange)
			@type = @@meleeWeapons[@typeInt][0]
			@descInt = rand(weaponQualityLowRange..weaponQualityHighRange)
			@damage = ((@descInt * 0.3)).to_i + @damageModifer + @@meleeWeapons[@typeInt][1] 
			@attack = @@meleeWeapons[@typeInt][2]
			@descriptor = @@descriptors[@descInt]
			@attackPhrase = ["stab", "bash", "jam", "slap", "smash", "sock" ]
			@ammoType = ""
			@attackType = "melee"
		else 
			@typeInt = rand(weaponTypeLowRange..weaponTypeHighRange)
			@type = @@rangedWeapons[@typeInt][0]
			@descInt = rand(weaponQualityLowRange..weaponQualityHighRange)
			@attack = @@rangedWeapons[@typeInt][2]
			@descriptor = @@descriptors.at(@descInt)
			@attackPhrase = ["shoot", "fire"]
			@ammoInt = rand(@@ammoTypes.length)
			@ammoType = @@ammoTypes[@ammoInt][0]
			@damage = (@@rangedWeapons[@typeInt][1] + (@descInt * 0.3)).to_i + @damageModifer + @@ammoTypes[@ammoInt][1]
			@attackType = "range"
		end
	end
	def generateModifiers(modifierLowRange, modifierHighRange)

		modifiers = [
			["poison","poisonous"], 				#adds poison damage
			["flames","burning"],					#adds fire damage
			["infinite mass" , "heavy"], 			#has a chance to stun enemy
			["riches", "golden"], 					#increases gold drop amount on hit
			["eye pokeage", "blinding"],			#chance to blind enemy
			["headaches", "skull cracking"],		#Double damage when hitting enemies in the head
			["radiation", "radiating"],				#causes enemyes to puke
			["bone breakage", "crippling"],			#chance to cripple enemy, allowing escape through any door
			["fatalities", "fatal"],				#small chance to instakill
			["blood", "bloody"],            		#causes excessive bleeding - like a lot
			["grenades", "explosive"],				#causes enemies to explode on death - purely for fun 	
			["leeches", "vampiric"], 				#chance to gain hp on hit
			["death", "reaping"],					#each kill increases weapon damage by +1
			["accuracy", "sniping"],				#Attack booster
			["escape", "escaping"],					#Increase chance to flee from combat
			["health", "vigor"]						#each kill increases max health by 1
		]
		
		initWeaponMods()

		if modifierHighRange == 0 || modifierHighRange > 2
			modifierHighRange = 2
		end
		
		if modifierLowRange > 2
			modifierLowRange = 0
		end

		@numOfModifers = rand(modifierLowRange..modifierHighRange)

		if @numOfModifers > 1 

			modIndex = rand(modifiers.length) 
			modifierType = modifiers[modIndex][1]
			setModfierValues(modifierType)
			@modName = modifiers[modIndex][1] + " "
			
			modIndex = rand(modifiers.length) 
			modifierType = modifiers[modIndex][1]
			setModfierValues(modifierType)
 			@modName = @modName + modifiers[modIndex][0] 

		elsif @numOfModifers == 1
			modIndex = rand(modifiers.length) 
			modifierType = modifiers[modIndex][1]
			setModfierValues(modifierType)
			@modName = modifiers[modIndex][0]
		else

		end

	end
	def setModfierValues(modifierType)
		case modifierType
		when "poisonous", "poison"
			@poisonDamage += rand(3..8)
		when "burning", "flames"
			@fireDamage = @fireDamage + rand(3..10)
		when "heavy", "infinite mass"
			@stunChance = @stunChance + rand(10..20)
		when "golden", "riches"
			@lootDropModVal = @lootDropModVal + rand(1..5)
		when "blinding", "eye pokeage"
			@blindChance = @blindChance + rand(5..20)
		when "skull cracking", "headaches"
			@headshotDamage = true
		when "radiating", "radiation"
			@radiationDamage = @radiationDamage + rand(1..6)
		when "crippling", "bone breakage"
			@cripplingChance = @cripplingChance + rand(10..25)
		when "fatal", "fatalities"
			@instaKillChance = @instaKillChance + rand(5..10)
		when "bloody", "blood"
			@bleedingChance = @bleedingChance + rand(20..30)
		when "explosive", "grenades"
			@exploding = true
		when "reaping", "death"
			@deathDamage = 1
		when "vampiric", "leeches"
			@leechChance = @leechChance + rand(10..50)
		when "sniping", "accuracy"
			@attack += rand(5..10)
		when "escaping", "escape"
			@escapeChance += rand(10..25)
		when "health", "vigor"
			@healthBonus = true
		end
	end
	def initWeaponMods()
		@modName = ""
		@fireDamage = 0
		@poisonDamage = 0
		@stunChance = 0
		@lootDropModVal = 0
		@blindChance = 0
		@instaKillChance = 0
		@radiationDamage = 0
		@cripplingChance = 0
		@bleedingChance = 0
		@exploding = false
		@deathDamage = 0
		@leechChance = 0
		@headshotDamage = false
		@escapeChance = 0
		@healthBonus = false
	end
	def getStats()
		
		stats = "\n\n\n==========[Weapon Info]==========".white.bold + \
				"\nName: " + @fullName.yellow.bold + \
				"\nBase Damage: ----------- " + @damage.to_s + \
				"\nPoison Damage : -------- " + @poisonDamage.to_s + \
				"\nFire Damage: ----------- " + @fireDamage.to_s + \
				"\nRadiation Damage: ------ " + @radiationDamage.to_s + \
				"\nAttack: ---------------- " + @attack.to_s + "% chance to hit"

		if @deathDamage > 0
			stats = stats + "\nDeath Damage: ---------- " + @deathDamage.to_s + " (kills increase this value)"
		end

		if @stunChance > 0 
			stats = stats + "\nChance to Stun: -------- " + @stunChance.to_s
		end

		if @cripplingChance > 0
			stats = stats + "\nChance to Cripple: ----- " + @cripplingChance.to_s
		end

		if @instaKillChance > 0
			stats = stats + "\nChance to InstaKill: --- " + @instaKillChance.to_s
		end

		if @blindChance > 0
			stats = stats + "\nChance to Blind: ------- " + @blindChance.to_s
		end

		if @lootDropModVal > 0
			stats = stats + "\nIncrease Money Drops by " + @lootDropModVal.to_s + " per hit."
		end

		if @bleedingChance > 0
			stats = stats + "\nChance to Bleed: ------- " + @bleedingChance.to_s
		end

		if @leechChance > 0
			stats = stats + "\nChance to Steal Health:  " + @leechChance.to_s
		end

		if @exploding
			stats = stats + "\nCauses enemies to explode into pieces on death. Awesome."
		end

		if @radiationDamage > 0 
			stats = stats + "\nCauses enemies to become sick and vomit - lowers enemies attack value."
		end

		if @headshotDamage 
			stats = stats + "\nHitting enemies in the head does extra damage!"
		end

		if @healthBonus
			status = stats + "\nKilling enemies increases your max health!"
		end
		
		return stats

	end
	attr_accessor :objectType
	attr_accessor :type
	attr_accessor :damage
	attr_accessor :descriptor
	attr_accessor :fullName
	attr_accessor :attackPhrase
	attr_accessor :ammoType
	attr_accessor :attackType
	attr_accessor :blindChance
	attr_accessor :stunChance
	attr_accessor :cripplingChance
	attr_accessor :instaKillChance
	attr_accessor :fireDamage
	attr_accessor :poisonDamage
	attr_accessor :radiationDamage
	attr_accessor :lootDropModVal
	attr_accessor :exploding
	attr_accessor :totalDamage
	attr_accessor :deathDamage
	attr_accessor :leechChance
	attr_accessor :headshotDamage
	attr_accessor :attack
	attr_accessor :bleedingChance
	attr_accessor :healthBonus
end