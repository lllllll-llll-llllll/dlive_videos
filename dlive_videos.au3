#include <array.au3>

$url = 'enter the url of a recorded stream'
$filename = @scriptdir & '\html.txt'
inetget($url, $filename)
$page = filereadtoarray($filename)
filedelete($filename)

for $line in $page
   if stringinstr($line, "playbackUrl", 1) then
	  $result = stringregexp($line, 'playbackUrl":"(.*)vod\.m3u8","', 1)
	  $result = stringreplace($result[0], '\u002F', '/') & 'src/playback.m3u8'
	  $url  = stringsplit($url, '/+', 2)
	  $user = $url[ubound($url) - 2]
	  $bid  = $url[ubound($url) - 1]
	  $path = @scriptdir & '\' & $user
	  if not fileexists($path) then dircreate($path)
	  runwait('ffmpeg -i ' & $result & ' -nostats -c copy ' & @scriptdir & '\' & $user & '\' & $bid & '.mp4', '', @SW_HIDE)
	  exitloop
   endif
next

exit
