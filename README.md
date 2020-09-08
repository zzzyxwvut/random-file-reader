# random-file-reader

A random-file-reading programme for use with the phosphor(6) [xscreensaver](https://www.jwz.org/xscreensaver/ "xscreensaver").

Dump available fonts that match a pattern:  
  `xlsfonts -fn '*iso10646*' >/tmp/iso10646.txt`

Test the programme (/usr/local/bin/rand_file.awk) with a selected font:  
  ``/usr/lib/xscreensaver/phosphor `xwininfo -root | grep -- -geom` \  
  -scale 2 -font -misc-fixed-medium-r-normal--14-130-75-75-c-70-iso10646-1 \  
  -delay 32768 -ticks 4 -program \  
  '/usr/local/bin/rand_file.awk $(find /usr/include -type f -iname \*.h)'``

Use the following command in the Settings... -&gt; Advanced -&gt; Command Line
field of xscreensaver-demo for the Phosphor mode:  
  `phosphor -root -delay 32768 -ticks 4 -scale 2 -font -misc-fixed-medium-r-normal--14-130-75-75-c-70-iso10646-1 -program '/usr/local/bin/rand_file.awk $(find /usr/include -type f -iname \*.h)'`
