# importing vlc module
import vlc
  
# importing time module
import time
import subprocess


v1 = "D:\Loki.S01E05.1080p.WEB.H264-EXPLOIT[rarbg]\Loki.S01E05.1080p.WEB.H264-EXPLOIT.mkv"
v2 = "D:\The.Suicide.Squad.2021.1080p.WEBRip.x264-RARBG.mp4" 
# creating vlc media player object
media_player = vlc.MediaPlayer()
  
# toggling full screen
media_player.toggle_fullscreen()
media_player.video_set_key_input(True)
  
def play(video, length):
    # media object
    media = vlc.Media(video)
    
    # setting media to the media player
    media_player.set_media(media)
    
    # start playing video
    media_player.play()
    
    # wait so the video can be played for 5 seconds
    # irrespective for length of video
    time.sleep(length)

play(v1, 10)
play(v2, 20)

# p = subprocess.Popen('vlc', v1, '--loop')