require_relative 'Color'
require_relative 'Room'
require_relative 'DungeonObject'
require_relative 'Enemy'
require_relative 'Door'
require_relative 'GameFunctions'
require_relative 'Player'
require_relative 'Combat'
require_relative 'Weapon'

lookupHash = {
		"a" => 0,
		"b" => 1,
		"c" => 2,
		"d" => 3,
		"e" => 4,
		"f" => 5,
		"g" => 6,
		"h" => 7,
		"i" => 8,
		"j" => 9,
		"k" => 10,
		"l" => 11,
		"m" => 12,
		"n" => 13,
		"o" => 14,
		"p" => 15,
		"q" => 16,
		"r" => 17,
		"s" => 18,
		"t" => 19,
		"u" => 20,
		"v" => 21,
		"w" => 22,
		"x" => 23,
		"y" => 24,
		"z" => 25 
	}

gf = GameFunctions.new
player = Player.new
combat = Combat.new
endgame = gf.StartGame(player)
viewInventory = false
while !endgame
	runUpdate = true
	clearScreen = true

	answer = gets.chomp
	answerWordArray = answer.split
	action = ""

	if answerWordArray.length > 0
		action = answerWordArray[0]
	else 
		action = "look"
	end

	case action
		when "help"
			print "\nGame Actions:\n go <# door>\n look\n use <letter or # in room>\n attack <# enemy>\n examine <# of enemy>\n open <# object in room>\n equip <number in room>\n status\n\nSystem Actions:\n help\n exit\n\n"
			runUpdate = false
			clearScreen = false
		when "r", "return"
			viewInventory = false
		when "i", "inventory"
			viewInventory = true
		when "take"
			if answerWordArray.length > 1
				object = answerWordArray[1]
				if numeric?(object)
					if object.to_i < gf.rooms[gf.currentRoom].items.length
						item = gf.rooms[gf.currentRoom].items[object.to_i]
						if item.objectType == "item"
							player.inventory.items.push(gf.rooms[gf.currentRoom].items[object.to_i])
							gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
						elsif item.objectType == "weapon"
							if player.inventory.weapon.nil?
								player.inventory.weapon = gf.rooms[gf.currentRoom].items[object.to_i]
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							else
								gf.rooms[gf.currentRoom].items.push(player.inventory.weapon)
								player.inventory.weapon = gf.rooms[gf.currentRoom].items[object.to_i]
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							end
						elsif item.objectType == "hat"
							if player.inventory.hat.nil?
								player.inventory.hat = gf.rooms[gf.currentRoom].items[object.to_i]
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							else
								gf.rooms[gf.currentRoom].items.push(player.inventory.hat)
								player.inventory.hat = gf.rooms[gf.currentRoom].items[object.to_i]
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							end
						elsif item.objectType == "armor"
							if player.inventory.armor.nil?
								player.inventory.armor = gf.rooms[gf.currentRoom].items[object.to_i]
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							else
								gf.rooms[gf.currentRoom].items.push(player.inventory.armor)
								player.inventory.armor = gf.rooms[gf.currentRoom].items[object.to_i]
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							end
						else
							print "Can't take this!"
							runUpdate = false
							clearScreen = false
						end
					else
						print "Take what?"
						runUpdate = false
						clearScreen = false
					end
				else
					print "Take what?"
					runUpdate = false
					clearScreen = false
				end
			else
				print "Take what?"
				runUpdate = false
				clearScreen = false
			end
		when "exit"
			endgame = true
			runUpdate = false
		when "go"
			if answerWordArray.length > 1
				openDoor = answerWordArray[1]
				if openDoor.to_i == 0 and !(openDoor.downcase == 'zero' or openDoor == '0')
					print "Go through which number door?\n"
					runUpdate = false
					clearScreen = false
				else
					gf.Go(openDoor.to_i)
				end
			else
				print "Go where?"
				runUpdate = false
				clearScreen = false
			end
		when "use"
			if answerWordArray.length > 1
				object = answerWordArray[1]

				if viewInventory
					if numeric?(object)
						if object.to_i < player.inventory.items.length
							item = player.inventory.items[object.to_i]
							player.inventory.items.delete_at(object.to_i)
							endgame = gf.UseItem(player, item)
						else
							print "Use what?"
							gets.chomp
						end
					else
						print "Use what?"
						gets.chomp
					end
				else
					if object == "spaghetti"
						player.poison = true
						player.poisontimer = 3
						gf.prettyPrint("You eat the floor spaghetti and start to feel really sick.  Like, really sick.  You're not sure that was spaghetti.", player.drunk)
						gets.chomp
					elsif numeric?(object)
						if object.to_i < gf.rooms[gf.currentRoom].items.length
							item = gf.rooms[gf.currentRoom].items[object.to_i]
							if item.objectType == "item"
								endgame = gf.UseItem(player, item)
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							else
								print "Can't use this!"
								runUpdate = false
								clearScreen = false
							end
						else
							print "Use what?"
							runUpdate = false
							clearScreen = false
						end
					elsif numeric?(lookupHash[object])
						if object.to_i < gf.rooms[gf.currentRoom].objects.length
							item = gf.rooms[gf.currentRoom].objects[object.to_i]
							gf.UseObject(player, lookupHash[object])
						else
							print "Use what?"
							runUpdate = false
							clearScreen = false
						end
					else
						print "Use what?"
						runUpdate = false
						clearScreen = false
					end
				end
			else 
				print "Use what?"
				runUpdate = false
				clearScreen = false
			end
		when "attack"
			if answerWordArray.length > 1
				enemy = answerWordArray[1]
				if enemy.to_i >= gf.rooms[gf.currentRoom].enemies.length || (enemy.to_i <= 0 && gf.rooms[gf.currentRoom].enemies.length == 0)
					print "Can't find that enemy!"
					gets.chomp
				else
					enemyObject = gf.rooms[gf.currentRoom].enemies[enemy.to_i]
					dropItems = false

					if enemyObject.health.to_i > 0
						dropItems = true
					end
					gf.prettyPrint(combat.doCombat(player, enemyObject, true) + "\n\n", player.drunk)
	
					if dropItems and enemyObject.health <= 0
						print "The enemy dropped an item!\n ".yellow.bold +  "You got ".green.bold + enemyObject.money.to_s.white.bold + " monies!".green.bold
						player.money += enemyObject.money
						if enemyObject.type == "Dungeon Keeper"
							gf.rooms[gf.currentRoom].items.push(gf.questItem)
						else
							gf.rooms[gf.currentRoom].items.push(Item.new)
						end
					end
				end
				clearScreen = false
				runUpdate = false
			else
				print "What are you trying to attack?"
				runUpdate = false
				clearScreen = false
			end
		when "examine"
			if answerWordArray.length > 1
				enemy = answerWordArray[1]
				if enemy.to_i >= gf.rooms[gf.currentRoom].enemies.length || (enemy.to_i <= 0 && gf.rooms[gf.currentRoom].enemies.length == 0)
					print "Can't find that enemy!"
					gets.chomp
				else
					enemyObject = gf.rooms[gf.currentRoom].enemies[enemy.to_i]
					system ("cls")
					gf.prettyPrint(enemyObject.detailStatus() + "\n\nPress [Enter] to continue", player.drunk)
				end
				clearScreen = false
				runUpdate = false
			else
				print "What are you trying to examine?"
				runUpdate = false
				clearScreen = false
			end
		when "open"
			if answerWordArray.length > 1
				object = answerWordArray[1]
				if !numeric?(object) 
					gf.OpenObject(lookupHash[object])
				else
					print "Open what?"
					gets.chomp
				end
			else
				print "Open what?"
				gets.chomp
			end
		when "equip"
			if answerWordArray.length > 1
				object = answerWordArray[1]

				if viewInventory
					if object.downcase == "a" and !player.inventory.weapon.nil?
						#weapon
						temp = player.weapon
						player.weapon = player.inventory.weapon
						player.inventory.weapon = temp
					elsif object.downcase == "b" and !player.inventory.armor.nil?
						#armor
						temp = player.armor
						player.armor = player.inventory.armor
						player.inventory.armor = temp
					elsif object.downcase == "c" and !player.inventory.hat.nil?
						#hat
						temp = player.hat
						player.hat = player.inventory.hat
						player.inventory.hat = temp
					else
						print "Equip what?"
						gets.chomp
					end
				else
					if object.to_i < gf.rooms[gf.currentRoom].items.length
						equippableobject = gf.rooms[gf.currentRoom].items[object.to_i]
						if player.disease.downcase != "butterfingers"
							if equippableobject.objectType == "armor"
								gf.rooms[gf.currentRoom].items.push(player.armor)
								player.armor = equippableobject
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							elsif equippableobject.objectType == "weapon"
								gf.rooms[gf.currentRoom].items.push(player.weapon)
								player.weapon = equippableobject
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							elsif equippableobject.objectType == "hat"
								gf.rooms[gf.currentRoom].items.push(player.hat)
								player.hat = equippableobject
								gf.rooms[gf.currentRoom].items.delete_at(object.to_i)
							else
								print "Unable to equip item."
								gets.chomp
							end
						else
							gf.prettyPrint "Your disease of " + "Butterfingers".yellow.bold + " prevents you from picking that up!\n", player.drunk
							gets.chomp
						end
					else
						print "Equip what?"
						runUpdate = false
						clearScreen = false
					end
				end
			else
				print "Equip what?"
				runUpdate = false
				clearScreen = false
			end
		when "status"
			system("cls")
			clearScreen = false
			print player.GetStatus
			print "\n\nWhat do you do?"
			runUpdate = false
		when "look"
			#do nothing
		when "suicide", "commit sudoku"
			player.health = 0 
			system ("cls")
			runUpdate = false
			clearScreen = false
		when "check"
			if answerWordArray.length > 1
				openDoor = answerWordArray[1]
				if openDoor.to_i == 0 and !(openDoor.downcase == 'zero' or openDoor == '0')
					print "Go through which number door?\n"
					runUpdate = false
					clearScreen = false
				else
					gf.Go(openDoor.to_i, answerWordArray[2])
				end
			else
				print "Go where?"
				runUpdate = false
				clearScreen = false
			end
		else
			print "Wha huh?  Use 'help' if you don't know the commands."
			runUpdate = false
			clearScreen = false
	end
	
	if viewInventory
		system("cls")
		gf.prettyPrint player.inventory.describe, player.drunk
		runUpdate = false
		clearScreen = false
	end

	if clearScreen
		system("cls")
	end

	if player.health <= 0
		endgame = true
		gf.handleDeath(player)
		gets.chomp
	end

	if runUpdate
		room = gf.rooms[gf.currentRoom]
		player.Update

		gf.prettyPrint(room.describe(gf.doors, gf.lastDoor) + "\nWhat do you do?\n", player.drunk)
	end
end
system ("cls")
print "Thank you for playing."