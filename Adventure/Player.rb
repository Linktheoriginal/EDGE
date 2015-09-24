require_relative 'Weapon'
require_relative 'Color'
require_relative 'Inventory'

class Player
	def initialize
		@name = ""
		@drunk = false
		@hat = "Bald Head"
		@weapon = Weapon.new(-1,0,0,0,0,0,0)
		@basedamage = 5
		@weapondamage = 0
		@regen = false
		@poison = false
		@maxhealth = 50
		@health = 50
		@basedefense = 5
		@armor = Armor.new(-1, 0, 0, 0, 0)
		@drunktimer = 0
		@poisontimer = 0
		@hat = Hat.new(-1, 0, 0, 0, 0)
		@titles = ""
		@money = 0
		@kills = 0

		@totalDefense = (@basedefense + @armor.defense + @hat.defense)
		@motto = ""
		@inventory = Inventory.new

		#combat traits
		@blind = false
		@stance = "standing"
		@vomitting = false
		@bleedAmt = 0
		@muted = false
		@paralyzed = false
		@legsCrippled = false
		@armsCrippled = false
		@statusEffects = ""
		@disease = ""

		initializeBodyParts()
	end
	def Update
		if @regentimer == 0
			regen = false
		end
		if @regen
			@health += 1
			@regentimer -= 1
		end
		if @poisontimer == 0
			@poison = false
		end
		if @poison
			@health -= 1
			@poisontimer -= 1
		end
		if @drunktimer <= 0
			@drunk = false
		end
		if @drunk
			@drunktimer -= 1
		end

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
					["spine", 3, "healthy", :paralysis, :bone, 3]],
			:torso => [
					["ribs", 3, "healthy", :nothing, :bone], 
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
					["right foot", 3, "healthy", :nothing, :bone], 
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
					["left foot", 3, "healthy", :nothing, :bone], 
					["left ankle", 3, "healthy", :stance, :bone], 
					["left knee", 3, "healthy", :stance, :bone], 
					["left upper leg bone", 3, "healthy", :stance, :bone], 
					["left lower leg bone", 3, "healthy", :stance, :bone]]
		}
	end
	def UpdateStatusEffects()
		
		@statusEffects = ""

		if @health <= 0
			@statusEffects = " !DEAD! ".red.bold
		end

		if @legsCrippled 
			@statusEffects += " !LEGS CRIPPLED! ".magenta.bold
		end

		if @armsCrippled
			@statusEffects += " !ARMS CRIPPLED! ".magenta.bold
		end

		if @disease != "none" && @disease != ""
			@statusEffects += " !DISEASED! ".yellow.bold
		end

		if @bleedAmt > 0
			@statusEffects += " !BLEEDING! ".red.bold
		end

		if @blind 
			@statusEffects += " !BLIND! ".white.bold
		end

		if @muted
			@statusEffects += " !MUTED! ".white.bold
		end

		if @paralyzed 
			@statusEffects += " !PARALYZED! ".blue.bold
		end

		if @vomitting 
			@statusEffects += " !SICK! ".green.bold
		end

		if @poison
			@statusEffects += " !POISONED! ".green.bold
		end

	end
	def GetStatus

		UpdateStatusEffects()

		if @statusEffects == ""
			statusString = "Healthy".green.bold
		else 
			statusString = @statusEffects
		end

		return 	"\n==========[Stats]==========".white.bold + \
				"\nPlayer: ------- " + @name + @titles + \
				"\nClass: -------- " + @classType + \
				"\nHat: ---------- " + @hat.fullName.white.bold + \
				"\nArmor: -------- " + @armor.fullName.white.bold + \
				"\nDefense: ------ " + (@basedefense + @armor.defense + @hat.defense).to_s.blue.bold + \
				"\nWeapon: ------- " + @weapon.fullName.yellow.bold + \
				"\nDamage: ------- " + (@weapon.totalDamage + @basedamage + @hat.damage).to_s.blue.bold + \
				"\nMax Health: --- " + (@maxhealth + @hat.effectAmt).to_s + \
				"\nCurrent Health: " + @health.to_s + \
				"\nStatuses: ----- " + statusString + \
				"\nRegen Health: - " + @regen.to_s + \
				"\nDrunk: -------- " + @drunk.to_s + \
				"\nJank Level: --- MAXIMUM" + \
				"\nDiseases: ----- " + @disease.yellow.bold + \
				"\nKills: -------- " + @kills.to_s.red.bold + \
				"\nMoney: -------- " + "$".white.bold + " " + @money.to_s.green.bold + \
				"\nQuest: -------- " + @quest + \
				"\nMotto: -------- " + @motto + \
				weapon.getStats() + \
				getBodyStatus()
	end
	def getBodyStatus()
		bodyStatus = ""
		title = "\n\n=========[Body Condition]========\n".white.bold
		#Get body part damage descriptions
		@bodyParts.each { |part, value|
			value.each { |attribute|
				if attribute[1] < 3
					bodyStatus += "Your " + attribute[0].cyan.bold + " is " + attribute[2].red.bold + ". "
				end
			}
		}

		if bodyStatus == ""
			return ""
		else
			return title + bodyStatus
		end
	end
	
	attr_accessor :quest
	attr_accessor :basedefense
	attr_accessor :basedamage
	attr_accessor :drunktimer
	attr_accessor :health
	attr_accessor :maxhealth
	attr_accessor :armor
	attr_accessor :weapon
	attr_accessor :regen
	attr_accessor :weapondamage
	attr_accessor :basedamage
	attr_accessor :hat
	attr_accessor :drunk
	attr_accessor :name
	attr_accessor :poison
	attr_accessor :poisontimer
	attr_accessor :regentimer
	attr_accessor :titles
	attr_accessor :money
	attr_accessor :classType
	attr_accessor :disease
	attr_accessor :bodyParts
	attr_accessor :stance
	attr_accessor :vomitting
	attr_accessor :totalDefense
	attr_accessor :kills
	attr_accessor :blind
	attr_accessor :bleedAmt
	attr_accessor :muted
	attr_accessor :paralyzed
	attr_accessor :legsCrippled
	attr_accessor :armsCrippled
	attr_accessor :statusEffects
	attr_accessor :motto
	attr_accessor :inventory
end