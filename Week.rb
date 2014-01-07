class Week
	attr_accessor :week, :opp, :goals, :kc, :start, :sub, :yc, :rc, :miss, :saved, :og, :conc, :csf, :csp, :pts

	def initialize(week, opp, goals, kc, start, sub, yc, rc, miss, saved, og, conc, csf, csp, pts)
		@week = week
		@opp = opp
		@goals = goals
		@kc = kc
		@start = start
		@sub = sub
		@yc = yc
		@rc = rc
		@miss = miss
		@saved = saved
		@og = og
		@conc = conc
		@csf = csf
		@csp = csp
		@pts = pts
	end

	def to_s
		"Week: {week:#@week, opposition:#@opp, goals:#@goals, key contrib:#@kc, start:#@start, sub:#@sub, yellow:#@yc red:#@rc miss pen:#@miss saved pen:#@saved OG:#@og conceeded:#@conc part cs:#@csp cs:#@csf points:#@pts}"	
	end
end