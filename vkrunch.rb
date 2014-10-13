def to_binary(array)
  array.pack("S*")
end

def from_binary(binary)
  binary.unpack("S*")
end

def compress(to_compress)
  # create dictionary with all 256 ascii codes
  dictionary = Hash.new
  256.times do |ascii_code|
    dictionary[ascii_code.chr] = ascii_code
  end
  s = to_compress[0]
  to_compress.each_char.reduce [] do |output, c|
    if dictionary.include?(s + c)
      s = s + c
    else
      output << dictionary[s]
      dictionary[s + c] = dictionary.size
      s = c
    end
  output
  end
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
  if ARGV[0] == "-c" && contents.match(/[^\x00-\x7F]/)
    puts "Sorry, but " + filename + " contains non-ASCII characters. We don't support non-ASCII characters yet. Please try again after encoding the file in ASCII format."
  else
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
      puts "Compression took " + "%.4f" % (endtime - starttime).to_s + " seconds"
      puts "VKrunched file is " + "%.1f" % (ratio*100).to_s + "% smaller than the original file"
      puts "________________________________________________________"
    elsif option == "-u"
      unpacked = from_binary(contents)
      uncompressed = uncompress(unpacked).join
      outputname = "_" + filename.gsub(".vkrunch","")
      f = File.new(outputname, "w")
      f.write(uncompressed)
    end
  end
end
