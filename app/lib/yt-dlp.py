import sys
import yt_dlp

ydl = yt_dlp.YoutubeDL({
    "format": "best",
    "outtmpl": sys.argv[2] + "%(title)s" + ".mp4"
})

url = sys.argv[1]

result = ydl.download(url)