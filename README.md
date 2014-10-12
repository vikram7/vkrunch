Text file compression utility based on Lempel–Ziv–Welch (LZW) data compression algorithm.

Oct 12, 2014
- Added command line file support
  - '-c' and '-u' options for compress / uncompress
- though the character count is lower in the compressed output, the 25k file 'the_last_question.txt' is getting converted to 44k, which I am guessing is because of the type of data structure I am using (includes commas between dictionary indices, which have a cost)
  - fixed this issue by converting new integer dictionary array to binary with array.pack("S*") and binary back to the array with array.unpack("S*")

- the_last_question.txt.vkrunch created
- ________________________________________________________
- Original file name    : the_last_question.txt
- VKrunched file name   : the_last_question.txt.vkrunch
- Original file size    : 25K
- VKrunched file size   : 16K
- Compression took 3.9 seconds
- VKrunched file is 36.0% smaller than the original file
- ________________________________________________________

Oct 11, 2014
- Implemented algorithm in pseudocode
- Converted pseudocode to Ruby
- Adjusted code for edge cases
  - compression at beginning of text
  - compression at end of text
  - compression of curved apostrophe vs straight apostrophe
