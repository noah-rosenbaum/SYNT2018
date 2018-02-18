#!/usr/bin/ruby

#require 'json'

print "started at #{`date`}"

def extract_first_link_title(text)
	#puts ">>>\ntrying to extract first title link from #{text}\n\n"
	# to do unless text =~ /<comment>/
	parensdeep = 0
	bracesdeep = 0
	bracketsdeep = 0
	badlink = false
	foundpipe = false
	foundpound = false
	link = ""
	letters = text.split("")
	letters.each do |letter|
		bracesdeep -= 1 if letter == "}" unless bracketsdeep == 2 
		parensdeep -= 1 if letter == ")" unless bracketsdeep == 2
		bracketsdeep -= 1 if letter == "]"
		foundpipe = true if letter == "|" && bracketsdeep == 2
		foundpound = true if letter == "#" && bracketsdeep == 2
		#puts "[#{bracketsdeep} {#{bracesdeep} (#{parensdeep} \##{foundpound} |#{foundpipe} : L#{link} #{letter}"
		if (bracketsdeep == 0 && link != "")
			if start_with_bad_tag?(link)
				link = ""
				foundpound = foundpipe = false
			else
				break
			end
		end
		link << letter if bracketsdeep == 2 && parensdeep == 0 && bracesdeep == 0 && !foundpound && !foundpipe
		bracketsdeep += 1 if letter == "["
		bracesdeep += 1 if letter == "{" unless bracketsdeep == 2
		parensdeep += 1 if letter == "(" unless bracketsdeep == 2
	end
	link = link[1..-1] if link.start_with?(':')
	link
end

#def remove_curly_sections text#
#	text.gsub /(\{\{[^\}]*\}\})/, ''
#end

def start_with_bad_tag?(link)
	badtags = ['image:', 'file:', 'template:', 'wikipedia:', 'module:', ':']
	badtags.any? { |badtag| link.downcase.start_with? badtag } 
end
#sample = "[bla] | bla [[First link | Second link]] bla [[sugyhr]]!"
#puts "the first link in #{sample} should be 'Second link', I found: #{extract_first_link_title(sample)}"

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
			unless title =~ /talk:/i
				unless title =~ /draft:/i
					unless title =~ /category:/i
						unless title =~ /user:/i
							unless title =~ /file:/i
								unless title =~ /template:/i
									unless title =~ /wikipedia:/i
										unless title =~ /portal:/i
											unless title =~ /(disambiguation)/i
												link = extract_first_link_title(text)
												if link.nil?  || link == ""
													link = title
												end
												puts "#{title} => #{link}"
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		page = ""
	end
end


print "finished at #{`date`}"