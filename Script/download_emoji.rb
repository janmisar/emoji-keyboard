#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'

require 'open-uri'

# open downloaded html file from https://unicodey.com/emoji-data/table.htm
page = Nokogiri::HTML(open("table.htm"))

# select elements
elements = page.css('tr > td:nth-child(7), tr > td:nth-child(8), tr > td:nth-child(9)')


# prepare result string
result =  "// Generated file\n\n"  
result += "let allEmojis: [Emoji] = [\n"


# transform elements content to swift array of Emoji structs and add to result string
elements.each_slice(3) do |emoji, description, name|

	# clear content
	emoji = emoji.text
	name = name.text.tr(':', '').tr('_', '-')
	description = description.text.tr(' ', '-')

	# resolve emoji names
	names = [name]
	names += [description] if description != name
	names = names.map { |e| "\"#{e}\"" }.join(", ")

	# create final struct and add to result
	result += "\tEmoji(char: \"#{emoji}\", names: [#{names}]),\n"
end

result += "]"

# write to file
File.open('../Keyboard/Emojis.swift', 'w') { |file| file.write(result) }