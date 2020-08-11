#include <array.au3>

$url = 'paste here the url of a recorded stream in the format of <https://dlive.tv/p/username+broadcast_id>'
$filename = @scriptdir & '\html.txt'
inetget($url, $filename)
$page = filereadtoarray($filename)
filedelete($filename)

for $line in $page
   if stringinstr($line, "playbackUrl", 1) then
	  $result = stringregexp($line, 'playbackUrl":"(.*)vod\.m3u8","', 1)
	  $result = stringreplace($result[0], '\u002F', '/') & 'src/playback.m3u8'
	  $filename = @scriptdir & '\m3u8.txt'
	  inetget($result, $filename)
	  $page = filereadtoarray($filename)
	  filedelete($filename)
	  exitloop
   endif
next

$url  = stringsplit($url, '/+', 2)
$user = $url[ubound($url) - 2]
$bid  = $url[ubound($url) - 1]
$path = @scriptdir & '\' & $user & '\' & $bid
if not fileexists($path) then dircreate($path)

$count = 1
for $line in $page
   if stringleft($line, 1) <> '#' then
	  $filename = @scriptdir & '\' & $user & '\' & $bid & '\' & $count & '.ts'
	  inetget($line, $filename)
	  $count += 1
   endif
next

exit
