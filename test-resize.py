# https://github.com/libvips/pyvips/issues/148
import sys
import timeit
import pyvips
from PIL import Image

image = sys.argv[1]
number, repeat = 10, 3

pyvips.cache_set_max_mem(0)
im = pyvips.Image.new_from_file(image)
print(f'\nSize: {im.width}x{im.height}')
for scale in [8, 9.4, 16]:
    for method, call in [
        ('shrink', lambda im, scale: im.shrink(scale, scale, ceil=True)),
        ('reduce', lambda im, scale: im.reduce(scale, scale)),
        ('resize', lambda im, scale: im.resize(1 / scale, vscale=1 / scale)),
    ]:
        fname = f'output/{scale}x_vips_{method}.png'
        call(im, scale).write_to_file(fname)

        time = min(timeit.repeat(
            lambda: call(im, scale).copy_memory(),
            repeat=repeat, number=number)) / number
        print(f'{fname}: {time:2.6f}s')

im = Image.open(image)
print(f'\nSize: {im.width}x{im.height}')
for scale in [8, 9.4, 16]:
    for method, call in [
        ('reduce', lambda im, scale: im.reduce((scale, scale))),
        ('resize', lambda im, scale:
        im.resize((round(im.width / scale), round(im.height / scale)), Image.LANCZOS)),
        ('resize_gap', lambda im, scale:
        im.resize((round(im.width / scale), round(im.height / scale)),
                  Image.LANCZOS, reducing_gap=2.0)),
    ]:
        try:
            fname = f'output/{scale}x_pillow_{method}.png'
            call(im, scale).save(fname)

            time = min(timeit.repeat(
                lambda: call(im, scale),
                repeat=repeat, number=number)) / number
            print(f'{fname}: {time:2.6f}s')
        except TypeError:
            # reduce doesn't work with float scales
            pass
