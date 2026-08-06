from PIL import Image

img = Image.open("test_rgb.tiff").convert("RGB")

pixels = list(img.getdata())

with open("test_rgb.hex", "w") as f:
    for p in pixels:
        p = " ".join( [f"{v:02x}" for v in p] ) + '\n'
        f.write(p)
