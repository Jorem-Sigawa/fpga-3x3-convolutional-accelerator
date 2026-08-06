from PIL import Image

WIDTH  = 512
HEIGHT = 512

OUT_W = WIDTH - 2
OUT_H = HEIGHT - 2

pixels = []

with open("output.hex","r") as f:
    for line in f:
        pixels.append(int(line.strip(), 16))

img = Image.new("L", (OUT_W, OUT_H)) #L for luminance/grayscale
img.putdata(pixels)
img.save("processed.png")