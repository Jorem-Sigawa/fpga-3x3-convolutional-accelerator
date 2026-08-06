// LATENCY = 5 cycles
// valid_out corresponds to acc.
// If valid_in is high when a00...a22 are sampled,
// valid_out will be high 5 cycles later.

//NO CLIPPER FUNCTIONALITY YET

module signed_mac3x3 ( 
    input clk, nrst, valid_in,
    input [7:0] a00,a01,a02,a10,a11,a12,a20,a21,a22, //brightness values
    input signed [7:0] b00,b01,b02,b10,b11,b12,b20,b21,b22, //kernel
    

    output reg signed [19:0] acc,
    output reg valid_out //valid_out must usually be a register per industry practice
);

reg signed [19:0] c00,c01,c02,c10,c11,c12,c20,c21,c22; //9 multiplier
reg signed [19:0] d01,d10,d12,d21; //1st layer of adder tree, make register width the full final width to avoid overflow
reg signed [19:0] e10,e21; //2nd layer of adder tree
reg signed [19:0] f21; //3rd layer of adder tree

reg signed [19:0] r2,r1,r0; //shift register for c22
reg [4:0] valid_pipe; //latency of 5. For future reference, if the same thing is referenced all over the code, use parameter 


always @ (posedge clk) begin
    if (!nrst) begin
        acc <= 0;
        valid_out <= 0;

        valid_pipe <= 5'b00000;
        {c00,c01,c02,c10,c11,c12,c20,c21,c22} <= '0; //compile with SystemVerilog
        {d01,d10,d12,d21} <= '0;
        {e10,e21} <= '0;
        f21 <= '0;
        {r2,r1,r0} <= '0;
    end
    else begin
        valid_pipe <= {valid_pipe[3:0], valid_in};
        valid_out <= valid_pipe[3];

        c00 <= $signed({1'b0, a00})*b00; //9 multiplier, $signed reduces one bit of range, adding another bit restores it
        c01 <= $signed({1'b0, a01})*b01;
        c02 <= $signed({1'b0, a02})*b02;
        c10 <= $signed({1'b0, a10})*b10;
        c11 <= $signed({1'b0, a11})*b11;
        c12 <= $signed({1'b0, a12})*b12;
        c20 <= $signed({1'b0, a20})*b20;
        c21 <= $signed({1'b0, a21})*b21;
        c22 <= $signed({1'b0, a22})*b22;

        d01 <= c00 + c01; //1st layer of adder tree
        d10 <= c02 + c10;
        d12 <= c11 + c12;
        d21 <= c20 + c21;
        r2 <= c22;

        e10 <= d01+ d10; //2nd layer of adder tree
        e21 <= d12 + d21;
        r1 <= r2;

        f21 <= e10 + e21; //3rd layer of adder tree
        r0 <= r1;

        
        acc <= f21 + r0; //final sum
    end
end
endmodule
