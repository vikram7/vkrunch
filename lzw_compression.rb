require 'pry'

def compress(to_compress)
  dictionary = (0..255).to_a.map {|element| element.chr}
  output = Array.new
  to_compress = to_compress.gsub("\’","\'")
  broken = to_compress.split('')
  s = broken.shift
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
  output << dictionary.index(s)
  output
end

def uncompress(to_uncompress)
  dictionary = (0..255).to_a.map {|element| element.chr}
  output = Array.new
  current = to_uncompress.shift
  output << dictionary[current]
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

input = 'The last question was asked for the first time, half in jest, on May 21, 2061, at a time when humanity first stepped into the light. The question came about as a result of a five dollar bet over highballs, and it happened this way:
Alexander Adell and Bertram Lupov were two of the faithful attendants of Multivac. As well as any human beings could, they knew what lay behind the cold, clicking, flashing face -- miles and miles of face -- of that giant computer. They had at least a vague notion of the general plan of relays and circuits that had long since grown past the point where any single human could possibly have a firm grasp of the whole.

Multivac was self-adjusting and self-correcting. It had to be, for nothing human could adjust and correct it quickly enough or even adequately enough -- so Adell and Lupov attended the monstrous giant only lightly and superficially, yet as well as any men could. They fed it data, adjusted questions to its needs and translated the answers that were issued. Certainly they, and all others like them, were fully entitled to share In the glory that was Multivac\'s.'

compressed = compress(input)
uncompressed = uncompress(compressed)
puts uncompressed.join

puts
puts "_____________________________________________"
puts "input length: " + input.length.to_s + " characters"
puts "compressed length: " + compressed.length.to_s + " characters"
