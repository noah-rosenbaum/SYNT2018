#!/usr/bin/ruby
$links = {}

STDIN.each do |line|
	array = line.chomp.split(" => ")
	$links[array[0]] = array[1] if array.size == 2
end

#puts "LINKS found:"
#puts $links
#puts ">>>>>>>>>>>"

def link_chain_hash_creator(title)
	link_chain = {}
	broken = nil
	current_title = title
	while broken != true
		next_title = $links[current_title] #|| $links[current_title.downcase]
		
		#puts "Link chain: #{link_chain}"
		#puts "Current title: #{current_title}"
		#puts "Next title: #{next_title}"
		unless next_title
			next_title = $links[current_title.capitalize] if current_title
		end

		if link_chain.keys.include? next_title			
			#alphabet_array = link_chain.alphat
			#link_chain.unshift("loop is")
			broken = true
		end
		link_chain[current_title] = next_title
		current_title = next_title
	end
	link_chain
end

seen = {}
puts "digraph {"
#15.times do 
  #title = $links.keys.sample
titles = ["SYNT", "Noah", "Switzerland", "Wikipedia", "graph", "Ruby", "xkcd", "Chaos theory", "pie chart"]
titles.each do |title|  
  hash = link_chain_hash_creator(title)
  hash.each do |k, v|
  	unless seen[k]
	  	puts "\"#{k}\" -> \"#{v}\""
	  	seen[k] = true
	end
  end
end
puts "}"
#$links.keys.each do |key|
#	puts ">>>>>>>>\n"
#	puts link_chain_creator(key)
#end