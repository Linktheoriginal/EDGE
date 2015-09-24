class Door
	@@numberOfDoors = 0
	@@doorDescriptions = [
		"A sturdy wooden door in a plain wooden frame.  The knob is dusty and cold to the touch.",
		"A door that's misshapen and looks straight out of an art installation.",
		"A door intricately carved with questionable scenes.",
		"An iron grate.  Portcullis, even.",
		"A mousehole of unusual size.",
		"A wibbly wobbly timey wimey portal.",
		"A transporter plate.",
		"A rotating glass door."
	]
	def initialize (roomNumber)
		@roomOne = roomNumber
		@roomTwo = -1
		@descriptionType = rand(@@doorDescriptions.length)
		@description = @@doorDescriptions.at(@descriptionType)
		@doorNumber = @@numberOfDoors
		@@numberOfDoors += 1
	end
	def describe
		return @description
	end
	def Go(fromRoom)
		if fromRoom == @roomOne
			return @roomTwo
		elsif fromRoom == @roomTwo
			return @roomOne
		else
			#print "WTF DID YOU TELEPORT"
			return @roomOne
		end
	end
	attr_accessor :roomOne
	attr_accessor :roomTwo
	attr_accessor :description
	attr_accessor :doorNumber
	attr_accessor :descriptionType
end