starttime = Time.now
option = ARGV[0]
filename = ARGV[1]
file = File.open(filename, "r")
contents = file.read
filesize = file.size/1000
file.close
contents_size = contents.size

def to_binary(array)
  array.pack("S*")
end

def from_binary(binary)
  binary.unpack("S*")
end

def compress(to_compress)
  dictionary = (0..255).to_a.map {|element| element.chr}
  output = Array.new
  broken = to_compress.split('')
  s = broken.first
  broken.each do |character|
    c = character
    if dictionary.include?(s + c)
      s = s + c
    else
      output << dictionary.index(s)
      dictionary << s + c
      s = c
    end
  end
  output
end

def uncompress(to_uncompress)
  dictionary = (0..255).to_a.map {|element| element.chr}
  output = Array.new
  current = to_uncompress.shift
  output << current
  to_uncompress.each do |index|
    previous = current
    current = index
    if current < dictionary.length
      s = dictionary[current]
      output << s
      dictionary << dictionary[previous] + s[0]
    else
      s = dictionary[previous]
      output << s
      dictionary << s
    end
  end
  output
end

if option == "-c"
  compressed = compress(contents)
  packed = to_binary(compressed)
  outputname = filename + ".vkrunch"
  f = File.new(outputname, "w")
  f.write(packed)
  endtime = Time.now
  newfilesize = f.size/1000
  ratio = 1 - newfilesize / filesize.to_f
  puts
  puts outputname + " created"
  puts "____________________________________________"
  puts "Original File Size  : " + filesize.to_s + "K"
  puts "VKrunched File Size : " + newfilesize.to_s + "K"
  puts "Compression Time took : " + "%.1f" % (endtime - starttime).to_s + " seconds"
  puts "VKrunched File is " + (ratio*100).to_s + "% smaller than the original file"
  puts "____________________________________________"
elsif option == "-u"
  unpacked = from_binary(contents)
  uncompressed = uncompress(unpacked).join
  outputname = "jie.txt"
  f = File.new(outputname, "w")
  f.write(uncompressed)
else
  puts "Format to use this tool as follows:"
  puts "ruby vkrunch.rb -c <file.txt>"
  puts "ruby vkrunch.rb -u <file.txt.vkrunch>"
  puts "Available options are -c to compress and -u to uncompress."
end
