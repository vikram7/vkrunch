def to_binary(array)
  array.pack("S*")
end

def from_binary(binary)
  binary.unpack("S*")
end

def compress(to_compress)
  dictionary = (0..255).to_a.map { |element| element.chr }
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
  dictionary = (0..255).to_a.map { |element| element.chr }
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
  output.shift
  output
end

if ARGV[0] != "-c" && ARGV[0] != "-u" || !File.exist?(ARGV[1])
  puts "To use this utility, please see below:"
  puts "To compress file.txt           : ruby vkrunch.rb -c file.txt"
  puts "To uncompress file.txt.vkrunch : ruby vkrunch.rb -u file.txt.vkrunch"
else
  starttime = Time.now
  option = ARGV[0]
  filename = ARGV[1]
  file = File.open(filename, "r")
  contents = file.read
  filesize = file.size / 1000
  file.close

  if option == "-c"
    compressed = compress(contents)
    packed = to_binary(compressed)
    outputname = filename + ".vkrunch"
    f = File.new(outputname, "w")
    f.write(packed)
    endtime = Time.now
    newfilesize = f.size / 1000
    ratio = 1 - newfilesize / filesize.to_f
    puts
    puts outputname + " created"
    puts "________________________________________________________"
    puts "Original file name    : " + filename
    puts "VKrunched file name   : " + outputname
    puts "Original file size    : " + filesize.to_s + "K"
    puts "VKrunched file size   : " + newfilesize.to_s + "K"
    puts "Compression took " + "%.1f" % (endtime - starttime).to_s + " seconds"
    puts "VKrunched file is " + (ratio*100).to_s + "% smaller than the original file"
    puts "________________________________________________________"
  elsif option == "-u"
    unpacked = from_binary(contents)
    uncompressed = uncompress(unpacked).join
    outputname = "_" + filename.gsub(".vkrunch","")
    f = File.new(outputname, "w")
    f.write(uncompressed)
  end

end
