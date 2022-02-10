# Import module
from tkinter import *
# importing vlc module
import vlc
# importing time module
import time
# from threading import Thread
import sys
import os
from threading import Thread

v1 = "D:\Loki.S01E05.1080p.WEB.H264-EXPLOIT[rarbg]\Loki.S01E05.1080p.WEB.H264-EXPLOIT.mkv"
v2 = "D:\The.Suicide.Squad.2021.1080p.WEBRip.x264-RARBG.mp4"


# creating vlc media player object
media_player = vlc.MediaPlayer()
  
# toggling full screen
media_player.toggle_fullscreen()
media_player.video_set_key_input(True)


def terminate(e):
    print("Terminated")
    quit()

def play(video, length):
    # media object
    media = vlc.Media(video)
    media_player.set_media(media)
    media_player.play()
    time.sleep(length)

def tk():
    # Execute tkinter
    root.mainloop()

if __name__ == "__main__":
    
    # thread = Thread(target = tk)
    vlc_player = Thread(target = play, args=(v1,0))
    vlc_player.start()
    vlc_player.join()
    
    # Create object
    root = Tk()

    # root.attributes('-alpha',0.01)
    root.attributes('-alpha',0.5)
    root.attributes('-topmost', True)
    root.attributes("-fullscreen", True)

    root.bind("<Escape>", lambda e: terminate(e))
    root.bind("<F11>", lambda e: vlc_player.raise_exception())
    
    root.mainloop()

    print("thread finished...exiting")