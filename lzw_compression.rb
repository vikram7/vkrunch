require 'pry'
option = ARGV[0]
filename = ARGV[1]
file = File.open(filename, "r")
contents = file.read
file.close
contents_size = contents.size

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
  compressed = output.join(",")
  compressed
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
  outputname = filename + ".vkrunch"
  f = File.new(outputname, "w")
  f.write(compressed)
  puts outputname + " created"
elsif option == "-u"
  contents = contents.split(",").map! {|x| x.to_i}
  uncompressed = uncompress(contents).join
  outputname = "jie.txt"
  f = File.new(outputname, "w")
  f.write(uncompressed)
else
  puts "Format to use this tool as follows:"
  puts "ruby vkrunch.rb -c <file.txt>"
  puts "ruby vkrunch.rb -u <file.txt.vkrunch>"
  puts "Available options are -c to compress and -u to uncompress."
end

# compressed_size = compressed.size
# compression_ratio = (1 - compressed_size / contents_size.to_f) * 100
# puts "Original File Size: " + contents_size.to_s
# puts "Compressed File Size: " + compressed_size.to_s
# puts "Compression Ratio: " + "%.1f" % compression_ratio.to_s + "%"

