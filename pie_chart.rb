#!/usr/bin/ruby

#require 'json'

ARGF.each_line do |line|
	if line =~ /Loop is (.*)/
		loop = $1
		puts loop
	end
end