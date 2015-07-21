require 'json'

my_hash = {"bob.johnson@example.com"=>{"first"=>"Bob", "last"=>"Johnson"}, "lisa.dell@example.com"=>{"first"=>"Lisa", "last"=>"Dell"}}

superdirectory = Hash.new()



# superdirectory["directory1"] = directory


def insert_directory(directory, directory_name)
	if !directory.has_key?(directory_name)
		directory[directory_name] = Hash.new()
	end
end

def insert_file_into_directory(file_name, directory, directory_name)
	dir_hash = directory[directory_name]
	dir_hash[file_name] = Hash.new()
end

directory = Hash.new()

f = open("info_sample")

file_name_regex = /(SF:)(.*)/

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

funtion_name_regex = /(FN:)(.*,)(.*)/

present_file = ""
present_directory = ""
present_directory_hash = Hash.new()
present_file_hash = Hash.new()

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
		aa = m[2].dup
		a = aa.chop		
		puts a
		b = m[3].dup

		c = Integer(a)

		if b[0] != '_'
			b.slice!(0)
			present_file_hash[b] = Hash.new()
		end

	end
}

puts directory.to_json

regex4 = /(FNDA:)(.*,)(.*)/
regex5 = /(DA:)(.*,)(.*)/
regex1 = /(LH:)(.*)/
prev = -1
start = Hash.new(0)
finish = Hash.new(0)
count = Hash.new(0)
hit = Hash.new(0)







