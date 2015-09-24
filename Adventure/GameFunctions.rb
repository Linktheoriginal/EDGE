require_relative "Door"
require_relative "Room"
require_relative "Hat"
require_relative "Enemy"
require_relative "Weapon"
require_relative "Armor"
require 'io/console'

def numeric?(object)
  true if Float(object) rescue false
end

class GameFunctions
	@@letterArray = [
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z"
	]
	def initialize()
		@doors = Array.new
		@rooms = Array.new
		@currentRoom = 0
		@lastRoom = 0
		@useChains = false
		@useStockade = false
		@useLegIrons = false
		@dungeonName = generateDungeonName()
		@questItem = Item.new
		generateQuestItem
	end
	def StartGame (player)
		startgame = false
		endgame = false

		system ("cls")

		drawMainMenu()

		while !startgame
			answer = gets.chomp
			case answer.downcase

			when "1", "start", "start game"
				while player.name == ""
					system ("cls")
					print "Welcome to " + @dungeonName + ".\n\nWhat is your name adventurer?\n\n"
					player.name = gets.chomp
				end
				
				system("cls")
				
				handleClassSelection(player)

				while player.motto == ""
					system("cls")
					prettyPrint player.classType + ".  That's a fine choice. Do you have a motto, " + player.classType + "?\n\n", false
					player.motto = gets.chomp
				end
				
				if player.motto.downcase == "n" or player.motto.downcase == "no" or player.motto.downcase == "nope"
					player.motto = "" 
				end

				system("cls")

				if player.motto == ""
					prettyPrint "Let us begin.\n\nYou are adventuring into " + @dungeonName + " searching for " + @questItem.describe + ". You must find and slay the dungeon keeper to finish your quest.  You can get available commands at any time by typing 'help'.\n\nYou enter " + @dungeonName + " and look around.\n\n", false
				else
					prettyPrint "'" + player.motto + "', alright then.  Let us begin.\n\nYou are adventuring into " + @dungeonName + " searching for " + @questItem.describe + ". You must find and slay the dungeon keeper to finish your quest.  You can get available commands at any time by typing 'help'.\n\nYou enter " + @dungeonName + " and look around.\n\n", false
				end
				startgame = true

			when "2", "exit", "quit"
					startgame = true
					endgame = true
			end
		end

		player.quest = "The quest for " + @questItem.describe

		#set up doors for first roo
		newRoomDoors = Array.new
		(rand(3) + 1).times {
			newdoor = Door.new(0)
			@doors.push(newdoor)
			newRoomDoors.push(newdoor.doorNumber)
		}

		#set up first room
		@rooms.push(Room.new(newRoomDoors))
		@currentRoom = 0
		@rooms[@currentRoom].enemies.clear
		return endgame
	end
	def prettyPrint (stringToPrint, drunk)
		consoleWidth = 79
		startChar = 0

		if drunk
			drunkText = stringToPrint.split(/ /)
			for word in drunkText
				if rand(3) != 0
					#66% chance to affect this word
					(rand(2) + 1).times{
						word = word.insert(rand(word.length), @@letterArray[rand(@@letterArray.length)])
					}
				end
			end
			stringToPrint = drunkText.join(" ")
		end

		while startChar < stringToPrint.length
			charsThisLine = consoleWidth
			if startChar + charsThisLine > stringToPrint.length
				print stringToPrint[startChar, stringToPrint.length - startChar]
				return
			elsif stringToPrint[startChar, charsThisLine].index("\n") != nil
				print stringToPrint[startChar, stringToPrint[startChar, charsThisLine].index("\n") + 1]
				startChar += stringToPrint[startChar, charsThisLine].index("\n") + 1
			else
				while charsThisLine > 1 and stringToPrint[startChar + charsThisLine] != " "
					charsThisLine -= 1
				end
				print stringToPrint[startChar, charsThisLine] + "\n"
				startChar += charsThisLine + 1
			end
		end
	end
	def Go(openDoor)

		currentRoomObject = @rooms[@currentRoom]
		if openDoor >= currentRoomObject.doors.length
			print "No door found!"
			gets.chomp
			return
		end

		if @doors[@rooms[@currentRoom].doors[openDoor]].Go(@currentRoom) != @lastRoom
			allowMove = true
			@rooms[currentRoom].enemies.each_with_index { |enemy, i| 
				if enemy.health > 0 and !enemy.paralyzed and !enemy.legsCrippled
					allowMove = false
				end
			}
		end
		if allowMove == false
			print "Enemies in the room won't let you get there!"
			gets.chomp
			return
		end

		currentDoorObject = @doors[currentRoomObject.doors[openDoor]]

		if currentDoorObject.Go(currentRoom) != -1
			@lastRoom = @currentRoom
			@currentRoom = @doors[currentDoorObject.doorNumber].Go(currentRoom)
		else
			#check for old doors we can connect to
			foundDoorOne = false
			@doors.each_with_index { |door, i|

				if door.roomTwo == -1 and door.roomOne != @currentRoom
					#prevent from finding ourselves, or any door connected to the current room
					if door.descriptionType == currentDoorObject.descriptionType
						#found an unopened door we can use!
						if foundDoorOne
							doublelink = false
							@rooms[door.roomOne].doors.each_with_index { |door, i| 
								#prevent double-linkage
								if @doors[door].roomTwo == @currentRoom or @doors[door].roomOne == @currentRoom
									doublelink = true
								end
							}
							if !doublelink
								door.roomTwo = @currentRoom
								currentDoorObject.roomTwo = door.Go(@currentRoom)
								@lastRoom = @currentRoom
								@currentRoom = door.Go(@currentRoom)
								return
							end
						else
							foundDoorOne = true
						end
					end
					
					#make sure we don't close the map by using it
				end
			}

			#else gen new doors, then gen new room and set as current room
			newRoomDoors = Array.new

			newRoomDoors.push currentDoorObject.doorNumber
			(rand(2) + 1).times {
				newdoor = Door.new(@rooms.length)
				@doors.push(newdoor)
				newRoomDoors.push(newdoor.doorNumber) # length minus one?
			}

			@rooms.push(Room.new(newRoomDoors))
			currentDoorObject.roomTwo = @rooms.length - 1
			@lastRoom = @currentRoom
			@currentRoom = currentDoorObject.Go(@currentRoom) #length minus one?
		end
	end
	def UseItem (player, item)
		case item.effect
		when "drunk"
			player.drunk = true
			player.drunktimer = item.effectAmt
			print "You drunk!"
			gets.chomp
		when "health"
			player.health += item.effectAmt
			if player.health > player.maxhealth + player.hat.effectAmt
				player.health = player.maxhealth + player.hat.effectAmt
			end
			print "HP UP!"
			gets.chomp
		when "maxhealth"
			player.maxhealth += item.effectAmt
			print "Maximum HP Increased!"
			gets.chomp
		when "defense"
			player.basedefense += item.effectAmt
			print "Defense Up!"
			gets.chomp
		when "damage"
			player.basedamage += item.effectAmt
			print "Damage Up!"
			gets.chomp
		when "poison"
			player.poison = true
			player.poisontimer = item.effectAmt
			print "You feel sick."
			gets.chomp
		when "regen"
			player.regen = true
			player.regentimer = item.effectAmt
			print "You feel really healthy."
			gets.chomp
		when "money"
			player.money += item.effectAmt
			print item.effectAmt.to_s + " monies!"
			gets.chomp
		when "cure"
			if player.disease != "" && player.disease != "none"
				print "You have been cured of ".white.bold + player.disease.yellow.bold + "!".white.bold
			else
				print "You drink the poition but feel nothing."
			end

			player.disease = "none"
			gets.chomp
		when "bleeding"
			if player.bleedAmt > 0
				player.bleedAmt = 0
				print "You apply the bandages to your wounds and stop the bleeding!".green.bold
			else
				print "You're not bleeding so you decide to blow your nose with the bandages.".white.bold
			end
			gets.chomp
		when "win"
			prettyPrint "You take the " + item.fullName + " and hold it above your head, finally you've found what you were searching for.  You return out of the dungeon successful, and get money and mead and wenches and stuff.  Congratulations, you win!", player.drunk
			gets.chomp
			return true
		end
		return false
	end
	def UseObject(player, objectNumberInRoom)

		if objectNumberInRoom < @rooms[@currentRoom].objects.length
			object = @rooms[@currentRoom].objects[objectNumberInRoom]
			if object.actions.any? { |action| action = "use" }

				case object.objectIndex
				when 1
					#bench
					prettyPrint "You have a seat for a bit.", player.drunk
					gets.chomp
				when 2
					#couch
					if !object.used
						randMoney = rand(5) + 1
						prettyPrint "You rifle through the couch looking for spare change, and find " + randMoney.to_s + " coins.", player.drunk
						gets.chomp
						player.money += randMoney
					else
						prettyPrint "You rifle through the couch again, but only find a stale cheeto.", player.drunk
						gets.chomp
					end
					object.used = true
				when 3
					#set of chains
					prettyPrint "What are you going to do with those?  Do you have like a weird bondage thing?  I mean, that's fine if you do, no judgements here.", player.drunk
					gets.chomp
					@useChains = true
				when 4
					#statue
					if rand(2) == 1 and !object.used && player.disease.downcase != "automatonophobia"
						prettyPrint "You feel up the statue and find a switch located in an awkward place.  You hesitate before triggering it.  A section of wall slides aside to reveal a new door that you didn't see before", player.drunk
						gets.chomp
						newDoor = Door.new(@currentRoom)
						@doors.push(newDoor)
						@rooms[@currentRoom].doors.push(newDoor.doorNumber)
					else
						if player.disease.downcase == "automatonophobia"
							prettyPrint "You see the statue and begin to tremble furiously. You feel a knot in your stomach and vomit on the dungeon floor.", player.drunk
						else
							prettyPrint "You check out the statue, but it just seems to be an odd statement/discussion piece.  Whoever decorated this dungeon had strange taste.", player.drunk
						end

						gets.chomp
					end
					object.used = true
				when 5
					#bed
					if !object.used && player.disease.downcase != "insomnia"
						prettyPrint "You use the bed to nap for a bit.  HP UP!", player.drunk
						gets.chomp
						player.health += (player.maxhealth/4).to_i
						if player.health > player.maxhealth + player.hat.effectAmt
							player.health = player.maxhealth + player.hat.effectAmt
						end
						object.used = true
					else
						if player.disease.downcase == "insomnia"
							prettyPrint "You don't feel the need to sleep anymore...", player.drunk
						else							
							bedmessages = [
								"You eyeball the bed, but it looks like you had the night sweats last time you napped here.  Ew.",
								"You contemplate napping, but decide you could make more progress towards your life goal of sleeping in every bed you see by finding another bed.",
								"You yawn, but there's a strange stain on the bed that you're not sure was there before.  You decide to soldier on.",
								"Last time you slept in this bed you woke up itchy.  You wonder if there might be bedbugs - best play it safe.",
								"Looks like last time you slept here, a spring broke through the mattress.  It looks sharp and tetanus-y.  You'll have to sleep elsewhere."
							]
							prettyPrint bedmessages[rand(bedmessages.length)], player.drunk
						end

						gets.chomp
					end
				when 6
					#flag
					if object.itemText == ""
						flagdescriptions = [
							"This flag is a rastafarian flag with three colors that smells pungently of incense.",
							"This is a pastafarian flag with spaghetti on it that smells of red sauce and meatballs.",
							"This flag is a pirate flag that stinks of grog and... peglegs?  Do those have a smell?  This smells like that.",
							"This is the flag of the noble nation-state of Perelandra, embroidered with an ice coffin for interplanetary travel.",
							"This is a nihilist flag, made of the purest black fabric.",
							"You see a flag embroidered with a horse head.  You wonder what nation or organization would use this.  It's weird.",
							"This flag seems to be embroidered with the purest gold and silver thread.  You then notice that it's embroidered with some- just- very rude words.  You put it back down.",
							"This roughly made flag is soaked through with red wine.  You think it might have been a spill.  Actually, is this blood?",
							"You check out the flag, but it seems to have some naughty bits embroidered on it and you quickly set it aside before anyone else walks in the room."
						]
						object.itemText = flagdescriptions[rand(flagdescriptions.length)]
					end
					prettyPrint object.itemText, player.drunk
					gets.chomp
				when 7
					#altar
					if !object.used && player.disease.downcase != "theophobia"
						object.used = true
						religions = [
							"stubbed toes",
							"male enhancement",
							"flat, warm soda",
							"the black Brad Pitt",
							"pizza crusts",
							"garbage disposals",
							"shoes that won't stay laced",
							"pillow fluffing",
							"dubstep",
							"taint itches",
							"spaghetti",
							"misprinted business cards",
							"shiny pennies",
							"dripping water onto scrunched up straw wrappers",
							"dry humping",
							"stockades, leg irons, and chains",
							"uncooked rice",
							"endless virginity"
						]
						@religionrand = rand(religions.length)
						altarmessages = [
							"You desecrate the " + object.describe + " and are cursed by the god of " + religions[@religionrand] + ".",
							"You light the candle on the " + object.describe + " and are honored by the god of " + religions[@religionrand] + ".",
							"You recite the secret words over the " + object.describe + " and are given a gift by the god of " + religions[@religionrand] + ".",
							"You kneel at the " + object.describe + " and are blessed by the god of " + religions[@religionrand] + "."
						]
						effectnumber = rand(altarmessages.length)
						prettyPrint altarmessages[effectnumber], player.drunk
						case effectnumber
						when 0
							if !player.titles.include? ", the cursed"
								player.titles += ", the cursed"
							end
							player.health -= 1
							player.poison = true
							player.poisontimer = 3
							print "\n\nHP Down!\nPoisoned!"
						when 1
							if !player.titles.include? ", the respectful"
								player.titles += ", the respectful"
							end
							player.health += (player.maxhealth/4).to_i
							if player.health > player.maxhealth + player.hat.effectAmt
								player.health = player.maxhealth + player.hat.effectAmt
							end
							player.poison = false
							player.regen = true
							player.regentimer = 10
							print "\n\nHP Up!\nYou feel healthy!"
						when 2
							if !player.titles.include? ", the gifted"
								player.titles += ", the gifted"
							end
							player.health += (player.maxhealth/4).to_i
							if player.health > player.maxhealth + player.hat.effectAmt
								player.health = player.maxhealth + player.hat.effectAmt
							end
							@rooms[@currentRoom].items.push(Item.new)
							print "\n\nHP Up!\nAn Item appears on the altar!"
						when 3
							if !player.titles.include? ", the blessed"
								player.titles += ", the blessed"
							end
							player.basedamage += 1
							player.maxhealth += 1
							if player.health > player.maxhealth + player.hat.effectAmt
								player.health = player.maxhealth + player.hat.effectAmt
							end
							player.disease = "none"
							print "\n\nAttack Up!\nMax HP UP! Disease Dispelled!\n"
						end
						gets.chomp
					else
						if player.disease.downcase == "theophobia"
							prettyPrint "You have a great fear of the gods! You won't go near the alter.", player.drunk
						else	
							prettyPrint "You try to interact with the altar again, but nothing seems to happen.", player.drunk
						end
						gets.chomp
					end
				when 8
					#launch pad
					prettyPrint "You could totally use this to launch that spaceship you don't have!", player.drunk
					gets.chomp
				when 9
					#pillar
					if !object.used && player.disease.downcase != "pillarphobia"
						if rand(4) > 0
							if @rooms[@currentRoom].enemies.length > 0
								prettyPrint "You knock the pillar over, sending it crashing down into a monster, driving the monster's body through the floor like a nail into wood.", player.drunk
								gets.chomp
								@rooms[@currentRoom].enemies.delete_at(rand(@rooms[@currentRoom].enemies.length))
							else
								prettyPrint "You topple the pillar, which makes a resounding, quaking crash into the ground.  Wanton destruction is fun!", player.drunk
								gets.chomp
							end
						else
							prettyPrint "You topple the pillar, but due to your lack of architectural instincts, the pillar you knocked over was load-bearing, and the ceiling comes down with it, crashing into everyone in the room as the room caves in.\n\n HP Down!", player.drunk
							gets.chomp
							caveindamage = rand(5) + 1
							player.health -= caveindamage
							@rooms[@currentRoom].enemies.each { |enemy|
								enemy.health -= caveindamage
							}
							index = @rooms[@currentRoom].items.length
							@rooms[@currentRoom].items.length.times {
								index -= 1
								if rand(2) == 1
									@rooms[@currentRoom].items.delete_at(index)
								end
							}
						end
					else
						if player.disease.downcase == "pillarphobia"
							prettyPrint "You tremble at the thought of touching the pillar!", player.drunk
						else
							prettyPrint "You've already toppled this pillar!", player.drunk
						end

						gets.chomp
					end
					object.used = true
				when 10
					#cot
					if !object.used && player.disease.downcase != "cot fever"
						prettyPrint "You use the cot to nap for a bit.  HP UP!", player.drunk
						gets.chomp
						player.health += 1
						if player.health > player.maxhealth + player.hat.effectAmt
							player.health = player.maxhealth + player.hat.effectAmt
						end
						object.used = true
					else
						if player.disease.downcase == "cot fever"
							prettyPrint "You see the cot and feel a rush of sickness come over you. You decide not to lay here. " + "Cot Fever".yellow.bold + " is real and you have it!\n", player.drunk
						else
							cotmessages = [
								"This cot has seen better days.  Like the day before you slept on it.",
								"Last time you slept here, you woke up with the worst pain in your neck.  There doesn't seem to be any way to sleep on it without that happening.",
								"You go to nap again, but you put your foot clear through the fabric trying to get into it.  Fatty.",
								"Yep, it's still a cot.",
								"You can't sleep here over and over again for game balance reasons- um, I mean, something pithy that explains this - um...  Cot... fever?  Yes.  Cot fever.  You are allergic to cots now.  Actually, just this specific one."
							]
							prettyPrint cotmessages[rand(cotmessages.length)], player.drunk
						end

						gets.chomp
					end
				when 11
					#piggy bank
					if !object.used
						randMoney = rand(10) + 1
						prettyPrint "You open the piggy bank and find " + randMoney.to_s + " monies.", player.drunk
						gets.chomp
						player.money += randMoney
					else
						prettyPrint "The piggy bank is empty.", player.drunk
						gets.chomp
					end
					object.used = true
				when 12
					#chalkboard
					prettyPrint "You can leave a message if you like:", player.drunk

					blockedWords = [
						"fuck",
						"ass",
						"cock",
						"damn",
						"shit",
						"bitch"
					]
					chalkboardText = gets.chomp
					blockedWords.each { |word|
						chalkboardText = chalkboardText.upcase.gsub(word.upcase, "****")
					}

					object.itemText = chalkboardText
				when 13
					#cradle
					if !object.used and rand(4) != 0
						if rand(2) == 1
							prettyPrint "You rob the cradle, but instead of finding a delicious baby, you find a weapon.", player.drunk
							gets.chomp
							@rooms[@currentRoom].items.push(Weapon.new(0,0,0,0,0,0,0))
						else
							prettyPrint "You rob the cradle, but instead of finding a delicious baby, you find a piece of armor.", player.drunk
							gets.chomp
							@rooms[@currentRoom].items.push(Armor.new(0,0,0,0,0))
						end
					else
						prettyPrint "You rifle through the swaddling clothes in the cradle, but don't find anything.", player.drunk
						gets.chomp
					end
					object.used = true
				when 14
					#stockade
					prettyPrint "What's with you trying to use this bondage stuff?  I mean, it is a dungeon, but seriously you're an adventurer.  You're not here to... wait, why ARE you here in the first place anyway?", player.drunk
					gets.chomp
					@useStockade = true
				when 15
					#hat rack
					if !object.used
						hatsToGen = rand(3) + 1
						prettyPrint "You shake the hat rack until all those hats fall off like juicy, plump ripe fruit.  Mmm, hats.\n\nYou found " + hatsToGen.to_s + " hats!", player.drunk
						gets.chomp
						hatsToGen.times {
							@rooms[@currentRoom].items.push(Hat.new(0, 0, 0, 0, 0))
						}
						object.used = true
					else
						prettyPrint "You already cleared this rack of hats.  It stands there dehatted, like a tree in winter or a bankrupt milliner.", player.drunk
						gets.chomp
					end
				when 16
					#chair
					if !object.used and rand(4) == 0
						prettyPrint "You open the drawers and find an item!", player.drunk
						@rooms[@currentRoom].items.push(Item.new)
					else
						prettyPrint "You rifle through the drawers in the desk, but don't find anything.", player.drunk
					end
					gets.chomp
					object.used = true
				when 17
					#desk
					prettyPrint "You have a seat for a bit.", player.drunk
					gets.chomp
				when 18
					#serving bowl
					prettyPrint "This serving bowl is crusted over with the remnants of whatever punch it used to hold.", player.drunk
					gets.chomp
				when 19
					#leg irons
					prettyPrint "Who are you going to put in those?  Yourself?  Why would you want to do that?  Do you get off on that kind of stuff?  Weirdo.", player.drunk
					gets.chomp
					@useLegIrons = true
				when 20
					#enchanted scroll
					if !object.used
						scrolltext = [
							"You lean in to read the glowing text on the scroll.  As you read, the words begin to form in your mind- I PREPARED EXPLOSIV- as the scroll explodes, knocking you backwards.\n\nHP Down!",
							"You trace your finger along the magic runes written on the scroll, watching them disappear as you read them, invoking the magic.  You recognize the runes for wealth, and suddenly your wallet feels a lot heavier.",
							"As you touch the scroll, you see red energy course around your arm and up towards your body, wreathing you in a brief sheath of sparking red before fading.  You find you feel healthier than you have before.\n\nMax HP Up!",
							"The scroll you read explains how you can swing harder when you don't care about not getting hurt.\n\nDefense Down, Offense Up!",
							"The scroll contains magnificent medical sketches and verbage about cures for rare diseases.\n\n You feel as if your body is cleansed!".green.bold
						]
						@scrollrand = rand(scrolltext.length)

						prettyPrint scrolltext[@scrollrand], player.drunk
						gets.chomp
						case @scrollrand
						when 0
							player.health -= 2
						when 1
							player.money = player.money * 2
						when 2
							player.maxhealth += (player.maxhealth/4).to_i
							if player.health > player.maxhealth + player.hat.effectAmt
								player.health = player.maxhealth + player.hat.effectAmt
							end
						when 3
							player.basedefense -= 2
							player.basedamage += 2
						when 4
							player.disease = "none"
						end
					else
						prettyPrint "The scroll is blank, the magic already having been released.", player.drunk 
						gets.chomp
					end
					object.used = true
				when 21
					#dinner bell
					if !object.used
						object.used = true
						if rand(2) == 1
							prettyPrint "You ring the dinner bell, and some monsters come to check out what's for dinner - guess what?  It's you!", player.drunk
							gets.chomp
							(rand(3) + 1).times {
								@rooms[@currentRoom].enemies.push(Enemy.new)
							}
							@lastRoom = -1
						else
							prettyPrint "You ring the dinner bell, and a matronly woman shows up to bring you a snack, warning you not to fill up on junk food before dinner.\n\nItem!", player.drunk
							gets.chomp
							@rooms[@currentRoom].items.push(Item.new)
						end
					else
						prettyPrint "You ring the dinner bell, but no one seems to respond to it as it echoes off the walls.", player.drunk
						gets.chomp
					end
				when 22
					#pot
					prettyPrint "It looks like a pot used for cooking.", player.drunk
					gets.chomp
				when 23
					#children's toy
					prettyPrint "You play with the toy for a while.  It makes you feel a little bit better.", player.drunk
					gets.chomp
				when 24
					#map
					if object.itemText == ""
						mapdesc = "You peer over the map, reviewing the rooms that you've been to.\nThe "
						@rooms.each_with_index { |room, i|
							mapdesc += room.name + " is connected to the "
							room.doors.each_with_index { |door, k|
								if k != 0 and k != room.doors.length - 1
									mapdesc += ", the "
								end
								if k != 0 and k == room.doors.length - 1
									mapdesc += ", and the "
								end
								doorObject = @doors[door]
								if doorObject.roomOne == i
									if doorObject.roomTwo == -1
										mapdesc += "???"
									else
										mapdesc += @rooms[doorObject.roomTwo].name
									end
								else
									if doorObject.roomOne == -1
										mapdesc += "???"
									else
										mapdesc += @rooms[doorObject.roomOne].name
									end
								end
	 						}
	 						mapdesc += "\n"
	 						if i != @rooms.length - 1
	 							mapdesc += "The "
	 						end
						}
						object.itemText = mapdesc
					end
					prettyPrint object.itemText, player.drunk
					gets.chomp
				when 25
					#weapon rack
					if !object.used
						object.used = true
						weaponsToGen = rand(2) + 1
						prettyPrint "You rifle through the weapon rack and dump all the weapons you find on the ground.\n\nYou found " + weaponsToGen.to_s + " weapons!", player.drunk
						gets.chomp
						weaponsToGen.times {
							@rooms[@currentRoom].items.push(Weapon.new(0,0,0,0,0,0,0))
						}
					else
						prettyPrint "You've already ransacked this weapon rack.", player.drunk
					end
				when 26
					#window
					if object.itemText == ""
						windowdesc = [
							"You look out the window to see a goat grazing lazily on some weeds outside.",
							"The window looks out onto another room, full of beanbags and children ogres.",
							"You peer into the tiny window at the base of the wall, and you see some goblins smoking something from a communal pipe.",
							"You peer into the hazy window, and see some shadowy figure on the other side slink away through a door.",
							"You see the g-man, who leaves through a door shortly.",
							"You see the dungeon's buggery, complete with mahogany bending rail.",
							"You see a bunch of people fighting in the war room.",
							"You see a mad scientist trying to bring a corpse back to life.",
							"You see a bird feeding a person in a cage.",
							"You look through and see an orc and a pie in a 10 by 10 foot room.",
							"You peer through the window and see a very orky christmas.",
							"Two groups of monsters having a game of bloodbowl."
						]
						object.itemText = windowdesc[rand(windowdesc.length)]
					end
					prettyPrint object.itemText, player.drunk
					gets.chomp
				when 27
					#loose floorplate
					if !object.used and rand(4) > 0
						prettyPrint "You move the floorplate and find a rune etched on the ground beneath.  You reach out to touch it, and when you look up, you're no longer in the same room.", player.drunk
						gets.chomp

						newRoomDoors = Array.new

						(rand(3) + 1).times {
							newdoor = Door.new(@rooms.length)
							@doors.push(newdoor)
							newRoomDoors.push(newdoor.doorNumber) # length minus one?
						}

						@rooms.push(Room.new(newRoomDoors))
						@lastRoom = @currentRoom
						@currentRoom = @rooms.length - 1 #length minus one?
					else
						prettyPrint "You look under the floor tile, but it's just dirt and rocks.", player.drunk
						gets.chomp
					end
					object.used = true
				when 28
					#epitaph
					if !object.used and object.epitaphmonster then
						prettyPrint "You touch the epitaph, and summon the spirit of the person who died here.  Roused from their apparantly not-so-eternal slumber, they prepare to meet you in combat!", player.drunk
						gets.chomp
						object.used = true
						deadplayer = Enemy.new
						deadplayer.maxhealth = object.epitaphmaxhealth
						deadplayer.damage = object.epitaphdamage
						deadplayer.defense = object.epitaphdefense
						deadplayer.name = (object.epitaphname += " ").strip
						deadplayer.money = object.epitaphmoney
						deadplayer.evilPhrase = object.epitaphmotto
						@rooms[@currentRoom].enemies.push(deadplayer)
					else
						print "The dusty tombstone lies inert.\n"
						gets.chomp
					end
				when 29
					#Med-Pod
					if !object.used
						healingString = ""
						player.bodyParts.each { |part, value|
							value.each { |attribute|
								if attribute[1] < 3
									attribute[1] = 3
									healingString += "Your ".green.bold + attribute[0].cyan.bold + " has been healed! ".green.bold
									player.blind = false
									player.stance = "standing"
									player.vomitting = false
									player.bleedAmt = 0
									player.muted = false
									player.paralyzed = false
									player.legsCrippled = false
									player.armsCrippled = false
									player.statusEffects = ""
								end
							}
						}
						player.health += ((player.maxhealth) * 0.2).to_i
						if player.health > player.maxhealth
							player.health = player.maxhealth
						end
						object.used = true
						healingString += " Your body has been completely restored! \n".green.bold
						prettyPrint healingString, player.drunk
						gets.chomp
					else
						print "The Med-Pod, with its light flickering and waning, appears to be out of power.\n".red.bold
						gets.chomp
					end
				when 30
					#explosive barrel
					if !object.used
						effectNum = rand(1..3)
						case effectNum
						when 1
							prettyPrint "You smash the barrel and watch it explode in all its manly glory!".white.bold + "The explosion uncovered a walled up door!".white.bold, player.drunk
							gets.chomp
							newDoor = Door.new(@currentRoom)
							@doors.push(newDoor)
							@rooms[@currentRoom].doors.push(newDoor.doorNumber)
						when 2
							if @rooms[@currentRoom].enemies.length > 0
								prettyPrint "You smash the barrel! The explosion shakes the room and blows all the enemies away in the room!\n".green.bold, player.drunk
								gets.chomp
								@rooms[@currentRoom].enemies.each { |roomEnemy| print "The ".white.bold + roomEnemy.type.white.bold + "disintegrates!".white.bold } 
								@rooms[@currentRoom].enemies.clear()
							else
								prettyPrint "The smash the barrel! The whole room rumbles from the explosion!".white.bold, player.drunk
								gets.chomp
							end
						when 3
							prettyPrint "You smash the barrel and it explodes in your face! You are blown back and lost half of your health!\n".red.bold, player.drunk
							player.health = (player.health/2).to_i
							
							if player.health <= 0
								player.health = 0
							end

							gets.chomp
						end

						@rooms[@currentRoom].objects.delete_at(objectNumberInRoom)
					end
				when 31
					#Item Vending Machine
					if player.money >= 35
						prettyPrint "You insert $".white.bold + "35".green.bold + " into the vending machine\n", player.drunk
						prettyPrint "An item has popped out!".green.bold, player.drunk
						player.money -= 35
						@rooms[@currentRoom].items.push(Item.new)
						gets.chomp
					else
						prettyPrint "You don't have enough cash! It takes $".white.bold + "35".green.bold + "!\n", player.drunk
						gets.chomp
					end
				when 32, 33
					#Weapon Vending Machines
					if player.money >= 120
						prettyPrint "You insert $".white.bold + "120".green.bold + " into the weapon vending machine\n".white.bold, player.drunk
						prettyPrint "A weapon has popped out!".green.bold, player.drunk
						player.money -= 120

						if object.objectIndex == 32 #ranged weapons machine
							@rooms[@currentRoom].items.push(Weapon.new(2,5,0,4,0,1,0))
						else #melee weapons
							@rooms[@currentRoom].items.push(Weapon.new(1,5,0,5,0,1,0))
						end

						gets.chomp
					else
						prettyPrint "You don't have enough cash to buy a weapon! It takes $".white.bold + "120".green.bold + "!\n", player.drunk
						gets.chomp
					end
				when 34
					#Armor Vending Machine 
					if player.money >= 100
						prettyPrint "You insert $".white.bold + "100".green.bold + " into the armor vending machine\n".white.bold, player.drunk
						prettyPrint "A piece of armor has popped out!".green.bold, player.drunk
						player.money -= 100
						@rooms[@currentRoom].items.push(Armor.new(0,6,0,6,0))
						gets.chomp
					else
						prettyPrint "You don't have enough cash to buy a piece of armor! It takes $".white.bold + "100".green.bold + "!\n", player.drunk
						gets.chomp
					end
				end
			else
				print "Can't use that!"
				gets.chomp
			end
		else
			print "Can't find item!"
			gets.chomp
		end
		if @useLegIrons and @useChains and @useStockade and !player.titles.include? ", the pervert"
			player.titles += ", the pervert"
		end
	end
	def OpenObject(object)
		begin 
			if @rooms[@currentRoom].objects.length > 0 && object[0] <= @rooms[@currentRoom].objects.length - 1
				item = @rooms[@currentRoom].objects[object]
				if item.actions.any? { |action| action = "open" } && item.typeName == "chest"
					@rooms[@currentRoom].objects.delete_at(object)
					randomitems = rand(3) + 1
					print "Found " + randomitems.to_s + " items!"
					gets.chomp
					randomitems.times { |i|
						if i % 3 == 0
							@rooms[@currentRoom].items.push(Item.new)
						elsif i % 3 == 1
							@rooms[@currentRoom].items.push(Weapon.new(0,0,0,0,0,0,0))
						elsif i % 3 == 2
							@rooms[@currentRoom].items.push(Armor.new(0,0,0,0,0))
						end
					}
				else
					print "Can't Open This!"
				end
			else
				print "You can't open this!"
				gets.chomp
			end
		rescue
			print "You can't open this!".red.bold
			gets.chomp
		end
	end
	def lastDoor
		@rooms[@currentRoom].doors.each_with_index { |door, i| 
			if @doors[door].Go(@currentRoom) == @lastRoom
				return i
			end
		}
		return "-1"
	end
	def handleDeath(player)
		
		timeOfDeath = Time.new
		deathString = ("You have succumbed to the horrors of the " + @dungeonName + ".").white.bold

		if player.paralyzed || player.legsCrippled
			deathString += "You lay on your back looking up at the ceiling as the last breaths leave your body. ".white.bold
		end

		if !player.muted
			deathString += "Your lips begin to tremble as you cry out your last dying words....What are those words?\n\n".white.bold
			prettyPrint(deathString, false)
			deathPhrase = gets.chomp
			
		else
			deathString += "Your lips begin to tremble as you try to cry out but you can't speak...You die in silence...\n\n".white.bold
			prettyPrint(deathString, false)
			deathPhrase = "Silence"
		end
	
		dateOfDeath = timeOfDeath.month.to_s + "/" + timeOfDeath.day.to_s + "/" + timeOfDeath.year.to_s
		
		blockedWords = [
			"fuck",
			"ass",
			"cock",
			"damn",
			"shit",
			"bitch"
		]

		blockedWords.each { |word|
			deathPhrase = deathPhrase.upcase.gsub(word.upcase, "****")
		}

		begin
			File.open(File.expand_path("..\\graveyard.txt", __FILE__), "a") { |file| file.write(player.name + " " + player.titles + "~" + deathPhrase.tr('~','') + "~" + dateOfDeath + "~" + (player.maxhealth.to_i + player.hat.effectAmt.to_i).to_s + "~" + (player.hat.damage.to_i + player.basedamage.to_i + player.weapon.damage.to_i).to_s + "~" + (player.hat.defense.to_i + player.armor.defense.to_i + player.basedefense.to_i).to_s + "~" + player.money.to_s + "~" + player.weapon.attack.to_s + "~" + player.motto + "\n") }
		rescue
			#no need to rescue - let it die very very quietly
		end

	end
	def handleClassSelection(player)
		
		classSelected = false

		while !classSelected
			
			system ("cls")
			print "What are you, " + player.name + "?\n\n"
			#print "Choose your Class:\n\n"
			print "(1) [Adventurer] -Balanced Start.\n\n"
			print "(2) [Roid Rager] - Low HP, High Attack.\n\n"
			print "(3) [Berzerker] - High Attack, Low Defense.\n\n"
			print "(4) [Skirmisher] - High Defense, Low HP.\n\n"
			print "(5) [Monk] - High Defense, Low Attack.\n\n"
			print "What will it be?\n"

			classChoice = gets.chomp
			effectAmount = 10
			healthEffect = 15

			case classChoice.downcase
			when "1", "adventurer"
				player.classType = "Adventurer"
				classSelected = true
			when "2", "roidrager", "roid rager"
				player.classType = "Roidrager"
				player.maxhealth -= healthEffect
				player.health = player.maxhealth
				player.basedamage += effectAmount
				classSelected = true
			when "3", "berzerker"
				player.classType = "Berzerker"
				player.basedamage += effectAmount
				player.basedefense -= effectAmount
				classSelected = true
			when "4", "skirmisher"
				player.classType = "Skirmisher"
				player.basedefense += effectAmount
				player.maxhealth -= healthEffect
				player.health = player.maxhealth
				classSelected = true
			when "5", "monk"
				player.classType = "Monk"
				player.basedefense += effectAmount
				player.basedamage -= effectAmount
				if player.basedamage <= 0
					player.basedamage = 0
				end
				classSelected = true
			end

		end

	end
	def generateDungeonName()
		prefixes = [
			"Tower",
			"Dungeon",
			"Keep",
			"Castle",
			"Laboratory",
			"Abyss",
			"Apartment Complex"
		]
		suffixes = [
			"Love",
			"Hatred",
			"Dangly Lightbulbs",
			"Meat",
			"Televisions",
			"Rope",
			"Meatloaf",
			"Guacamole",
			"Tacos",
			"Candy",
			"Fog",
			"Frogs",
			"Dreams",
			"Aspirations",
			"Imagination",
			"Sin",
			"Ear Wax",
			"Row Boats",
			"Blood",
			"Gore",
			"Corpses",
			"Taints",
			"Reproductive Organs"
		]
		descriptors = [
			"Rancid",
			"Fluffy",
			"Crummy",
			"Stretchy",
			"Lost",
			"Dark",
			"Colorless",
			"Pathetic",
			"Glowing",
			"Unholy",
			"Rusted",
			"Rotting",
			"Crusted",
			"Severed"
		]
		return "the " + prefixes[rand(prefixes.length)] + " of " + descriptors[rand(descriptors.length)] + " " + suffixes[rand(suffixes.length)] 
	end
	def generateQuestItem
		prefixes = [
			"Chalice",
			"Crown",
			"Orb",
			"Billygoat",
			"Torch",
			"Sword",
			"Football",
			"Ring",
			"Necklace",
			"Bracelet",
			"Anklet",
			"Sportsuit",
			"Tuxedo",
			"Pill",
			"Video Game Console",
			"Journal",
			"Spellbook",
			"Guitar",
			"Flute",
			"Ceremonial Dagger",
			"Bra",
			"Jockstrap",
			"Ex-lax",
			"DVD"
		]
		suffixes = [
			"Good",
			"Evil",
			"Badness",
			"Blackness",
			"Whiskey",
			"Wizardry",
			"Drunkeness"
		]
		descriptors = [
			"Total",
			"Genuine",
			"Questionable",
			"Caucasian",
			"Lost",
			"Black",
			"Dark",
			"Angelic",
			"Arcane",
			"Divine",
			"Unholy",
			"Golfing",
			"Surprisingly Excessive",
			"Built-in"
		]

		objectDesc = "the " + prefixes[rand(prefixes.length)] + " of " + descriptors[rand(descriptors.length)] + " " + suffixes[rand(suffixes.length)]
		@questItem.effect = "win"
		@questItem.effectAmt = 1
		@questItem.fullName = objectDesc

		return objectDesc
	end
	def drawMainMenu()
		
		#print "          =============================================== \n".blue.bold
		#print "	   ######### #########     ########     ######### \n".white.bold
		#print "	  ###    ### ###   ####   ###    ###   ###    ### \n".white.bold
		#print "	  ###    ##  ###    ###   ###    ##    ###     #  \n"
		#print "	 #######     ###    ###  ####         #######     \n"
		#print "	########     ###    ### ##### #####  ########     \n"
		#print "	  ###    ##  ###    ###   ###    ###   ###    ##  \n"
		#print "	  ###    ### ###   ####   ###    ###   ###    ### \n".white.bold
		#print "	  ########## #########    #########    ########## \n".white
		#print "          =============================================== \n".blue.bold

		print "           _____                                             _____   \n".red
		print "      _____\\    \\ ____________           _____          _____\\    \\  \n".red.bold
		print "     /    / |    |\\           \\     _____\\    \\_       /    / |    | \n".red.bold
		print "    /    /  /___/| \\           \\   /     /|     |     /    /  /___/| \n".white.bold
		print "   |    |__ |___|/  |    /\\     | /     / /____/|    |    |__ |___|/ \n"
		print "   |       \\        |   |  |    ||     | |_____|/    |       \\       \n".white.bold
		print "   |     __/ __     |    \\/     ||     | |_________  |     __/ __    \n"
		print "   |\\    \\  /  \\   /           /||\\     \\|\\        \\ |\\    \\  /  \\   \n"
		print "   | \\____\\/    | /___________/ || \\_____\\|    |\\__/|| \\____\\/    |  \n"
		print "   | |    |____/||           | / | |     /____/| | ||| |    |____/|  \n"
		print "    \\|____|   | ||___________|/   \\|_____|     |\\|_|/ \\|____|   | |  \n".red
		print "          |___|/                         |____/             |___|/  \n".red
		print "\t     Expanding Dungeons Generated Experimentally\n\n\n".white.bold
		#print " \t\t\t[A Janky Production]\n\n\n".white.bold
		print " \t\t\t  (1) Start Game\n".white.bold
		print " \t\t\t  (2) Quit Game\n\n".white.bold
	end
	attr_accessor :doors
	attr_accessor :rooms
	attr_accessor :currentRoom
	attr_accessor :questItem
	attr_accessor :player
end
