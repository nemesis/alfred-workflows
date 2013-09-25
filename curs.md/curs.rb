#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

query = ARGV[0].downcase.split(' ')

if (ARGV[0].downcase.match(/\d+ \w\w\w \w\w \w\w\w/)[0]) 

    page = Nokogiri::HTML(open("http://curs.md/"))
    currencies = page.css('div#cursBox').css('tr')

    hash = {}
    currencies.each do |currency|
      current = currency.css('td')
        hash[current[1].text.downcase] = current[2].text.gsub(" Lei","").gsub(',','.').to_f
    end

    hash['mdl'] = 1.0

    amount = query[0].to_f
    curr_from = query[1]
    curr_to = query[3]

    result = (amount*hash[curr_from]/hash[curr_to]).round(2)

    xmlres = "<?xml version=\"1.0\"?>\n"
    xmlres << "<items>\n"
    xmlres << "\t<item arg=\"#{result}\" valid=\"no\">\n"
    xmlres << "\t\t<title>#{result.to_s}  #{curr_to.upcase}</title>\n"
    xmlres << "\t</item>\n"
    xmlres << "</items>"

    puts xmlres
else 
    xmlres = "<?xml version=\"1.0\"?>\n"
    xmlres << "<items>\n"
    xmlres << "\t<item arg=\"...\" valid=\"no\">\n"
    xmlres << "\t\t<title>\"...\"</title>\n"
    #xmlres << "\t\t<icon>\"path\"</icon>\n"
    xmlres << "\t</item>\n"
    xmlres << "</items>"

    puts xmlres
end
