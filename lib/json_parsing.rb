require 'json'

# Write the heading into the html file using the
#  required syntax

def htmlheadingprint(fileHTML, heading)
    fileHTML.puts("<!DOCTYPE html>")
    fileHTML.puts("<html>")
    fileHTML.puts("<body>")
    fileHTML.puts("<h1>")
    fileHTML.puts(heading)
    fileHTML.puts("</h1>")
end

# Creates a link called string2 which goes to string1.html
# which is done using href in html

def hrefprint(fileHTML, string1, string2)
    fileHTML.puts("<a href=\"")
    fileHTML.puts(string1)
    fileHTML.puts(".html \">")
    fileHTML.puts(string2)
    fileHTML.puts("</a>")
    fileHTML.puts("<br>")
end

# Prints  string1 as a paragraph into the html file
def paraprint(fileHTML, string1)
    fileHTML.puts("<p>")
    fileHTML.puts(string1)
    fileHTML.puts("</p>")
end

s = IO.read('out_json.json')


data = JSON.parse(s)

fileHTML = File.new("index.html", "w+")
htmlheadingprint(fileHTML, "Directories")
fileHTML.close

fileHTML = File.open("index.html", "a")

data.each_pair {|key, value|
    directory_name = key.dup
    directory_name_without_symbols = key.dup.delete!'/'
    hrefprint(fileHTML, directory_name_without_symbols, directory_name)
    directory_HTML = File.new(directory_name_without_symbols.concat(".html"), "w+")
    htmlheadingprint directory_HTML, "Files"
    
    directory_HTML.close
}

fileHTML.close

data.each_pair {|key, value|
    directory_name= key.dup.delete!'/'
    
    directory_name.concat(".html")
    
    directoryHTML = File.open(directory_name, "a")
    
    value.each_pair {|key1, value1|
        file_name = key1.dup
        file_name_without_symbols = key1.dup.delete!'/'
        hrefprint(directoryHTML, file_name_without_symbols, file_name)
        file_HTML = File.new(file_name_without_symbols.concat(".html"), "w+")
        htmlheadingprint file_HTML, "Functions...."
        
        file_HTML.close
    }
    
    directoryHTML.close
}

data.each_pair {|key,value|
    value.each_pair {|key1, value1|
        file_name_without_symbols = key1.dup.delete!'/'
        file_name_without_symbols_html = file_name_without_symbols.dup.concat(".html")
        file_HTML = File.open(file_name_without_symbols_html, "a")
        
        value1.each_pair {|key2, value2|
            
            if key2 == "__total__lines__" || key2 == "__total__lines__"
                next
            end
            
            function_name = key2.dup
            augmented_function_name =  file_name_without_symbols.dup.concat(function_name)
            
            #	puts augmented_function_name
            #	puts " "
            total_lines = Float(value2["__total__lines__"])
            executed_lines = Float(value2["__executed__lines__"])
            
            if total_lines < 1.0
                total_lines = 1.0
            end
            percentage = executed_lines/total_lines
            percentage = percentage*100.0
            percentage = Integer(percentage)
            percent = percentage.to_s
            #			puts percentage
            fun_name = ("&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; coverage = ").concat(percent).concat(" %")
            
            #puts fun_name
            hrefprint(file_HTML, augmented_function_name, function_name)
            #	puts augmented_function_name
            paraprint(file_HTML, fun_name)
            function_HTML = File.new(augmented_function_name.dup.concat(".html"), "w+")
            htmlheadingprint function_HTML, "Uncovered Lines......"
            function_HTML.close
        }
    }
}

data.each_pair {|key,value|
    value.each_pair {|key1, value1|
        file_name_without_symbols = key1.dup.delete!'/'
        
        value1.each_pair {|key2, value2|
            function_name = key2.dup
            augmented_function_name =  file_name_without_symbols.dup.concat(function_name)
            
            function_HTML = File.open(augmented_function_name.dup.concat(".html"), "a")
            
            value2.each_pair {|key3,value3|
                
                if(key3 != "__total__lines__" && key3 != "__executed__lines__")
                    uncovered_line = key3.dup.concat(")    ").dup.concat(value3.dup)
                    paraprint(function_HTML, uncovered_line)
                end
            }
        }
    }
}

system(" open index.html")


