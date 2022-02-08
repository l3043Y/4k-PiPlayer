from gpiozero import Button
from signal import pause
from time import sleep
import vlc

# creating vlc media player object
media_player = vlc.MediaPlayer()
  
# toggling full screen
media_player.toggle_fullscreen()
media = vlc.Media("/media/pi/looper/v1440p.mp4")
    
# setting media to the media player
media_player.set_media(media)

def print_button_label(button):
    if button.pin == 2:
        print("prev")

def play_video():
    print("play")
    # media object
    
    
    # start playing video
    media_player.play()
    
    # wait so the video can be played for 5 seconds
    # irrespective for length of video
    # sleep(20)

prevButton = Button(2)
playButton = Button(3)
nextButton = Button(4)

prevButton.when_pressed = lambda: print("prev")
playButton.when_pressed = play_video
nextButton.when_pressed = lambda: print("next")

# playButton.wait_for_release()
# print('tst')


# sleep(100)
pause()