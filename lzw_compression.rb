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
    binding.pry
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
