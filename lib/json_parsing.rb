require 'json'

def htmlheadingprint(fileHTML, heading)
	fileHTML.puts("<!DOCTYPE html")
	fileHTML.puts("<html>")
	fileHTML.puts("<body>")
	fileHTML.puts("<h1>")
	fileHTML.puts(heading)	
	fileHTML.puts("</h1>")
end

def hrefprint(fileHTML, string1, string2)
	fileHTML.puts("<a href=\"")
	fileHTML.puts(string1)
	fileHTML.puts(".html \">")
	fileHTML.puts(string2)
	fileHTML.puts("</a>")
	fileHTML.puts("<br>")
end

def paraprint(fileHTML, string1)
	fileHTML.puts("<p>")
	fileHTML.puts(string1)
	fileHTML.puts("</p>")					
end

#file = File.open("path-to-file.tar.g", "rb")

s = IO.read('out_json.json')


data = JSON.parse(s)

fileHTML = File.new("index.html", "w+")
htmlheadingprint fileHTML, "Directories"
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
		htmlheadingprint file_HTML, "Functions..."

		file_HTML.close
	}

	directoryHTML.close
}

data.each_pair {|key,value|
	value.each_pair {|key1, value1|
		file_name_without_symbols = key1.dup.delete!'/'
		file_HTML = File.open(file_name_without_symbols.concat(".html"), "a")

		value1.each_pair {|key2, value2|
			function_name = key2.dup
			augmented_function_name =  file_name_without_symbols.concat(function_name)
			hrefprint(file_HTML, augmented_function_name.concat(".html"), function_name)		
		}
	}
}


system(" open index.html")

	
