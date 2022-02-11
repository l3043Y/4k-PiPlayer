$vlc = '"C:\Program Files\VideoLAN\VLC\vlc.exe" '
$loopOneVideo = '--control="none" -R -f '

$full_path_videos = Get-ChildItem E:\* -Recurse -Include "*.mp4","*.MP4","*.Mp4", "*.hevc" | ForEach-Object { "$_" }
$JoinedString = '"' + ($full_path_videos -join '" "' ) + '"'
$loopMultipleFiles = $vlc + $loopOneVideo + $JoinedString

Invoke-Expression "& $loopMultipleFiles"