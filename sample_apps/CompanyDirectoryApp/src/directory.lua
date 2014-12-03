-- Load Summit Speech and json modules
local speech = require 'summit.speech'
local json   = require 'json'

-- Mock Employee Directory
local employee_directory = {
	employees={
		{last_name="Romero", first_name="Isaac", phone="13175551212"},
		{last_name="Garcia", first_name="Roberto", phone="13175551212"},
		{last_name="Marshall", first_name="Andrew", phone="13175551212"},
		{last_name="Lloyd", first_name="Roy", phone="13175551212"},
		{last_name="Blake", first_name="Lionel", phone="13175551212"},
		{last_name="Jennings", first_name="Gerald", phone="13175551212"},
		{last_name="Perez", first_name="Moses", phone="13175551212"},
		{last_name="Guzman", first_name="Gerardo", phone="13175551212"},
		{last_name="Edwards", first_name="Terry", phone="13175551212"},
		{last_name="Mccoy", first_name="Josefina", phone="13175551212"}
	}
}

-- Dial an Employee
function dial_employee(employee)
	channel.say("Dialing " .. employee.first_name .. " " .. employee.last_name)
	channel.dial(employee.phone)
end

-- Main Company Directory Search
function play_directory_menu()

	-- Gather first three letters of employee's last name
	local last_name_digits = channel.gather({play=speech("Enter the first three letters of the last name of the person you wish to find."), minDigits=3, maxDigits=3})

	-- Replace each digit with appropriate string matching regular expression vocabulary
	last_name_digits = string.gsub(last_name_digits, "2", "[abc]")
	last_name_digits = string.gsub(last_name_digits, "3", "[def]")
	last_name_digits = string.gsub(last_name_digits, "4", "[ghi]")
	last_name_digits = string.gsub(last_name_digits, "5", "[jkl]")
	last_name_digits = string.gsub(last_name_digits, "6", "[mno]")
	last_name_digits = string.gsub(last_name_digits, "7", "[pqrs]")
	last_name_digits = string.gsub(last_name_digits, "8", "[tuv]")
	last_name_digits = string.gsub(last_name_digits, "9", "[wxyz]")

	-- For each employee in the directory, match potential employees with entered digits
	for _,employee in ipairs(employee_directory.employees) do

		-- Extract first three letters of employee's last name
		local employee_last_name_first_three_letters = string.sub(string.lower(employee.last_name), 1, 3)

		-- Check for match between first three letters of employee's last name and the search string
		if string.match(employee_last_name_first_three_letters, last_name_digits) then

			-- Now that a match has been found, ask the caller if they'd like to dial this employee
			call_this_employee = channel.gather({play=speech("Would you like to call " .. employee.first_name .. " " .. employee.last_name .. "? Press 1 to dial, 2 to look for another match."), minDigits=1, maxDigits=1})
			if call_this_employee == "1" then
				dial_employee(employee)
				break
			end
		end
	end

	-- Since there were no employees found in their search, inform the caller based on reasoning
	if call_this_employee == nil then
		channel.say("There were no employees found with that last name. Sorry!")
		return play_directory_menu

	elseif call_this_employee == "2" then
		channel.say("There were no additional matches. Sorry!")
		return play_directory_menu
	end

	return nil
end
