Text file compression utility based on Lempel–Ziv–Welch (LZW) data compression algorithm.

To compress a file (using the_last_question.txt) as an example. In your terminal, run the following:
```
ruby vkrunch.rb -c the_last_question.txt
```
You should see a printout like the one below and your current folder will now have a file called the_last_question.txt.vkrunch:
```
the_last_question.txt.vkrunch created
________________________________________________________
Original file name    : the_last_question.txt
VKrunched file name   : the_last_question.txt.vkrunch
Original file size    : 25K
VKrunched file size   : 16K
Compression took 0.0282 seconds
VKrunched file is 36.0% smaller than the original file
________________________________________________________
```

To uncompress the .vkrunch file:
```
ruby vkrunch.rb -u the_last_question.txt.vkrunch
```
Your current folder will now have _the_last_question.txt which will contain the uncompressed text. The prinout will look like the one below:
```
file uncompressed
_the_last_question.txt created
```

Oct 12, 2014
- Added command line file support
  - '-c' and '-u' options for compress / uncompress
- Though the character count is lower in the compressed output, the 25k file 'the_last_question.txt' is getting converted to 44k, which I am guessing is because of the type of data structure I am using (includes commas between dictionary indices, which have a cost)
  - fixed this issue by converting new integer dictionary array to binary with array.pack("S*") and binary back to the array with array.unpack("S*")
- The dictionary in compress method was running in O(n^2) time due to call to Array#index. Redesigning the dictionary as a hash sped up the compression from 4 seconds for the_last_question.txt to 0.03 seconds.

```
fundamental_kant.txt.vkrunch created
________________________________________________________
Original file name    : fundamental_kant.txt
VKrunched file name   : fundamental_kant.txt.vkrunch
Original file size    : 176K
VKrunched file size   : 71K
Compression took 0.1989 seconds
VKrunched file is 59.7% smaller than the original file
________________________________________________________
```
```
moby_dick.txt.vkrunch created
________________________________________________________
Original file name    : moby_dick.txt
VKrunched file name   : moby_dick.txt.vkrunch
Original file size    : 1198K
VKrunched file size   : 460K
Compression took 1.6630 seconds
VKrunched file is 61.6% smaller than the original file
________________________________________________________
```

Oct 11, 2014
- Wrote up algorithm in pseudocode
- Converted pseudocode to Ruby
- Adjusted code for edge cases
  - compression at beginning of text
  - compression at end of text
  - compression of curved apostrophe vs straight apostrophe
