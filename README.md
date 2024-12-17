# resize-comparison

Analyzing the image scaling algorithms implemented in other libraries.

## Run

```bash
python3 test-resize.py input/radial.rgb.png

# ResampleScope
./resamplescope.sh
```

See [output/](output) directory.

## Output radial.rgb.png

**Notes**

- The 8x versions are used for comparison.

### Pillow reduce() vs libvips shrink()

| Pillow | libvips |
| :---: |  :---: |
| ![8x_pillow_reduce.png](output/8x_pillow_reduce.png) | ![8x_vips_shrink.png](output/8x_vips_shrink.png) |
| | Identical to Pillow |

### Pillow resize() vs libvips reduce()

| Pillow | libvips |
| :---: |  :---: |
| ![8x_pillow_resize.png](output/8x_pillow_resize.png) | ![8x_vips_reduce.png](output/8x_vips_reduce.png) |
| | Almost identical to Pillow¹ |

### Pillow resize(reducing_gap=2.0) vs libvips resize()

| Pillow | libvips |
| :---: |  :---: |
| ![8x_pillow_resize_gap.png](output/8x_pillow_resize_gap.png) | ![8x_vips_resize.png](output/8x_vips_resize.png) |
| | Almost identical to Pillow¹ |

### Footnotes

¹ Pillow is considering pixels outside the image as not exist, while libvips is expanding the edge pixels outside the image. 
  These different ways of edge handling are probably fine.

## Output ResampleScope

### ImageMagick box vs libvips nearest

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_box-out.png](output/pd_magick_box-out.png) | ![pd_vips_nearest-out.png](output/pd_vips_nearest-out.png) |
| | Identical to ImageMagick |

### ImageMagick triangle vs libvips linear

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_triangle-out.png](output/pd_magick_triangle-out.png) | ![pd_vips_linear-out.png](output/pd_vips_linear-out.png) |
| | Identical to ImageMagick |

### ImageMagick catrom vs libvips cubic

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_catrom-out.png](output/pd_magick_catrom-out.png) | ![pd_vips_cubic-out.png](output/pd_vips_cubic-out.png) |
| | Identical to ImageMagick |

### ImageMagick mitchell vs libvips mitchell

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_mitchell-out.png](output/pd_magick_mitchell-out.png) | ![pd_vips_mitchell-out.png](output/pd_vips_mitchell-out.png) |
| | Identical to ImageMagick |

### ImageMagick lanczos2 vs libvips lanczos2

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_lanczos2-out.png](output/pd_magick_lanczos2-out.png) | ![pd_vips_lanczos2-out.png](output/pd_vips_lanczos2-out.png) |
| | Identical to ImageMagick |

### ImageMagick lanczos vs libvips lanczos3

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_lanczos-out.png](output/pd_magick_lanczos-out.png) | ![pd_vips_lanczos3-out.png](output/pd_vips_lanczos3-out.png) |
| | Identical to ImageMagick |

### ImageMagick magickernelsharp2013 vs libvips mks2013

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_magickernelsharp2013-out.png](output/pd_magick_magickernelsharp2013-out.png) | ![pd_vips_mks2013-out.png](output/pd_vips_mks2013-out.png) |
| Seems to be wrongly implemented | |

### ImageMagick magickernelsharp2021 vs libvips mks2021

| ImageMagick | libvips |
| :---: |  :---: |
| ![pd_magick_magickernelsharp2021-out.png](output/pd_magick_magickernelsharp2021-out.png) | ![pd_vips_mks2021-out.png](output/pd_vips_mks2021-out.png) |
| | Identical to ImageMagick |

### Magic Kernel Sharp 2013 vs Magic Kernel Sharp 2021 (reference)

| Magic Kernel Sharp 2013 | Magic Kernel Sharp 2021 |
| :---: |  :---: |
| ![pd_mks2013_reference-out.png](output/pd_mks2013_reference-out.png) | ![pd_mks2021_reference-out.png](output/pd_mks2021_reference-out.png) |
| | |
