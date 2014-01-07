require 'open-uri'
require 'openssl'
require 'nokogiri'

#logging function
def finish (s)
	finish = Time.now
	elapsed = finish.to_f - $start.to_f
	mins, secs = elapsed.divmod 60.0
	puts( s + " - %1dm %04.1fs"%[mins.to_i, secs] )
	$start = Time.now
end

def change_teams (team)
	case team
	when 'Man City'
		return 'Manchester City'
	when 'Man Utd'
		return 'Manchester United'
	when 'Newcastle'
		return 'Newcastle United'
	when 'Stoke'
		return 'Stoke City'
	when 'Swansea'
		return 'Swansea City'
	when 'Tottenham'
		return 'Tottenham Hotspur'
	when 'West Brom'
		return 'West Bromwich Albion'
	when 'West Ham'
		return 'West Ham United'
	else
		return team
	end
end

#start error handling block
begin
	$start = Time.now

	page = Nokogiri::HTML(open('https://fantasyfootball.telegraph.co.uk/premierleague/home/fixtures', {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))

	#get week details
	week = Array.new

	weekNo = page.xpath('//*[@id="nextmatches"]/h3/text()').text
	weekNo = weekNo.gsub(/[^0-9]/, '')
	puts weekNo

	i = 1
	fix = ''
  page.xpath('/html/body/div/p/span[position()=2 or position()=3]').each do |fixt|
  	if (i%2 > 0)
  	  	fix = change_teams(fixt.text)
  	else
  		  fix = fix + change_teams(fixt.text)
  		  week.push(fix)
  	end
  	i += 1
  end

  puts week

	page = Nokogiri::HTML(open('https://fantasyfootball.telegraph.co.uk/premierleague/match-facts/', {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})) 
	
	compl = Array.new
	fix = ''

	page.xpath('/html/body/div/div[2]/div/div/div/div/div/div/div[2]').each_with_index do |team, index|

		fix = fix + team.text

		if index % 2 > 0
			compl.push(fix)
			fix = ''
		end
	end

	week.each do |match|
		unless compl.include?(match)
			puts match
			break
		end
	end
end