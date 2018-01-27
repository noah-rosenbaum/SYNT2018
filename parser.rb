#!/usr/bin/ruby

#require 'json'

print "started at #{`date`}"

def extract_first_link_title(text)
	#puts ">>>\ntrying to extract first title link from #{text}\n\n"
	unless text =~ /<comment>/
		unless text =~ /#REDIRECT/
			$1 if text =~ /\[\[([^\|\]]*)\|?[^\]]*\]\]/m
		end
	end
end

#def remove_curly_sections text#
#	text.gsub /(\{\{[^\}]*\}\})/, ''
#end

def invalid_line line
	l = line.downcase
	badtags = ['[[image:', '[[file:', '[[template:', '[[wikipedia:', '[[module:', '{{', '}}'].any? do |snippet|
		l.include? snippet 
	end 
	badtags || l.start_with?('| ') 
end
#sample = "[bla] | bla [[First link | Second link]] bla [[sugyhr]]!"
#puts "the first link in #{sample} should be 'Second link', I found: #{extract_first_link_title(sample)}"

text_of = {}

arr = []
link = nil
page = ""
ARGF.each_line do |line|
	page += line unless invalid_line(line) # TODO this may not cover all cases, or cover too many!
	if line =~ /<\/page>/ 
		#puts "*****************\n***************\npage: " + page + "\n************\n"
		if page =~ /<title>(.*)<\/title>.*<text.*?>(.*)<\/text>/m
			title = $1
			text =  $2
			#puts "\n&&&&&&&&&&&&&&&&&&&&&&&>> The title is #{title}"
			#puts "\n&&&&&&&&&&&&&&&&&&&&&&&>> The text is #{text}"
			unless title =~ /Talk:/i
				unless title =~ /Draft:/
					unless title =~ /Category:/
						unless title =~ /User:/
							unless title =~ /File:/
								unless title =~ /Template:/
									unless title =~ /Wikipedia:/
										unless title =~ /Portal:/
											unless title =~ /(disambiguation)/
												unless text =~ /^\#REDIRECT/
													text_of[title] = text 
													if extract_first_link_title(text) != nil
														link = extract_first_link_title(text)
													else
														link = title
													end
													puts "#{title.downcase} => #{link.downcase}"
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
		end
		page = ""
	end
end


print "finished at #{`date`}"