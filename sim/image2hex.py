from PIL import Image

img = Image.open("input.png").convert("L")  # grayscale
width, height = img.size

pixels = list(img.getdata())

with open("image.hex", "w") as f:
    for p in pixels:
        f.write(f"{p:02x}\n")

print(width, height)