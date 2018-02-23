#!/usr/bin/ruby
$links = {}

STDIN.each do |line|
	array = line.chomp.split(" => ")
	$links[array[0]] = array[1] if array.size == 2
end

#puts "LINKS found:"
#puts $links
#puts ">>>>>>>>>>>"


def link_chain_creator(title)
	link_chain = [title]
	broken = nil
	while broken != true
		current_title = link_chain[0]
		next_title = $links[current_title] #|| $links[current_title.downcase]
		#puts "Link chain: #{link_chain}"
		#puts "Current title: #{current_title}"
		#puts "Next title: #{next_title}"
		unless next_title
			next_title = $links[current_title.capitalize] if current_title
		end

		if link_chain.include? next_title			
			link_loop = link_chain.reverse.drop_while {|x| x != next_title}
			loop_name = link_loop.compact.sort.first 
			link_chain.unshift("ends with[#{next_title}]")
			link_chain.unshift("Loop is #{loop_name}")

			#alphabet_array = link_chain.alphat
			#link_chain.unshift("loop is")
			broken = true
		else
			link_chain.unshift(next_title)
		end
	end
	link_chain.reverse
end

10000.times do 
  puts ">>>>>>>>\n"
  alinks = $links.keys.sample
  puts link_chain_creator(alinks)
end

#$links.keys.each do |key|
#	puts ">>>>>>>>\n"
#	puts link_chain_creator(key)
#end