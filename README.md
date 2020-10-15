# pyvips issue #148

Test case for [libvips/pyvips#148](https://github.com/libvips/pyvips/issues/148).

## Run

```bash
# Debug
G_MESSAGES_DEBUG=all python3 test-resize.py input/radial.rgb.png

# Disable the vector path
VIPS_NOVECTOR=1 python3 test-resize.py input/radial.rgb.png

# ResampleScope
./resamplescope.sh
```

See [output/](output) directory.

## Output radial.rgb.png

**Notes**

- The output images were produced with the vector path disabled (due to [libvips/libvips#1518](https://github.com/libvips/libvips/issues/1518)).
- The **VIPS after** result is based upon pull request [libvips/libvips#1769](https://github.com/libvips/libvips/pull/1769).
- The 8x versions are used for comparison.

### Pillow reduce() vs VIPS shrink()

| Pillow | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![8x_pillow_reduce.png](output/8x_pillow_reduce.png) | ![8x_vips_shrink.png](output/8x_vips_shrink.png) | ![8x_vips_shrink.png](output-patch/8x_vips_shrink.png) |
| | Last column is missing | Identical to Pillow |

### Pillow resize() vs VIPS reduce()

| Pillow | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![8x_pillow_resize.png](output/8x_pillow_resize.png) | ![8x_vips_reduce.png](output/8x_vips_reduce.png) | ![8x_vips_reduce.png](output-patch/8x_vips_reduce.png) |
| | Almost identical to Pillow¹ | Identical to previous image |

### Pillow resize(reducing_gap=2.0) vs VIPS resize()

| Pillow | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![8x_pillow_resize_gap.png](output/8x_pillow_resize_gap.png) | ![8x_vips_resize.png](output/8x_vips_resize.png) | ![8x_vips_resize.png](output-patch/8x_vips_resize.png) |
| | Last column is missing | Almost identical to Pillow¹ |

### Footnotes

¹ Pillow is considering pixels outside of the image as not exist, while VIPS is expanding the edge pixels outside of the image. 
  These different ways of edge handling are probably fine.

## TODO

- The vector path currently does not have the same precision as the C path (see [libvips/libvips#1518](https://github.com/libvips/libvips/issues/1518)).
- `vips_shrink()` matches the output of Pillow, should `vips_reduce()` do the same?

## Output ResampleScope

**Notes**

- The **VIPS after** result is based upon pull request [libvips/libvips#1769](https://github.com/libvips/libvips/pull/1769).

### magick box vs VIPS nearest

| magick | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![pd_magick_box-out.png](output/pd_magick_box-out.png) | ![pd_vips_nearest-out.png](output/pd_vips_nearest-out.png) | ![pd_vips_nearest-out.png](output-patch/pd_vips_nearest-out.png) |
| | Identical to magick | Missing +0.5 shift |

### magick triangle vs VIPS linear

| magick | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![pd_magick_triangle-out.png](output/pd_magick_triangle-out.png) | ![pd_vips_linear-out.png](output/pd_vips_linear-out.png) | ![pd_vips_linear-out.png](output-patch/pd_vips_linear-out.png) |
| | Precision / rounding error | Identical to previous image |

### magick catrom vs VIPS cubic

| magick | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![pd_magick_catrom-out.png](output/pd_magick_catrom-out.png) | ![pd_vips_cubic-out.png](output/pd_vips_cubic-out.png) | ![pd_vips_cubic-out.png](output-patch/pd_vips_cubic-out.png) |
| | Precision / rounding error | Identical to previous image |

### magick mitchell vs VIPS mitchell

| magick | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![pd_magick_mitchell-out.png](output/pd_magick_mitchell-out.png) | ![pd_vips_mitchell-out.png](output/pd_vips_mitchell-out.png) | ![pd_vips_mitchell-out.png](output-patch/pd_vips_mitchell-out.png) |
| | Precision / rounding error | Identical to previous image |

### magick lanczos2 vs VIPS lanczos2

| magick | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![pd_magick_lanczos2-out.png](output/pd_magick_lanczos2-out.png) | ![pd_vips_lanczos2-out.png](output/pd_vips_lanczos2-out.png) | ![pd_vips_lanczos2-out.png](output-patch/pd_vips_lanczos2-out.png) |
| | Precision / rounding error | Identical to previous image |

### magick lanczos vs VIPS lanczos3

| magick | VIPS before | VIPS after |
| :---: |  :---: |  :---: |
| ![pd_magick_lanczos-out.png](output/pd_magick_lanczos-out.png) | ![pd_vips_lanczos3-out.png](output/pd_vips_lanczos3-out.png) | ![pd_vips_lanczos3-out.png](output-patch/pd_vips_lanczos3-out.png) |
| | Precision / rounding error | Identical to previous image |
