from PIL import Image

WIDTH = 512
HEIGHT = 512

OUT_W = WIDTH - 2
OUT_H = HEIGHT - 2

pixels = []

outfile = "output_test_rgb.hex"
with open(outfile,"r") as f:
    for line in f:
        p = tuple(int(v, 16) for v in line.strip().split())
        pixels.append(p)

print(pixels[0:10])
img = Image.new("RGB", (OUT_W, OUT_H))
img.putdata(pixels)
img.save("test_rgb_processed.png")