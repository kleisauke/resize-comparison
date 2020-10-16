from PIL import Image

im = Image.open("pd.png")

filter_map = {Image.NEAREST: 'nearest',
              Image.BOX: 'box',
              Image.BILINEAR: 'bilinear',
              Image.HAMMING: 'hamming',
              Image.BICUBIC: 'bicubic',
              Image.LANCZOS: 'lanczos'}

for key, value in filter_map.items():
    im_resized = im.resize((555, 275), key).save(f'pd_pillow_{value}.png')
