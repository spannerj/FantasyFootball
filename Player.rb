class Player
	@@count = 0
	attr_accessor :id, :name, :team, :value, :position, :link, :weeks

	def initialize(id = nil, name = nil, team = nil, value = nil, position = nil, link = nil,  weeks = [])
		@id = id
		@name = name
		@team = team
		@value = value
		@position = position
		@link = link
		@weeks = weeks

		@@count += 1
	end

	def to_s
		"Player: {id:#@id, name:#@name, team:#@team, value:#@value, position:#@position, link:#@link weeks:#@weeks"	
	end

	def self.count  
	  @@count  
	end  	
end
