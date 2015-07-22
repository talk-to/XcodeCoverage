require 'json'

#my_hash = {"bob.johnson@example.com"=>{"first"=>"Bob", "last"=>"Johnson"}, "lisa.dell@example.com"=>{"first"=>"Lisa", "last"=>"Dell"}}

#superdirectory = Hash.new() 



# superdirectory["directory1"] = directory


# This function inserts the directories into the hash map
def insert_directory(directory, directory_name)
	if !directory.has_key?(directory_name)
		directory[directory_name] = Hash.new()
	end
end

# This function inserts the file into the hash of directories
def insert_file_into_directory(file_name, directory, directory_name)
	dir_hash = directory[directory_name]
	dir_hash[file_name] = Hash.new()
end

# This is the main hash - directory level has
directory = Hash.new()

#This contains the info-file
f = open("info_sample")

# regex to check for file name in the info-file
file_name_regex = /(SF:)(.*)/

#We go through the info-file line by line and get the names of all the directories
f.each_line {|line| 
	matched_file = file_name_regex.match(line)

	if matched_file
		file_name = matched_file[2].dup
		directory_name = File.dirname(file_name)
		insert_directory(directory, directory_name)
	end
}

f.close

f = open("info_sample")

#We go through the info-file line by line to get all the names of the different files and put them under the respective directories.
f.each_line {|line| 
	matched_file = file_name_regex.match(line)

	if matched_file
		file_name = matched_file[2].dup
		directory_name = File.dirname(file_name)
		insert_file_into_directory(file_name, directory, directory_name)
	end
}

f.close

f = open("info_sample")

#regex to find the line in the info-file which contains the information of where a function starts and its name
funtion_name_regex = /(FN:)(.*,)(.*)/

present_file = ""
present_directory = ""
present_directory_hash = Hash.new()
present_file_hash = Hash.new()
prev = -1
start = Hash.new(0)
finish = Hash.new(0)

#We go through the info-file line by line to get all the names of the different functions and put them under their respective files.
f.each_line {|line| 
	matched_file = file_name_regex.match(line)

	if matched_file
		present_file = matched_file[2].dup
		present_directory = File.dirname(present_file)
		present_directory_hash = directory[present_directory]
		present_file_hash = present_directory_hash[present_file]
	end

	m =  funtion_name_regex.match(line)

	if m 
		function_start_string = m[2].dup.chop
		function_name = m[3].dup
		function_start = Integer(function_start_string)


		if function_name[0] != '_'
			function_name.slice!(0)
			present_file_hash[function_name] = Hash.new()

			start[function_name] = function_start

			if function_start != prev
				finish[prev] = function_start
				prev = function_start
			end

		end
	end

}

file_json = File.new("out_json.json", "w+")	
#file_json.puts(directory.to_json)
file_json.puts(JSON.pretty_generate(directory))
my_json = directory.to_json
#puts JSON.pretty_generate(my_json)
regex4 = /(FNDA:)(.*,)(.*)/
regex5 = /(DA:)(.*,)(.*)/
regex1 = /(LH:)(.*)/
prev = -1
start = Hash.new(0)
finish = Hash.new(0)
count = Hash.new(0)
hit = Hash.new(0)







