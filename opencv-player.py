import cv2
v1 = "D:\Loki.S01E05.1080p.WEB.H264-EXPLOIT[rarbg]\Loki.S01E05.1080p.WEB.H264-EXPLOIT.mkv"
v2 = "D:\The.Suicide.Squad.2021.1080p.WEBRip.x264-RARBG.mp4" 
def play_videoFile(filePath,mirror=False):

    cap = cv2.VideoCapture(filePath)
    cv2.namedWindow('Video Life2Coding',cv2.WINDOW_AUTOSIZE)
    while True:
        ret_val, frame = cap.read()

        if mirror:
            frame = cv2.flip(frame, 1)

        cv2.imshow('Video Life2Coding', frame)

        if cv2.waitKey(1) == 27:
            break  # esc to quit

    cv2.destroyAllWindows()

def main():
    play_videoFile(v1,mirror=False)

if __name__ == '__main__':
    main()