require 'open-uri'
require 'openssl'
require 'nokogiri'
require 'pg'
require_relative 'Player'
require_relative 'Week'

#init variables
name,team, value, position, id = ''

s = Time.now
puts s

allPage = Nokogiri::HTML(open('https://fantasyfootball.telegraph.co.uk/premierleague/PLAYERS/all', {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))

$conn = PGconn.connect('localhost', '5432', '', '', 'lrff', 'postgres', '')

pArray = allPage.xpath('/html/body/div/div[2]/div/div/div/table/tbody/tr/td[1]/a/@href')#.each do |l|

begin

	#for i in 0..9 do #res.count-1 do
	for i in 0..pArray.count-1 do	
		link = pArray[i]
		id = link.to_s[-4,4]

		fi = open(link, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read

		File.open('temp.txt', 'w') { |file| file.write(fi) } 
		page = Nokogiri::HTML(fi)

		name = page.xpath('//*[@id="stats-name"]/text()')
		team = page.xpath('//*[@id="stats-team"]/text()')
		value = page.xpath('//*[@id="stats-value"]/text()')
		position = page.xpath('//*[@id="stats-position"]/text()')

		player = Player.new(id, name, team, value, position, link)

		begin
			$conn.exec_params("insert into players
							(player_id, player_name, team, player_value, player_position, player_link) 
							values ($1, $2, $3, $4, $5, $6); ", 
							[ id, name, team, value, position, link ])
		rescue PG::Error  => err
	  		puts err
	  		puts player
		end

		page.xpath('//*[@id="inner-container"]/div[1]/div/table/tbody/tr').each do |sc|
			week, opp, goals, kc, start, sub, yc, rc, miss, saved, conc, csf, csp, og, pts = ''

			week  = sc.xpath('td[1]/text()')
			opp   = sc.xpath('td[2]/text()')
			goals = sc.xpath('td[3]/text()')
			kc    = sc.xpath('td[4]/text()')
			start = sc.xpath('td[5]/text()')
			sub   = sc.xpath('td[6]/text()')
			yc    = sc.xpath('td[7]/text()')
			rc    = sc.xpath('td[8]/text()')
			miss  = sc.xpath('td[9]/text()')

			case player.position.text
			when 'Goalkeeper'
				saved = sc.xpath('td[10]/text()')
				og    = sc.xpath('td[11]/text()')
				conc  = sc.xpath('td[12]/text()')
				csf   = sc.xpath('td[13]/text()')
				csp   = sc.xpath('td[14]/text()')
				pts   = sc.xpath('td[15]/text()')
			when 'Defender'
				og    = sc.xpath('td[10]/text()')
				conc  = sc.xpath('td[11]/text()')
				csf   = sc.xpath('td[12]/text()')
				csp   = sc.xpath('td[13]/text()')
				pts   = sc.xpath('td[14]/text()')				
			else
				og    = sc.xpath('td[10]/text()')
				pts   = sc.xpath('td[11]/text()')				
			end

			week = Week.new(week, opp, goals, kc, start, sub, yc, rc, miss, saved, og, conc, csf, csp, pts)

			begin
				$conn.exec_params("insert into scores
								(player_id, week, opposition, goals, kc, start, sub, yc, rc, miss, saved, og, conc, csf, csp, pts) 
								values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16); ", 
								[ player.id, week.week, week.opp, week.goals, week.kc,
								  week.start, week.sub, week.yc, week.rc, week.miss,
								  week.saved, week.og, week.conc, week.csf, week.csp,
								  week.pts] )
			rescue PG::Error  => err
		  		puts err
		  		puts player
		  		puts week
		  		exit
			end
		end
	end
end
f = Time.now
puts f-s