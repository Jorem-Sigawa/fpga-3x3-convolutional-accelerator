`timescale 1ns/1ps

module scan_tb;

parameter WIDTH = 4;
parameter HEIGHT = 4;

reg clk;
reg nrst;
reg start;

wire [11:0] scan;
wire [11:0] iteration;

scan uut (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .width(WIDTH),
    .height(HEIGHT),
    .scan(scan),
    .iteration(iteration)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("sim/scan_tb.vcd");
    $dumpvars(0, scan_tb);

    nrst = 0;
    start = 0;

    repeat (3) @(posedge clk);
    nrst = 1;

    @(posedge clk);
    start = 1;

    repeat (35) @(posedge clk);
    $finish;
end

always @(posedge clk) begin
    $display("start=%b scan=%0d iteration=%0d", start, scan, iteration);
end

endmodule