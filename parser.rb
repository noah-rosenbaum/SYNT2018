#!/usr/bin/ruby

#require 'json'

print "version 5 started at #{`date`}"
require './parsing'

arr = []
link = nil
page = ""
found_start = false

ARGF.each_line do |line|
	page << line #unless invalid_line(line) # TODO this may not cover all cases, or cover too many!
	if line =~ /<\/page>/ 
		#puts "*****************\n***************\npage: " + page + "\n************\n"
		if page =~ /<title>(.*)<\/title>.*<text.*?>(.*)<\/text>/m
			title = $1
			text =  $2
			#puts "\n&&&&&&&&&&&&&&&&&&&&&&&>> The title is #{title}"
			#puts "\n&&&&&&&&&&&&&&&&&&&&&&&>> The text is #{text}"
			unless start_with_bad_tag? title
				link = extract_first_link_title(text)
				if link.nil? || link == ""
					link = title
				end
				puts "#{title} => #{link}"
			end
		end
		page = ""
	end
end


print "finished at #{`date`}"