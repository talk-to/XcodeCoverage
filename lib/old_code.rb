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

def storingdir(m, dir)
	a = m[2].dup
	b = File.dirname(a)
	dir[b] = 1
	c = m[2].dup
	c.delete!'/'
	c.concat(".html")
	fileHTML = File.new(c, "w+")
	htmlheadingprint fileHTML, "Functions"
	fileHTML.close
end	

def writingintidirs(a, s)
	b = a.dup
	b.delete!'/'
	print b
	c = b.dup
	fileHTML = File.open("index.html", "a")	
	fileHTML.puts("")
	hrefprint(fileHTML, c, a)
	fileHTML.close	
	b.concat(".html")
	fileHTML = File.new(b, "w+")	
	htmlheadingprint fileHTML, "Files"
	fileHTML.close
end

f = open("info_sample")

start = Hash.new(0)
finish = Hash.new(0)
count = Hash.new(0)
hit = Hash.new(0)
dir = Hash.new()

prev = -1

regex1 = /(LH:)(.*)/
regex2 = /(SF:)(.*)/
regex3 = /(FN:)(.*,)(.*)/
regex4 = /(FNDA:)(.*,)(.*)/
regex5 = /(DA:)(.*,)(.*)/

f.each_line {|line| 
	regex2 = /(SF:)(.*)/

	m = regex2.match(line)
	if m 
		storingdir(m, dir)
	end

}
		
a = Dir.pwd
b = File.expand_path("..",a)

a[b] = ""

fileHTML = File.new("index.html", "w+")
htmlheadingprint fileHTML, "Directories"
fileHTML.close
f.close

f = open("info_sample")

currFile = "1"

dir.each_pair {|key, value|
	a = key.dup
	s = key.dup
	writingintidirs(a, s)
}

presentfile = ""

f.each_line {|line| 
	m = regex1.match(line)

	if m
		finish[prev] = prev + 1000

		start.each_pair {|key, value|
			e = currFile.dup
			e.concat(key)
			e.delete!'/'

			f = e.dup
			f = f.concat(".html")

			fileHTML = File.new(f, "w+")	

			htmlheadingprint fileHTML, "Un-Covered Lines"

			i = start[key]
			j = finish[value]

			ct1 = 0.0
			ct2 = 0.0
			while i < j do
				if hit[i] == -1
					ct1 += 1.0
				end
				if hit[i] > 0
					ct2 += 1.0
				end
				i += 1
			end

			i = start[key]
			ans1 = ct2/(ct1+ct2)
			ans1 *= 100.0
			if ct1 != 0 || ct2 != 0
				#paraprint(fileHTML, ans1)	
			end

			while i < j do
				if hit[i] == -1
					#puts i			
					rt = IO.readlines(presentfile)[i-1]
					puts presentfile
					#puts "111"
					string4 = i.to_s
					string4<<")     "
					string4 = string4<<rt
					paraprint(fileHTML, string4)	

					print i
					print " " 
					puts rt
				end

				i += 1
			end

			g = currFile.dup
			g.delete!'/'
			g.concat(".html")

			fileHTML = File.open(g, 'a')
			hrefprint fileHTML, e, key			
		}

		start.clear()
		finish.clear()
		count.clear()
		hit.clear()
		prev = -1
	end

	m = regex2.match(line)

	if m 
		currFile = m[2].dup
		a = m[2].dup
		presentfile = a.dup
		#puts a
		#puts "0000"
		b = File.dirname(a)

		dir[b] = 1
		c = b.dup

		c.delete!'/'

		c.concat(".html")

		a.delete!'/'
		d = m[2].dup
		e = File.basename(d)

		fileHTML = File.open(c, 'a')
		hrefprint fileHTML, a, e
	end

	m = regex3.match(line)

	if m
		puts m[2]
		a = m[2].chop
		puts a
		puts ""
		b = m[3]
		c = Integer(a)

		if b[0] != '_'
			start[b] = c

			if c != prev
				finish[prev] = c
				prev = c
			end
		end
	end

	m = regex4.match(line)

	if m
		puts m[2]
		a = m[2].chop
		puts a
		puts "fsgfgs "
		b = m[3]

		c = Integer(a)

		if b[0] != '_'
			count[b] = c
		end
	
	else
		m = regex5.match(line)

		if m
			a = m[2].chop
			b = m[3]

			c = Integer(a)
			d = Integer(b)

			hit[c] = d

			if d == 0
				hit[c] = -1
			end

		end
	end
}

# main if__ file__
system(" open index.html")