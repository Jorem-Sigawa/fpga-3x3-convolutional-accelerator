`timescale 1ns/1ps

//Drive inputs on negedge.
//Let DUT update on posedge.
//Observe outputs on negedge.

module line_buffer_tb;

parameter WIDTH  = 4;
parameter HEIGHT = 4;

reg clk;
reg nrst;
reg start;
reg [7:0] pixel_in;

wire [11:0] scan;
wire [11:0] iteration;

wire valid_out;
wire [7:0] w0;
wire [7:0] w1;
wire [7:0] w2;

// DUT
line_buffer uut (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .pixel_in(pixel_in),
    .width(WIDTH[11:0]),
    .height(HEIGHT[11:0]),
    .count(scan),
    .current_height(iteration),
    .valid_out(valid_out),
    .w0(w0),
    .w1(w1),
    .w2(w2)
);

// External scan module used by line_buffer
scan sc (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .width(WIDTH[11:0]),
    .height(HEIGHT[11:0]),
    .scan(scan),
    .iteration(iteration)
);

// Clock: 10 ns period
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;

// Main stimulus
initial begin
    $dumpfile("sim/line_buffer_tb.vcd");
    $dumpvars(0, line_buffer_tb);

    nrst = 0;
    start = 0;
    pixel_in = 0;

    // Hold reset for a few cycles
    repeat (3) @(negedge clk);
    nrst = 1;

    // Put first pixel before asserting start
    @(negedge clk);
    start = 1;

    // One-cycle start pulse
    @(negedge clk);
    start = 0;

    // Feed remaining pixels:
    //
    //  0  1  2  3
    //  4  5  6  7
    //  8  9 10 11
    // 12 13 14 15
    //
    for (i = 1; i < WIDTH*HEIGHT; i = i + 1) begin
        @(negedge clk);
        pixel_in = i[7:0];
    end

    // Let pipeline/buffer settle
    repeat (10) @(negedge clk);

    $finish;
end

// Debug print after DUT has updated
always @(negedge clk) begin
    if (nrst) begin
        $display(
            "t=%0t | start=%b pixel_in=%0d scan=%0d iter=%0d valid=%b | w0=%0d w1=%0d w2=%0d | lb1={%0d,%0d,%0d,%0d} lb2={%0d,%0d,%0d,%0d}",
            $time,
            start,
            pixel_in,
            scan,
            iteration,
            valid_out,
            w0,
            w1,
            w2,
            uut.line_buffer1[0],
            uut.line_buffer1[1],
            uut.line_buffer1[2],
            uut.line_buffer1[3],
            uut.line_buffer2[0],
            uut.line_buffer2[1],
            uut.line_buffer2[2],
            uut.line_buffer2[3]
        );
    end
end

endmodule