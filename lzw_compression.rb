file = File.open(ARGV[0], "r")
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


compressed = compress(contents)
compressed_size = compressed.size
uncompressed = uncompress(compressed)
compression_ratio = (1 - compressed_size / contents_size.to_f) * 100

puts "Original File Size: " + contents_size.to_s
puts "Compressed File Size: " + compressed_size.to_s
puts "Compression Ratio: " + "%.1f" % compression_ratio.to_s + "%"

