module accelerator_tb;

parameter WIDTH = 512;
parameter HEIGHT = 512;

reg clk;
reg nrst;
reg start;
reg valid_in;
reg [7:0] pixel_in;

wire signed [7:0] b00 = -8'sd2;
wire signed [7:0] b01 = -8'sd1;
wire signed [7:0] b02 = 8'sd0;

wire signed [7:0] b10 = -8'sd1;
wire signed [7:0] b11 = 8'sd1;
wire signed [7:0] b12 = 8'sd1;

wire signed [7:0] b20 = -8'sd0;
wire signed [7:0] b21 = 8'sd1;
wire signed [7:0] b22 = 8'sd2;

wire [7:0] pixel_out;
wire valid_out;

reg [7:0] image_mem [0:WIDTH*HEIGHT-1]; //loads image into memory

integer i;
integer outfile; //file handle
integer out_count;

top_module uut (
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .width(WIDTH),
    .height(HEIGHT),
    .pixel_in(pixel_in),

    .b00(b00),
    .b01(b01),
    .b02(b02),
    .b10(b10),
    .b11(b11),
    .b12(b12),
    .b20(b20),
    .b21(b21),
    .b22(b22),

    .pixel_out(pixel_out),
    .valid_out(valid_out)
);

//clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;  
end

//read input image and feed pixels
initial begin //code is executed sequentially inside the same initial block
    $readmemh("sim/image.hex", image_mem);

    nrst = 0;
    start = 0;
    valid_in = 0;
    pixel_in = 8'd0;

    repeat (5) @(posedge clk);
    nrst = 1;

    repeat (2) @(posedge clk);
    start = 1;
    valid_in = 1;

    for (i=0; i < WIDTH*HEIGHT; i = i + 1) begin //prefer over always @ (posedge clk) if there is a definitive end to the process
        @(negedge clk); 
        pixel_in = image_mem[i];
    end

    start = 0; //might be problematic
end

//write output pixels
initial begin
    outfile = $fopen("sim/output.hex", "w");
    out_count = 0;

end

always @(posedge clk) begin
    if (valid_out) begin
        $fwrite(outfile, "%02x\n", pixel_out); //format string
        out_count = out_count + 1;

        if (out_count == (WIDTH-2)*(HEIGHT-2)) begin
            $fclose(outfile);
            $finish;
        end
    end
end

integer cycle_count;

initial begin
    cycle_count = 0;
end

always @(posedge clk) begin
    cycle_count = cycle_count + 1;

    if (cycle_count % 10000 == 0) begin
        $display("cycle=%0d start=%b pixel_in=%0d valid_out=%b pixel_out=%0d out_count=%0d",
                 cycle_count, start, pixel_in, valid_out, pixel_out, out_count);
    end
end

endmodule