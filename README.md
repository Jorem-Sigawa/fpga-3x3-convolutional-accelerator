# FPGA 3x3 Convolutional Accelerator
A configurable 3x3 convolutional accelerator for image processing. 
The design uses a streaming, pipelined architecture consisting of a scan module,
line buffers, a window generator, a signed multiply-accumulate (MAC) unit,
and an output clipper

The accelerator is written in Verilog and is to be implemented on the Digilent Zybo Z7-10 FPGA

<p align="center">
  <img src="architecture.png"
       alt="Architecture"
       width="850">
</p>
