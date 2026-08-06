# FPGA 3x3 Convolutional Accelerator

<p align="justify">
A configurable 3x3 convolutional accelerator for image processing. 
The design uses a streaming, pipelined architecture consisting of a scan module,
line buffers, a window generator, a signed multiply-accumulate (MAC) unit,
and an output clipper
</p>

The accelerator is written in Verilog and is to be implemented on the Digilent Zybo Z7-10 FPGA

<p align="center">
  <img src="assets/architecture.png"
       alt="Architecture"
       width="850">
</p>

## Overview

<p align="justify">
Two-dimensional convolution is a critical operation in image processing that allows us to detect and extract features of an image.
It works as follows: an NxN matrix of coefficients, referred to as the kernel, is slid across an image in raster order and "convolved" with the overlapping NxN patch of the input image.
To "convolve" in this case means to multiply the overlapping scalars in the patch (the coefficients and the pixel values) and sum all NxN products.
The accumulated result then becomes the pixel value for the new, processed image.
</p>

<p align="center">
  <img
    src="assets/A_simple_image_convolution.gif"
    alt="Convolution process"
    width="700"
  >
</p>


Kernels are often designed to emphasize certain features of an image. A famous example is the Sobel filter, which emphasizes horizontal and vertical edges of an image.

<p align="center">
  <img
    src="assets/sobel_edge.jpg"
    alt="Sobel Edge"
    width="400"
  >
</p>

<p align="justify">
Modern CPUs could run convolutional math, but for applications requiring fast response and minimal power consumption,
they are too slow and require too much power. For instance, a single MAC operation on an NxN window executed on a CPU needs to
compute N² products (and hence N² steps), whereas a specialized accelerator could compute all N²
products in a single step by parallelizing the multiply operation. Furthermore, in a CPU, huge amounts of energy are wasted by moving filter
coefficients back and forth from memory. A dedicated convolutional accelerator avoids this by storing the values statically in a dedicated
memory block.

With the rise of Convolutional Neural Networks (CNNs), where multiple convolutions are performed repeatedly on an image, there is a
rapidly growing need for specialized convolutional accelerators that could perform inference quickly on energy-constrained edge devices.
</p>

## Features
- Streaming pixel input
- Configurable signed 3×3 convolution kernel
- Two-line pixel buffer for spatial data reuse
- Parallel nine-element multiply–accumulate operation
- Signed convolution results
- Output clipping to the supported pixel range
- Module-level and full-accelerator testbenches
- Image-to-hex and hex-to-image simulation utilities
- Targeted for the Zybo Z7-10 FPGA

## Architecture

The accelerator consists of the following processing stages:

1. **Scan controller**  
   Tracks the current image row and column.

2. **Line buffer**  
   Stores pixels from the previous two image rows.

3. **Window generator**  
   combines buffered and incoming pixels into a 3×3 neighborhood.

4. **Signed 3×3 MAC**  
   Multiplies the nine pixels by the nine signed kernel coefficients and sums
   the products.

5. **Clipper**  
   Restricts the convolution result to the valid output-pixel range.

