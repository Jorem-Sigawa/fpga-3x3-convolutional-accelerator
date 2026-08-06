`timescale 1ns/1ps

module window_generator_tb;

parameter WIDTH = 5;
parameter HEIGHT = 5;

reg [7:0] pixel_in;

reg clk;
reg nrst;
reg start;

wire voutLB;
wire [11:0] scan;
wire[11:0] iteration;

wire [7:0] w0;
wire [7:0] w1;
wire [7:0] w2;

wire valid_out;
wire [7:0] M [8:0];

scan sc (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .width(WIDTH[11:0]),
    .height(HEIGHT[11:0]),
    .scan(scan),
    .iteration(iteration)
);

line_buffer lb (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .pixel_in(pixel_in),
    .width(WIDTH[11:0]),
    .height(HEIGHT[11:0]),
    .count(scan),
    .current_height(iteration),
    .valid_out(voutLB),
    .w0(w0),
    .w1(w1),
    .w2(w2)
);

//DUT
window_generator wg (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .valid_in(voutLB),
    .scan(scan),
    .current_height(iteration),
    .width(WIDTH),
    .height(HEIGHT),
    .w0(w0),
    .w1(w1),
    .w2(w2),
    .valid_out(valid_out),
    .M(M)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;

//main stimulus
initial begin
    $dumpfile("sim/window_generator_tb.vcd");
    $dumpvars(0, window_generator_tb);

    nrst = 0;
    start = 0;
    pixel_in = 0;

    repeat (3) @(negedge clk);
    nrst = 1;

    @(negedge clk);
    start = 1;

    @(negedge clk);
    start = 0;

    for (i=1; i < WIDTH*HEIGHT; i = i+1) begin
        @(negedge clk);
        pixel_in = i;
    end

    repeat (10) @(negedge clk);
    $finish;
end

always @(negedge clk) begin
    $display("t=0%t | scan=%0d iteration=%0d valid=%b voutLB=%b | w0=%0d w1=%0d w2=%0d | l0=%0d l1=%0d l2=%0d",
                $time,
                scan,
                iteration,
                valid_out,
                voutLB,
                w0,
                w1,
                w2,
                lb.line_buffer1[scan],
                lb.line_buffer2[scan],
                pixel_in);

    $display("%d %d %d", M[0], M[1], M[2]);
    $display("%d %d %d", M[3], M[4], M[5]);
    $display("%d %d %d", M[6], M[7], M[8]);
end
endmodule;