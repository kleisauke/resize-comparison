#!/usr/bin/env bash

set -e

if [ -d "$PWD/resamplescope" ]; then
  echo "Skip cloning, ResampleScope already exists at $PWD/resamplescope"
  cd $PWD/resamplescope
else
  git clone https://github.com/jsummers/resamplescope.git
  cd resamplescope && make
  ./rscope -gen
  ./rscope -gen -r
fi

# ImageMagick

magick_filters=(box triangle catrom mitchell lanczos2 lanczos)
for filter in "${magick_filters[@]}"; do
  convert pd.png -filter $filter -resize '555x275!' pd_magick_$filter.png
  ./rscope -name "$filter resize with ImageMagick" -nologo pd_magick_$filter.png ../output/pd_magick_$filter-out.png
done

# libvips

# Check features
#vips --features

# SSE2
#export VIPS_SIMD=1
# SSE2, SSE4.1
#export VIPS_SIMD=3
# SSE2, SSE4.1, AVX2
#export VIPS_SIMD=7

error_code=0
vips --vips-nosimd || error_code=$?
if [ $error_code -ne 0 ]; then
  VECTOR=true
  NAME="orc"
else
  SIMD=true
  NAME="simd"
fi

vips_kernels=(nearest linear cubic mitchell lanczos2 lanczos3)
for kernel in "${vips_kernels[@]}"; do
  # C paths
  vips reducev pdr.png pdr_vips_$kernel.png 1.003603604 --kernel $kernel ${VECTOR:+--vips-novector} ${SIMD:+--vips-nosimd}
  ./rscope -name "$kernel reducev with libvips" -nologo -r pdr_vips_$kernel.png ../output-patch/pdr_vips_$kernel-out.png
  vips reduceh pd.png pd_vips_${NAME}_$kernel.png 1.003603604 --kernel $kernel ${VECTOR:+--vips-novector} ${SIMD:+--vips-nosimd}
  ./rscope -name "$kernel reduceh with libvips" -nologo pd_vips_$kernel.png ../output-patch/pd_vips_$kernel-out.png

  # SIMD / orc paths
  vips reducev pdr.png pdr_vips_${NAME}_$kernel.png 1.003603604 --kernel $kernel
  ./rscope -name "$kernel reducev with libvips ($NAME path)" -nologo -r pdr_vips_${NAME}_$kernel.png ../output-patch/pdr_vips_${NAME}_$kernel-out.png
  if [ "$SIMD" = "true" ]; then
    # vectorized reduceh is only implemented on the simd branch
    vips reduceh pd.png pd_vips_${NAME}_$kernel.png 1.003603604 --kernel $kernel
    ./rscope -name "$kernel reduceh with libvips ($NAME path)" -nologo pd_vips_${NAME}_$kernel.png ../output-patch/pd_vips_${NAME}_$kernel-out.png
  fi

  # Comparison
  ./rscope -name "$kernel reducev with libvips ($NAME path)" -name2 "$kernel reducev with libvips (C path)" -nologo -r \
    pdr_vips_${NAME}_$kernel.png pdr_vips_$kernel.png ../output-compare/vips-$NAME-$kernel-out.png
done

for i in "${!vips_kernels[@]}"; do 
  filter="${magick_filters[$i]}"
  kernel="${vips_kernels[$i]}"

  ./rscope -name "$kernel resize with libvips" -name2 "$filter resize with ImageMagick" -nologo \
    pd_vips_$kernel.png pd_magick_$filter.png ../output-compare/magick-vips-$kernel-out.png
done

# Pillow-SIMD

python3 ../pillow-resamplescope.py

pillow_filters=(nearest box bilinear hamming bicubic lanczos)
for i in "${!pillow_filters[@]}"; do 
  filter="${pillow_filters[$i]}"

  ./rscope -name "$filter resize with Pillow" -nologo pd_pillow_$filter.png ../output/pd_pillow_$filter-out.png
done
