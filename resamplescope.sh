#!/usr/bin/env bash

if [ -d "$PWD/resamplescope" ]; then
  echo "Skip cloning, ResampleScope already exists at $PWD/resamplescope"
  cd $PWD/resamplescope
else
  git clone https://github.com/jsummers/resamplescope.git
  cd resamplescope && make
  ./rscope -gen
  ./rscope -gen -r
fi

magick_filters=(box triangle catrom mitchell lanczos2 lanczos)
for filter in "${magick_filters[@]}"; do
  convert pd.png -filter $filter -resize '555x275!' pd_magick_$filter.png
  ./rscope -name "$filter resize with ImageMagick" -nologo pd_magick_$filter.png ../output/pd_magick_$filter-out.png
done

vips cast pdr.png pdr.v uint

vips_kernels=(nearest linear cubic mitchell lanczos2 lanczos3)
for kernel in "${vips_kernels[@]}"; do
  #vips reduceh pd.png pd_vips_$kernel.png 1.003603604 --kernel $kernel
  #vips reducev pdr.png pdr_vips_$kernel.png 1.003603604 --kernel $kernel --vips-novector
  #vips reducev pdr.png pdr_vips_orc_$kernel.png 1.003603604 --kernel $kernel
  vips reducev pdr.v pdr_vips_simd_$kernel.png 1.003603604 --kernel $kernel
  #./rscope -name "$kernel reduceh with libvips" -nologo pd_vips_$kernel.png ../output-patch/pd_vips_$kernel-out.png
  #./rscope -name "$kernel reducev with libvips" -nologo -r pdr_vips_$kernel.png ../output-patch/pdr_vips_$kernel-out.png
  #./rscope -name "$kernel reducev with libvips (orc path)" -nologo -r pdr_vips_orc_$kernel.png ../output-patch/pdr_vips_orc_$kernel-out.png
  ./rscope -name "$kernel reducev with libvips (simd path)" -nologo -r pdr_vips_simd_$kernel.png ../output-patch/pdr_vips_simd_$kernel-out.png
done

for i in "${!vips_kernels[@]}"; do 
  filter="${magick_filters[$i]}"
  kernel="${vips_kernels[$i]}"

  ./rscope -name "$kernel resize with libvips" -name2 "$filter resize with ImageMagick" -nologo \
    pd_vips_$kernel.png pd_magick_$filter.png ../output-compare/magick-vips-$kernel-out.png
done

python3 ../pillow-resamplescope.py

pillow_filters=(nearest box bilinear hamming bicubic lanczos)
for i in "${!pillow_filters[@]}"; do 
  filter="${pillow_filters[$i]}"

  ./rscope -name "$filter resize with Pillow" -nologo pd_pillow_$filter.png ../output/pd_pillow_$filter-out.png
done
