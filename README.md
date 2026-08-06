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
Two-dimensional convolution is a critical operation in image processing that allows us to detect or extract features of an image.
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


Kernels are often designed to make certain features of an image more visible.

![Sobel Edge](assets/sobel_edge.jpg) 
