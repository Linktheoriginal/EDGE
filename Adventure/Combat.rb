require_relative 'Enemy'
require_relative 'Player'
require_relative 'GameFunctions'
require_relative 'Color'

class Combat
	@@tissueDamageDescriptions = #these will be set on the enemies body parts once hit
	[
		["completely destroyed", "unrecognizable", "annihilated"],
		["torn open", "ripped", "shredded", "torn"],
		["lightly brusied", "brusied", "cut", "scraped"]
		
	]
	@@boneDamageDescription = [
		["shattered", "destroyed", "snapped in half", "smashed to pieces"],
		["broken", "crushed", "fractured"],
		["bruised", "cracked", "busted", "chipped"]
	]
	@@painPhrases = [
		"WARGHHHAHHH!",
		"OWWW!",
		"********!",
		"UGHHHH!",
		"RAGAHH!"
	]
	@@tauntPhrase =
	[
		"You are weak!",
		"You are pathetic!",
		"You will die here!",
		"I will cut you!",
		"Prepare to die!",
		"You're done for!",
		"Feel my wrath!",
		"Taste my pain!",
		"Your mother says hi!",
		"Give me those eyes!",
		"Your soul is mine!",
		"Bleed slow!",
		"I got 99 problems but an adventurer ain't one!",
		"HIT ME!",
		"RIP AND TEAR!",
		"I can't die!",
		"You will never leave this dungeon!",
		"I will karate chop your throat later!",
		"I'll chew your face off like a rat!",
		"Welcome to hell!",
		"Blalalalalat!",
		"You smell dead!",
		"Get out of my face!",
		"Drop it like it's hot!",
		"I'm going to drop you like it's hot!",
		"Warghlarghahaha!",
		"MUHAH AHAHAH!"
	]
	def prettyPrint (stringToPrint, drunk)
		consoleWidth = 79
		startChar = 0
		while startChar < stringToPrint.length
			charsThisLine = consoleWidth
			if startChar + charsThisLine > stringToPrint.length
				if drunk
					print stringToPrint[startChar, stringToPrint.length - startChar].reverse
					return
				else
					print stringToPrint[startChar, stringToPrint.length - startChar]
					return
				end
			elsif stringToPrint[startChar, charsThisLine].index("\n") != nil
				if drunk
					print stringToPrint[startChar, stringToPrint[startChar, charsThisLine].index("\n") + 1].reverse
					startChar += stringToPrint[startChar, charsThisLine].index("\n") + 1
				else
					print stringToPrint[startChar, stringToPrint[startChar, charsThisLine].index("\n") + 1]
					startChar += stringToPrint[startChar, charsThisLine].index("\n") + 1
				end
			else
				while charsThisLine > 1 and stringToPrint[startChar + charsThisLine] != " "
					charsThisLine -= 1
				end
				if drunk
					print (stringToPrint[startChar, charsThisLine] + "\n").reverse
					startChar += charsThisLine + 1
				else
					print stringToPrint[startChar, charsThisLine] + "\n"
					startChar += charsThisLine + 1
				end
			end
		end
	end
	def doCombat (player, enemy, playerIsAttacking)
		
		exitCombat = false
		combatMsg = ""

		while !exitCombat

			drawInitialInfo(player, enemy)
			prettyPrint(combatMsg, false)

			answer = gets.chomp

			if player.health == 0
				answer = ""
				exitCombat = true
				system ("cls")
				print "You have perished in combat!\n\n".red.bold
			end

			case answer.downcase
			when "run", "3", "leave"

				system ("cls")

				if enemy.health <= 0
					exitCombat = true
					print "You leave the dead ".green.bold + enemy.type.white.bold + " behind. ".green.bold
				else
					chanceToEscape = 50

					if player.legsCrippled
						chanceToEscape -= 20
					end

					if enemy.paralyzed
						chanceToEscape = 100
					end

					if enemy.legsCrippled 
						chanceToEscape += 35
					end

					if player.paralyzed
						chanceToEscape = 0
					end


					if rand(1..100) <= chanceToEscape
						#player escapes
						if player.legsCrippled 
							print "You crawl away from the ".green.bold + enemy.type.white.bold + " and successfully escape!".green.bold
						else
							print "You run from the ".green.bold + enemy.type.white.bold + " and successfully escape!".green.bold
						end
						exitCombat = true
					else
						if player.paralyzed
							prettyPrint "You paralysis keeps you from moving...\n\n".red.bold + "Do you want to die now or watch the enemy beat you to death?\n".white.bold, player.drunk
							print "(0)Die Now\n".white.bold
							print "(1)Continue with the one sided combat\n".white.bold
							answer = gets.chomp

							case answer.downcase
							when "0", "die", "die now"
								player.health = 0
								exitCombat = true
							else
								#do nothing
							end
						end
						combatMsg = "You failed to get away from the ".red.bold + enemy.type.white.bold + " and open yourself up to an attack!\n\n".red.bold
						combatMsg += handleEnemyAttack(player, enemy)
					end
				end
			when "attack", "0"
				combatMsg = handlePlayerAttack(player, enemy, false)

				if enemy.health > 0 
					combatMsg += handleEnemyAttack(player, enemy)
				end
			when "aimed attack", "1"
				combatMsg = handlePlayerAttack(player, enemy, true)

				if enemy.health > 0 
					combatMsg += handleEnemyAttack(player, enemy)
				end
			when "examine", "2"
				combatMsg = enemy.detailStatus()
			else
				combatMsg = "Invalid Command.\n\n"
			end

		end

		return ""
	end
	def handlePlayerAttack(player, enemy, aimedAttack)
		
		combatDescription = ""
		attackPhrase = player.weapon.attackPhrase[rand(player.weapon.attackPhrase.length)]
		attackType = player.weapon.attackType
		totalDamage = player.weapon.totalDamage
		chanceToHit = (player.weapon.attack - enemy.defense)
		weaponName = player.weapon.fullName
		enemyName = enemy.descriptor + " " + enemy.type

		if player.blind
			chanceToHit = (chanceToHit/1.5).to_i
		end

		if player.armsCrippled 
			chanceToHit = (chanceToHit/1.3).to_i
		end

		#check for bleeding
		if player.bleedAmt > 0
			if player.bleedAmt >= 4
				bleedModText = "heavily"
			else
				bleedModText = ""
			end
			combatDescription += "You are bleeding " + bleedModText + " and take " + player.bleedAmt.to_s + " damage. "
			player.health -= player.bleedAmt
		end

		if player.vomitting
			if rand(0..4) < 2
				combatDescription += "You feel sick and vomit on the dungeon floor!".green.bold
			end
		end

		if player.health <= 0
			player.health = 0
			return combatDescription + " The dungeon has bested you!\n\n".red.bold
		end

		#check diseases
		if player.disease.downcase == "tied shoelaces" && !player.legsCrippled
			if rand(1..100) <= 10
				trippinOnSyrup = true
			else
				trippinOnSyrup = false
			end
		else
			trippinOnSyrup = false
		end

		if player.disease.downcase == "narcolepsy" 
			if rand(1..100) <= 12
				fellAsleep = true
			else
				fellAsleep = false
			end
		else
			fellAsleep = false
		end

		if aimedAttack
			bodyPartSelected = false
			system("cls")
			drawInitialInfo(player, enemy)
			prettyPrint("\nAim for what? (0)Head (1)Neck (2)Torso (3)Arms (4)Legs \n\n".white.bold, player.drunk)
			while !bodyPartSelected
				bodyPartToAttack = gets.chomp

				case bodyPartToAttack.downcase
				when "0", "head"
					chanceToHit -= 10
					bodyPartToTarget = 0
					bodyPartSelected = true
				when "1", "neck"
					chanceToHit -= 5
					bodyPartToTarget = 4
					bodyPartSelected = true
				when "2", "torso"
					bodyPartToTarget = 1
					bodyPartSelected = true
				when "3", "arms"
					bodyPartToTarget = rand(2..3)
					bodyPartSelected = true
				when "4", "legs"
					bodyPartToTarget = rand(5..6)
					bodyPartSelected = true
				end

			end
		end

		#putting this here just so the player can at least have a small chance to hit the enemy regardless
		if chanceToHit <= 0
			chanceToHit = 10
		end

		if enemy.health > 0

			if ((rand(100) <= chanceToHit) || (enemy.paralyzed)) && !player.paralyzed && !trippinOnSyrup && !fellAsleep

				if !aimedAttack
					bodyPartToTarget = rand(0..6)
				end

				hitBodyPart = ""

				case bodyPartToTarget
				when 0
					bodyPart = enemy.bodyParts[:head][rand(enemy.bodyParts[:head].length)]
					hitBodyPart = "head"
				when 1
					bodyPart = enemy.bodyParts[:torso][rand(enemy.bodyParts[:torso].length)]
					hitBodyPart = "torso"
				when 2
					bodyPart = enemy.bodyParts[:leftarm][rand(enemy.bodyParts[:leftarm].length)]
					hitBodyPart = "left arm"
				when 3
					bodyPart = enemy.bodyParts[:rightarm][rand(enemy.bodyParts[:rightarm].length)]
					hitBodyPart = "right arm"
				when 4
					bodyPart = enemy.bodyParts[:neck][rand(enemy.bodyParts[:neck].length)]
					hitBodyPart = "neck"
				when 5
					bodyPart = enemy.bodyParts[:leftleg][rand(enemy.bodyParts[:leftleg].length)]
					hitBodyPart = "left leg"
				when 6
					bodyPart = enemy.bodyParts[:rightleg][rand(enemy.bodyParts[:rightleg].length)]
					hitBodyPart = "right leg"
				end
				print bodyPartToTarget.to_s
				bodyPart[1] = bodyPart[1] - rand(1..3)
					
				if bodyPart[1] < 0 #keep from going off the array bounds below
					bodyPart[1] = 0
				end

				#Get Damage Descriptor - cut, snapped in half, torn, etc
				if bodyPart[4] == :tissue
					damageDescription = @@tissueDamageDescriptions[bodyPart[1]][rand(@@tissueDamageDescriptions[bodyPart[1]].length)]
				elsif bodyPart[4] == :bone
					damageDescription = @@boneDamageDescription[bodyPart[1]][rand(@@boneDamageDescription[bodyPart[1]].length)]
				end

				bodyPart[2] = damageDescription #set damage descriptor on body part

				#Build attack string information - Maybe expand these to have a more varied set of combat phrases
				if attackType == "melee"
					combatDescription += "You swing your [" + weaponName.yellow.bold + "] and " + attackPhrase + " the " + enemyName.white.bold + " in the " + hitBodyPart.cyan.bold + "! " + \
											"The " + bodyPart[0].magenta.bold + " is hit and " + damageDescription.red.bold + "! "
					enemy.causeOfDeath = "Being " + attackPhrase + " in the " + hitBodyPart + ", " + bodyPart[0] + " with a [" + weaponName + "]" 
				else
					combatDescription += "You " + attackPhrase + " your [" + weaponName.yellow.bold + "] at the " + enemy.stance + " " + enemyName.white.bold + "'s " + hitBodyPart.cyan.bold + "! " + \
										 "The " + player.weapon.ammoType + " shot from the " + player.weapon.type + " hit the " + bodyPart[0].magenta.bold + \
										 "! " + "The " + bodyPart[0].magenta.bold + " is " + damageDescription.red.bold + "! "
					enemy.causeOfDeath = "A shot to the " + bodyPart[0] + " from your [" + weaponName + "]" #this is being set ahead of time if the enemy does die
				end

				#Additional Flavor Texts
				if bodyPart[4] == :tissue && bodyPart[1] <= 1
					bloodText = ["pours", "oozes", "runs"]
					combatDescription += enemy.bloodType.red.bold + " " + bloodText[rand(bloodText.length)] + " from the " + bodyPart[0].magenta.bold + "! "
				end

				if (bodyPart[0] == "left lung" || bodyPart[0] == "right lung" || hitBodyPart == "neck") && bodyPart[1] <= 1
					combatDescription += "The " + enemyName.white.bold + " coughs out " + enemy.bloodType.red.bold + "! "
				end

				if (bodyPart[0] == "mouth")
					if rand(4) <= 2 
						combatDescription += "The " + enemyName.white.bold + " spits out " + enemy.bloodType + ". "
					end
				end

				#Handle body part damage effects
				if bodyPart[3] == :stance && enemy.stance == "standing" && bodyPart[1] <= 1 
					combatDescription += "The damage to the " + bodyPart[0].cyan.bold + " causes the " + enemyName.white.bold + " to drop to the ground." + \
										"The enemy is crippled!"
					enemy.defense = enemy.defense/2
					enemy.legsCrippled = true
					enemy.stance = "prone"

				elsif bodyPart[3] == :sight && !enemy.blind && bodyPart[1] == 0
					combatDescription += "The damage to the " + bodyPart[0] + " has blinded the enemy! Accuracy is greatly reduced!"
					enemy.blind = true
					enemy.attack = ((enemy.attack)/3).to_i

				elsif bodyPart[3] == :bleeding && bodyPart[1] <= 1
					combatDescription += "The " + bodyPart[0].magenta.bold + " sprays " + enemy.bloodType + "! The " + enemy.type + " is bleeding heavily!"

					if enemy.bleedAmt == 0
						enemy.bleedAmt = 2
					else
						enemy.bleedAmt *= 2
					end

				elsif bodyPart[3] == :speech && bodyPart[1] <= 1 && !enemy.muted
					combatDescription += "The " + enemyName.white.bold + " can no longer speak! "
					enemy.muted = true

				elsif bodyPart[3] == :vital && bodyPart[1] == 0
					combatDescription += "A vital organ is destroyed! The damage done to the " + bodyPart[0] + " kills the " + enemyName + " instantly."
					enemy.health = 0
					enemy.causeOfDeath = "Heavy damage to the " + bodyPart[0]

				elsif bodyPart[3] == :paralysis && bodyPart[1] <= 1 && !enemy.paralyzed 
					combatDescription += "The damage to the " + bodyPart[0] + " paralyzes the enemy!"
					
					enemy.paralyzed = true
					enemy.attack = 0

					if enemy.stance == "standing"
						combatDescription += "The enemy drops to the ground. "
					end

					enemy.stance = "prone"

				elsif bodyPart[3] == :suffocation && bodyPart[1] == 1 && enemy.suffocationCount == -1
					suffocateStrings = ["start suffocating!", "start drowning in its own blood!"]
					combatDescription += "The damage has caused the " + enemy.type + " to " + suffocateStrings[rand(suffocateStrings.length)]
					enemy.suffocationCount = 6  #kills the enemy in 6 turns

				elsif bodyPart[3] == :suffocation && bodyPart[1] == 0 && enemy.suffocationCount > 4
					suffocateStrings = ["start suffocating!", "start drowning in its own blood!"]
					combatDescription += "The damage has caused the " + enemy.type + " to " + suffocateStrings[rand(suffocateStrings.length)]
					enemy.suffocationCount = 4  #kills the enemy in 4 turns

				elsif bodyPart[3] == :vomitting && bodyPart[1] <= 1 && !enemy.vomitFlag
					combatDescription += "Damaging the " + bodyPart[0] + " has made the enemy feel sick." 
					enemy.vomitFlag = true

				elsif bodyPart[3] == :attack && bodyPart[1] <= 1 && enemy.armsCrippled
					combatDescription += "Damage to the " + bodyPart[0] + " has caused the " + enemy.type + " to drop its " + enemy.weaponName + "! " + \
										 "Enemy's damage & attack down! "

					enemy.weaponName = "fists"
					enemy.damage = enemy.damage/2
					enemy.attack = enemy.attack/2
					enemy.armsCrippled = true
				end

				#Build special weapon attack effects and damage string
				combatDescription += handleDamageAndWeaponMods(player, enemy, bodyPart, hitBodyPart)

				#Build enemy death string
				if enemy.health == 0
					combatDescription += buildEnemyDeathString(enemy, player, true)
				else 
					enemy.causeOfDeath = ""
				end

				enemy.update()
			else
				
				if trippinOnSyrup

					combatDescription += "You go to attack the enemy and trip on your shoe strings! ".white.bold
					
					#I don't want this to kill the player although it would be funny.
					if player.health > 1
						player.health -= 1
					end
				elsif fellAsleep
					combatDescription += "You feel a sudden wave of sleepiness come over you...You fall asleep! You're open to an attack!"

				elsif player.paralyzed
					combatDescription += "Due to your " + "paralysis".blue.bold + " you can't attack. Things look hopeless...."
				else 
					if attackType == "melee"
						combatDescription += "You swing your [" + weaponName.yellow.bold + "] at the " + enemyName + " but swing too wide! You missed!"
					else
						combatDescription += "You " + attackPhrase + " your [" + weaponName.yellow.bold + "] at the " + enemyName + " but completely miss!"
					end
				end
			end

		else
			combatDescription = "You " + attackPhrase + " your [" + weaponName + "] into the " + enemyName + "'s dead body. Better safe than sorry right?"
		end

		return combatDescription + "\n\n"
	end
	def handleDamageAndWeaponMods(player, enemy, bodyPart, hitBodyPart)
		
		damageDescription = ""
		damageNumbers = ""
		headshotString = ""
		totalDamageDealt = player.weapon.totalDamage + player.basedamage

		if hitBodyPart == "head" && player.weapon.headshotDamage
			totalDamageDealt += ((player.weapon.damage * 1.6).to_i - player.weapon.damage)
			damageDescription = " The headshot did an additional " + ((player.weapon.damage * 1.6) - player.weapon.damage).to_i.to_s + " damage! "
			headshotString = "/" + ((player.weapon.damage * 1.6) - player.weapon.damage).to_i.to_s + " headshot"
		end

		damageNumbers = "\n\n You do a total of " + totalDamageDealt.to_s + " damage: "
		damageNumbers += player.weapon.damage.to_s + " base" + headshotString

		if player.weapon.poisonDamage > 0 
			damageDescription = "The toxins from your [" + player.weapon.type.yellow.bold + "] has " + "poisoned".green.bold + " the enemy. "
			enemy.poisonAmt = player.weapon.poisonDamage
		end

		if player.weapon.fireDamage > 0
			damageNumbers += "/" + player.weapon.fireDamage.to_s + " fire"
			damageDescription += "The flames from your [" + player.weapon.type.yellow.bold + "] has burned its " + bodyPart[0].magenta.bold + "! "
			if bodyPart[4] == :tissue
				bodyPart[2] = "melted and " + bodyPart[2]
			else
				bodyPart[2] = "charred and " + bodyPart[2]
			end
		end

		if player.weapon.radiationDamage > 0
			damageNumbers += "/" + player.weapon.radiationDamage.to_s + " radiation"
			damageDescription += "The radiation from your [" + player.weapon.type.yellow.bold + "] has radiated the enemy. "
			
			if !enemy.vomitFlag
				damageDescription += " It's starting to feel sick from the radiation! "
			end

			enemy.vomitFlag = true
		end


		if rand(1..100) <= player.weapon.stunChance
			damageDescription += "You stunned the enemy! "
			enemy.stunned = true
		end


		if player.weapon.lootDropModVal > 0
			enemy.money += rand(1..player.weapon.lootDropModVal)
			damageDescription += "Your [" + player.weapon.type.yellow.bold + "] added addtional gold to the enemy's pockets! " 
		end

		if rand(1..100) <= player.weapon.blindChance
			damageDescription += "The blinding powers of your weapon has caused the enemy to lose its sight!"
			enemy.blind = true
			enemy.attack = ((enemy.attack)/3).to_i
		end


		if rand(1..100) <= player.weapon.cripplingChance && !enemy.legsCrippled
			damageDescription += "The crippling power of your weapon has crippled the " + enemy.type.white.bold + "'s legs! It drops to the ground. "
			enemy.legsCrippled = true
		end

		if rand(1..100) <= player.weapon.instaKillChance
			enemy.health = 0
			damageDescription += "The fatal powers of your weapon has instantly killed the enemy! "
		end

		if rand(1..100) <= player.weapon.bleedingChance

			if enemy.bleedAmt > 0
				damageDescription += "The weapon has caused additional bleeding! "
			else
				damageDescription += "The weapon has caused severe bleeding! "
				enemy.bleedAmt = 1
			end

			enemy.bleedAmt *= 2

		end

		if rand(1..100) <= player.weapon.leechChance
			player.health += (totalDamageDealt * 0.3).to_i
			if player.health > player.maxhealth
				player.health = player.maxhealth
			end
			damageDescription += "The weapon has pulled the life force from the " + enemy.type + "! You gain " + (totalDamageDealt * 0.3).to_i.to_s + " HP! "
		end

		if totalDamageDealt <= 0
			totalDamageDealt = 1
		end

		enemy.health -= totalDamageDealt.to_i

		if enemy.health <= 0
			enemy.health = 0
			player.kills += 1
			if player.weapon.deathDamage > 0
				player.weapon.deathDamage += 1
				damageDescription += "The weapon is fueled by the " + enemy.type + "'s' death! Weapon damage increased by 1!"
			end
			if player.weapon.healthBonus
				player.maxhealth += 1
				damageDescription += "The weapon drains the " + enemy.type + "'s soul and increases your maximum health!"
			end
		end

		return damageDescription #+ damageNumbers
	end
	def buildEnemyDeathString(enemy, player, afterPlayerAttack)
		deathString = "\n\n"

		if player.weapon.exploding && afterPlayerAttack
			i = 0
			deathString += enemy.partialName + " begins to shake violently! The exploding awesomeness of your weapon " + \
						  "is causing the " + enemy.type + " to blow up! "
			deathString = deathString.green

			while i < rand(4..10)
				mainParts = enemy.bodyParts.keys
				mainPart = mainParts[rand(mainParts.length)]
				subPart = enemy.bodyParts[mainPart][rand(enemy.bodyParts[mainPart].length)]

				if subPart[4] == :tissue
					damageDescription = @@tissueDamageDescriptions[0][rand(@@tissueDamageDescriptions[0].length)]
				elsif subPart[4] == :bone
					damageDescription = @@boneDamageDescription[0][rand(@@boneDamageDescription[0].length)]
				end

				if subPart[1] > 0
					deathString += "The " + subPart[0].magenta.bold + " explodes and is " + damageDescription.red.bold + "! "
				end

				subPart[1] = 0
				subPart[2] = damageDescription
				i += 1
			end 
			return deathString
		end

		if enemy.stance == "standing"
			deathString += enemy.partialName.white.bold + " drops to the ground with a hard thud. "

			if enemy.vomitFlag && enemy.bleedAmt > 0 
				deathString += enemy.partialName.white.bold + " lands in a puddle of puke and " + enemy.bloodType + ". "
			elsif enemy.vomitFlag 
				deathString += enemy.partialName.white.bold + " lands in a puddle of puke. "
			elsif enemy.bleedAmt > 0
				deathString += enemy.partialName.white.bold + " lands in a puddle of " + enemy.bloodType + ". "
			end
		else
			if !enemy.paralyzed
				deathString += enemy.partialName.white.bold + " crawls foward a few inches then passes away."
			else
				deathString += enemy.partialName.white.bold + ", unable to move, gives up and dies "

				if enemy.vomitFlag && enemy.bleedAmt > 0 
					deathString += " in a puddle of puke and " + enemy.bloodType + ". "
				elsif enemy.vomitFlag 
					deathString += "in a puddle of puke. "
				elsif enemy.bleedAmt > 0
					deathString += "in a puddle of " + enemy.bloodType + ". "
				else
					deathString += ". "
				end

			end
		end

		#deathString += "\n\nThe cause of death was: " + enemy.causeOfDeath

		return deathString
	end
	def handleEnemyAttack(player, enemy)
		
		combatString = ""
		damageDescription = ""
		vomitAttackMod = 0
		attackString = ["swings", "flails", "thrashes"]
		weaponAttackPhrases = ["stabs", "bashes", "jams", "slaps", "smashes", "socks"]

		#check for poison, bleeding, and suffocation damage and subtract from health
		if enemy.poisonAmt > 0
			combatString += "The " + enemy.type + " is poisoned and takes " + enemy.poisonAmt.to_s + " damage. "
			enemy.health -= enemy.poisonAmt
			enemy.poisonAmt = 0
			enemy.causeOfDeath = "Succumbing to Poison"
		end

		if enemy.bleedAmt > 0
			
			if enemy.bleedAmt >= 4
				bleedModText = "heavily"
			else
				bleedModText = ""
			end

			combatString += "The " + enemy.type.white.bold + " is " + " bleeding ".red.bold + bleedModText + " and takes " + enemy.bleedAmt.to_s + " damage. "
			enemy.health -= enemy.bleedAmt
			enemy.causeOfDeath = "Blood Loss"
		end

		if enemy.suffocationCount > 0
			suffocateStrings = ["gasps for air!", "is choking out!"]
			combatString += "The " + enemy.type.white.bold + " " + suffocateStrings[rand(suffocateStrings.length)]
			enemy.suffocationCount -= 1
		elsif enemy.suffocationCount == 0
			combatString += "The " + enemy.type.white.bold + " has suffocated."
			enemy.health = 0
			enemy.causeOfDeath = "Suffocation"
		end

		if enemy.health <= 0
			enemy.health = 0
			combatString += buildEnemyDeathString(enemy, player, false)
			return combatString
		end

		if enemy.vomitFlag
			vomitPhrases = ["throws up", "vomits heavily", "retches and vomits", "vomits" ]
			combatString += "The " + enemy.type + " " + vomitPhrases[rand(vomitPhrases.length)].green.bold + ". "
			vomitAttackMod = (enemy.attack * 0.4).to_i
			enemy.vomitFlag = false
		end

		calcPlayerDefense = player.basedefense + player.armor.defense + player.hat.defense

		#Handle taunts
		if rand(0..4) < 2 
			if !enemy.muted
				speechAction = ["yells out", "blurts out", "whispers", "screams", "says"]
				combatString += "\nBefore attacking, the " + enemy.type.white.bold + " " + speechAction[rand(speechAction.length)] + " \"" + @@tauntPhrase[rand(@@tauntPhrase.length)].red.bold + "\"\n"
			else
				combatString += "\nThe " + enemy.type.white.bold + " tries to scream something but can't! \n"
			end
		end

		#Determine if the enemy has hit the player
		if (rand(1..100) <= (enemy.attack - calcPlayerDefense - vomitAttackMod) && !enemy.paralyzed && !enemy.stunned) || player.paralyzed

			bodyPartToTarget = rand(0..6)
			hitBodyPart = ""

			case bodyPartToTarget
			when 0
				bodyPart = player.bodyParts[:head][rand(player.bodyParts[:head].length)]
				hitBodyPart = "head"
			when 1
				bodyPart = player.bodyParts[:torso][rand(player.bodyParts[:torso].length)]
				hitBodyPart = "torso"
			when 2
				bodyPart = player.bodyParts[:leftarm][rand(player.bodyParts[:leftarm].length)]
				hitBodyPart = "left arm"
			when 3
				bodyPart = player.bodyParts[:rightarm][rand(player.bodyParts[:rightarm].length)]
				hitBodyPart = "right arm"
			when 4
				bodyPart = player.bodyParts[:neck][rand(player.bodyParts[:neck].length)]
				hitBodyPart = "neck"
			when 5
				bodyPart = player.bodyParts[:leftleg][rand(player.bodyParts[:leftleg].length)]
				hitBodyPart = "left leg"
			when 6
				bodyPart = player.bodyParts[:rightleg][rand(player.bodyParts[:rightleg].length)]
				hitBodyPart = "right leg"
			end

			bodyPart[1] = bodyPart[1] - rand(1..2) 
				
			if bodyPart[1] < 0 #keep from going off the array bounds in the damage description array
				bodyPart[1] = 0
			end
			

			#Get Damage Descriptor - cut, snapped in half, torn, etc
			if bodyPart[4] == :tissue
				damageDescription = @@tissueDamageDescriptions[bodyPart[1]][rand(@@tissueDamageDescriptions[bodyPart[1]].length)]
			elsif bodyPart[4] == :bone
				damageDescription = @@boneDamageDescription[bodyPart[1]][rand(@@boneDamageDescription[bodyPart[1]].length)]
			end

			#Check vital hits
			if bodyPart[0] == "brain" && player.hat != "" && bodyPart[1] == 0
				combatString += "The " + enemy.type.white.bold + " lands a hit on your brain but " + \
			                     "your " + player.hat + " saves you from the deadly blow! Your " + player.hat + " falls apart!"
			    player.hat = ""
			    bodyPart[1] = 1
			    return combatString
			elsif bodyPart[0] == "heart" && player.armor != "" && bodyPart[1] == 0
				combatString += "The " + enemy.type + " lands a hit on your heart but " + \
			                     "your " + player.armor + " saves you from the deadly blow! Your " + player.armor + " falls apart!"
			    player.armor = ""
			    bodyPart[1] = 1
			    return combatString
			end


			bodyPart[2] = damageDescription #set damage descriptor on body part

			#Build attack string information - Maybe expand these to have a more varied set of combat phrases
			if !enemy.armsCrippled
				combatString += "The " + enemy.type.white.bold + " " + attackString[rand(attackString.length)] + " its " + enemy.weaponName.yellow.bold + " and " + \
				                     weaponAttackPhrases[rand(weaponAttackPhrases.length)] + " you in the " + hitBodyPart.cyan.bold + "! " + \
				                     "Your " + bodyPart[0].magenta.bold + " is hit and is " + damageDescription.red.bold + "! "
			else
				combatString += "The " + enemy.type + " bites " + " you in the " + hitBodyPart.cyan.bold + "! It presses its bite down on your " + bodyPart[0].magenta.bold + "! It's" + damageDescription + "! "
			end

			#Additional Flavor Texts
			if bodyPart[4] == :tissue && bodyPart[1] <= 1
				bloodText = ["pours", "oozes", "runs"]
				combatString += "Red blood " + bloodText[rand(bloodText.length)] + " from the " + bodyPart[0].magenta.bold + "! "
			end

			if (bodyPart[0] == "left lung" || bodyPart[0] == "right lung" || hitBodyPart == "neck") && bodyPart[1] <= 1
				bloodText = ["a mouth full of", "", "a large amount of" ]
				combatString += "You cough out " + bloodText[rand(bloodText.length)] + " red blood! "
			end

			if (bodyPart[0] == "mouth")
				if rand(4) <= 2 
					combatString += "You spit out blood. "
				end
			end

			#Handle body part damage effects
			if bodyPart[3] == :stance && player.stance == "standing" && bodyPart[1] <= 1 
				combatString += "The damage to your " + bodyPart[0] + " causes you to drop to the ground." + \
									"Your legs are crippled, putting you at a disadvantage! "
				player.basedefense = (player.basedefense/1.3).to_i
				player.legsCrippled = true
				player.stance = "prone"

			elsif bodyPart[3] == :sight && !player.blind && bodyPart[1] == 0
				combatString += "The damage to your " + bodyPart[0] + " has blinded you! "
				player.blind = true 

			elsif bodyPart[3] == :bleeding && bodyPart[1] <= 1

				combatString += "Your " + bodyPart[0].magenta.bold + " sprays blood! " + "You are bleeding heavily! ".red.bold
				player.bleedAmt += 1

			elsif bodyPart[3] == :speech && bodyPart[1] <= 1 && !player.muted
				combatString += "You can no longer speak! "
				player.muted = true

			elsif bodyPart[3] == :vital && bodyPart[1] == 0

				combatString += "A vital organ is destroyed! The damage done to your " + bodyPart[0].magenta.bold + " kills you instantly. ".red.bold
				player.health = 0

			elsif bodyPart[3] == :paralysis && bodyPart[1] == 0 && !player.paralyzed 


				combatString += "The damage to your " + bodyPart[0].magenta.bold + " has paralyzed you! "
				
				player.paralyzed = true

				if player.stance == "standing"
					combatString += "You drop to the ground. "
				end

				player.stance = "prone"

			elsif bodyPart[3] == :vomitting && bodyPart[1] <= 1 && !player.vomitting
				combatString += "The damage done to your " + bodyPart[0].magenta.bold + " has made you feel sick. " 
				player.vomitting = true

			elsif bodyPart[3] == :attack && bodyPart[1] <= 1 && !player.armsCrippled
				combatString += "Damage to your " + bodyPart[0] + " has crippled your arm! "
				player.armsCrippled = true
			end

			player.health -= enemy.damage

			if player.health < 0
				player.health = 0
			end

			combatString += handleDiseaseTransfer(player, enemy.type, enemy.diseaseType, enemy.contagionLevel)
			player.UpdateStatusEffects()

			combatString += "\n\n The " + enemy.type + " deals " + enemy.damage.to_s + " total damage. "
			

		else
			
			#This needs more work
			if enemy.stunned 
				combatString += "The " + enemy.type + " is in a stunned state and can't attack you."
				enemy.stunned = false
			elsif enemy.paralyzed
				combatString += "The " + enemy.type + " is paralyzed and can't attack you!"
			else
				if !enemy.legsCrippled
					movementString = ["dashes", "runs", "dances"]
					
					if !enemy.armsCrippled
						attackString = "swings at you with its " + enemy.weaponName
					else
						attackString = "bites at you"
					end

					combatString += "The " + enemy.type.white.bold + " " + movementString[rand(movementString.length)] + " up and " + attackString + " but misses you!"

				else
					movementString = ["crawls", "rolls", "wiggles"]

					if !enemy.armsCrippled
						attackString = "swings at you with its " + enemy.weaponName
					else
						attackString = "bites at you"
					end

					combatString += "The " + enemy.type.white.bold + " " + movementString[rand(movementString.length)] + " up to you and " + attackString + " but misses you!"
				end
			end

		end

		return combatString
	end
	def handleDiseaseTransfer(player, enemytype, disease, transferChance)
		
		diseasedString = ""

		if disease != "" && (player.disease == "" || player.disease == "none")
			if rand(1..4) <= transferChance
				player.disease = disease
				diseasedString += "Contact with the " + enemytype + " has " + "infected".green.bold + " you with " + disease.yellow.bold + "! " 
			end
		end

		return diseasedString 
	end
	def drawHUD(player, enemy)
		hudString = "[==================[".white.bold + "COMBAT ENGAGED".white.bold + "]==================]\n\n".white.bold
		
		enemyHealthBar = buildHealthBar(enemy.health, enemy.maxhealth, enemy.fullName, enemy.statusEffects)
		playerHealthBar = buildHealthBar(player.health, player.maxhealth, player.name, player.statusEffects)

		hudString = hudString + enemyHealthBar + "\n\n" + playerHealthBar

		print hudString
	end
	def buildHealthBar(health, maxhealth, name, statusEffects)
		healthBarSize = 40
		healthBarString = name.white.bold + "\n["
		healthBarInt = ((health.to_f/maxhealth.to_f) * healthBarSize).to_i

		healthBarInt.times{
			healthBarString = healthBarString + "#".red.bold
		}

		#Draw missing health bar
		(healthBarSize - healthBarInt).times{
			healthBarString = healthBarString + "."
		}

		healthBarString += "]\n" + "Health:".white.bold + health.to_s + "\\" + maxhealth.to_s + " " + statusEffects

		return healthBarString
	end
	def drawInitialInfo(player, enemy)
		player.UpdateStatusEffects()
		enemy.update()
		system ("cls")
		drawHUD(player, enemy)
		print("\n\n[====================[MESSAGES]======================]".white.bold)
		print("\n\nChoose an action:\n(0)Attack  (1)Aimed Attack  (2)Examine Enemy  (3)Flee/Leave \n\n".white.bold)

	end


end