require 'json'

# This function inserts the directories into the hash map
def insert_directory(directory, directory_name)
    if !directory.has_key?(directory_name)
        directory[directory_name] = Hash.new{}
    end
end

# This function inserts the file into the hash of directories
def insert_file_into_directory(file_name, directory, directory_name)
    dir_hash = directory[directory_name]
    dir_hash[file_name] = Hash.new{}
end

# This is the main hash - directory level has
directory = Hash.new{}

# This contains the info-file
f = open("info_sample")

# regex to check for file name in the info-file
file_name_regex = /(SF:)(.*)/

# We go through the info-file line by line and get the names of all the directories
f.each_line { |line|
    matched_file = file_name_regex.match(line)
    
    if matched_file
        file_name = matched_file[2].dup
        directory_name = File.dirname(file_name)
        insert_directory(directory, directory_name)
    end
}

f.close

f = open("info_sample")

# We go through the info-file line by line to get all the names of the
# different files and put them under the respective directories.

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

# regex to find the line in the info-file which contains the information
# of where a function starts and its name
funtion_name_regex = /(FN:)(.*,)(.*)/

present_file = ""
present_directory = ""
present_directory_hash = Hash.new{}
present_file_hash = Hash.new()
prev = -1
start = Hash.new(0)
finish = Hash.new(0)

end_of_file_regex = /(end_of_record)(.*)/
regex5 = /(DA:)(.*,)(.*)/
regex4 = /(FNDA:)(.*,)(.*)/

hit = Hash.new (0)

# We go through the info-file line by line to get all the names of the different
# functions and put them under their respective files. We also find which lines
# are not covered and also the percentage.

f.each_line {|line|
    matched_file = file_name_regex.match(line)
    
    if matched_file
        present_file = matched_file[2].dup
        present_directory = File.dirname(present_file)
        present_directory_hash = directory[present_directory]
        present_file_hash = present_directory_hash[present_file]
    end
    
    end_of_file = end_of_file_regex.match(line)
    
    if end_of_file
        
        total_lines = 0 # total number of lines in this file
        executed_lines = 0 # number of lines executed at least once in this file
        
        
        start.each_pair {|key, value|
            #			puts key
            
            #puts present_file
            present_function_hash = present_file_hash[key]
            
            i = start[key]
            j = finish[value]
            
            
            ct1 = 0
            ct2 = 0
            
            while i < j do
                if hit[i] == -1
                    ct1 += 1
                    total_lines += 1
                    rt = IO.readlines(present_file)[i-1]
                    present_file_hash[key.dup][i] = rt
                end
                if hit[i] > 0
                    ct2 += 1
                    total_lines += 1
                    executed_lines += 1
                end
                i += 1
            end
            
            #	puts key
            #	puts "jknkjh"
            
            if !present_function_hash
                puts "gggggg"
                puts key
                puts present_file
            end
            present_function_hash["__total__lines__"] = (ct1+ct2).to_s
            present_function_hash["__executed__lines__"] = ct2.to_s
            
            }
            
            present_file_hash["__total__lines__"] = total_lines.to_s
            present_file_hash["__executed__lines__"] = executed_lines.to_s
            
            start.clear()
            finish.clear()
            hit.clear()
            prev = -1
            
            end
            
            m =  funtion_name_regex.match(line)
            
            if m
                function_start_string = m[2].dup.chop
                function_name = m[3].dup
                function_start = Integer(function_start_string)
                
                
                if function_name[0] != '_'
                    function_name.slice!(0)
                    present_file_hash[function_name] = Hash.new{}
                    
                    start[function_name] = function_start
                    
                    #puts function_name
                    if function_start != prev
                        finish[prev] = function_start
                        prev = function_start
                    end
                    
                end
            end
            
            function_execution = regex4.match(line)
            
            if function_execution
                
                else
                matched_line = regex5.match(line)
                
                if matched_line
                    
                    #		puts matched_line
                    a = matched_line[2].chop
                    b = matched_line[3]
                    
                    #		puts a
                    #		puts "fsg"
                    #		puts b
                    c = Integer(a)
                    d = Integer(b)
                    
                    hit[c] = d
                    
                    if d == 0
                        hit[c] = -1
                    end
                end
            end
            
            
        }
        
        f.close
        
        file_json = File.new("out_json.json", "w+")	
        
        file_json.puts(JSON.pretty_generate(directory))
        
        regex4 = /(FNDA:)(.*,)(.*)/
