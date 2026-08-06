module top_module (
    input clk, nrst, start,
    input [11:0] width, height,
    input [7:0] pixel_in,

    input signed [7:0] b00, b01, b02,
    input signed [7:0] b10, b11, b12,
    input signed [7:0] b20, b21, b22,

    output [7:0] pixel_out,
    output wire valid_out
);

wire [11:0] scan;
wire [11:0] iteration;

wire voutLB;
wire [7:0] w0;
wire [7:0] w1;
wire [7:0] w2;

wire voutWGEN;
wire [7:0] M [8:0];

wire voutMAC;
wire signed [19:0] acc;

scan sc (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .width(width),
    .height(height),
    .scan(scan),
    .iteration(iteration)
);

line_buffer lb (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .pixel_in(pixel_in),
    .width(width),
    .height(height),
    .count(scan),
    .current_height(iteration),
    .valid_out(voutLB),
    .w0(w0),
    .w1(w1),
    .w2(w2)
);

window_generator wg (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .valid_in(voutLB),
    .scan(scan),
    .current_height(iteration),
    .width(width),
    .height(height),
    .w0(w0),
    .w1(w1),
    .w2(w2),
    .valid_out(voutWGEN),
    .M(M)
);

signed_mac3x3 mac (
    .clk(clk),
    .nrst(nrst),
    .valid_in(voutWGEN),

    .a00(M[0]),
    .a01(M[1]),
    .a02(M[2]),
    .a10(M[3]),
    .a11(M[4]),
    .a12(M[5]),
    .a20(M[6]),
    .a21(M[7]),
    .a22(M[8]),

    .b00(b00),
    .b01(b01),
    .b02(b02),
    .b10(b10),
    .b11(b11),
    .b12(b12),
    .b20(b20),
    .b21(b21),
    .b22(b22),

    .acc(acc),
    .valid_out(voutMAC)
);

clipper clip (
    .valid_in(voutMAC),
    .acc(acc),
    .res(pixel_out),
    .valid_out(valid_out)
);

endmodule