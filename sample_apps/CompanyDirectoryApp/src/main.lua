-- Load and run directory.lua file
local directory = require 'directory'

-- Answer the call
channel.answer()

-- Greet the caller
channel.say("Thanks for calling ACME Manufacturing! Welcome to our company directory.")

-- Repeat the company directory menu function as necessary
current = play_directory_menu
while current do
	current = current()
end

-- Hang up
channel.hangup()