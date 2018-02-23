
def extract_first_link_title(text)
	#puts ">>>\ntrying to extract first title link from #{text}\n\n"
	# to do unless text =~ /<comment>/
	parensdeep = 0
	bracesdeep = 0
	bracketsdeep = 0
	commentsdeep = 0
	badlink = false
	foundpipe = false
	foundpound = false
	link = ""
	letters = text.split("")
	#puts "about to process #{letters.size} letters"
	letters.each do |letter|
		commentsdeep -= 1 if letter == ">" unless bracketsdeep == 2
		bracesdeep -= 1 if letter == "}" unless bracketsdeep == 2 
		parensdeep -= 1 if letter == ")" unless bracketsdeep == 2
		bracketsdeep -= 1 if letter == "]"
		in_link = bracketsdeep == 2 && parensdeep == 0 && bracesdeep == 0 && commentsdeep == 0
		foundpipe = true if letter == "|" && in_link
		foundpound = true if letter == "#" && in_link
		#puts "[#{bracketsdeep} {#{bracesdeep} (#{parensdeep} \##{foundpound} |#{foundpipe} : L#{link} #{letter}"
		if (bracketsdeep == 0 && link != "")
			if start_with_bad_tag?(link)
				link = ""
				foundpound = foundpipe = false
			else
				break
			end
		end
		link << letter if in_link && !foundpound && !foundpipe
		commentsdeep += 1 if letter == ">" unless bracketsdeep == 2
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
	badtags = ['image:', 'file:', 'template:', 'wikipedia:', 'module:', 'draft:', 'user:', 'talk:', 'category:', 'portal:' ':']
	badtags.any? { |badtag| link.downcase.start_with? badtag } 
end
#sample = "[bla] | bla [[First link | Second link]] bla [[sugyhr]]!"
#puts "the first link in #{sample} should be 'Second link', I found: #{extract_first_link_title(sample)}"