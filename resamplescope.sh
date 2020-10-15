#!/usr/bin/env bash

if [ -d "$PWD/resamplescope" ]; then
  echo "Skip cloning, ResampleScope already exists at $PWD/resamplescope"
  cd $PWD/resamplescope
else
  git clone https://github.com/jsummers/resamplescope.git
  cd resamplescope && make
  ./rscope -gen
fi

magick_filters=(box triangle catrom mitchell lanczos2 lanczos)
for filter in "${magick_filters[@]}"; do
  convert pd.png -filter $filter -resize '555x275!' pd_magick_$filter.png
  ./rscope -name "$filter resize with ImageMagick" -nologo pd_magick_$filter.png ../output/pd_magick_$filter-out.png
done

vips_kernels=(nearest linear cubic mitchell lanczos2 lanczos3)
for kernel in "${vips_kernels[@]}"; do
  vips resize pd.png pd_vips_$kernel.png 0.996409336 --vscale 1.0 --kernel $kernel
  ./rscope -name "$kernel resize with libvips" -nologo pd_vips_$kernel.png ../output-patch/pd_vips_$kernel-out.png
done

for i in "${!vips_kernels[@]}"; do 
  filter="${magick_filters[$i]}"
  kernel="${vips_kernels[$i]}"

  ./rscope -name "$kernel resize with libvips" -name2 "$filter resize with ImageMagick" -nologo \
    pd_vips_$kernel.png pd_magick_$filter.png ../output-compare/magick-vips-$kernel-out.png
done
