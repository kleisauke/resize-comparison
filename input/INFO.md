# Image provenance

[`radial.rgb.png`](radial.rgb.png):
```console
$ vips zone t1.v 4094 4090 --uchar
$ vips crop t1.v t2.v 2047 2045 2047 2045
$ vips bandjoin "t2.v t2.v t2.v" t3.v
$ vips embed t3.v radial.rgb.png 1 1 2049 2047 --background "255 0 0"
$ rm t*.v
```
