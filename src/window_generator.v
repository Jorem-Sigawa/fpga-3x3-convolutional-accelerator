//latency of 3 clock cycles
//last pixel processed when count = (width - 2)*(height-2)
module window_generator (
    input clk, nrst, start, valid_in, 
    input [11:0] scan, //scan here is the number of the pixel at that row (ex. if current pixel is 5th in a row then scan is 5)
    input [11:0] current_height,
    input [11:0] width,
    input [11:0] height, //height of image
    input [7:0] w0,w1,w2, //w2 is tied to pixzel_in
    output reg [7:0] M [8:0], //the window 
    output reg valid_out
);

reg [1:0] state;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

wire s2_condition;
assign s2_condition = (valid_in && current_height == height);

reg [1:0] s2_condition_pipe;

always @ (posedge clk) begin

    if (!nrst) begin
        state <= S0;
        valid_out <= 0;
        s2_condition_pipe <= 1'b0;
    end

    else begin

        case(state)

            S0:begin
                if (start) begin
                    state <= S1;
                end
            end

            S1:begin
                if (valid_in) begin
                    //shift second column to first column
                    M[0] <= M[1];
                    M[3] <= M[4];
                    M[6] <= M[7];

                    //shift third column to second column
                    M[1] <= M[2];
                    M[4] <= M[5];
                    M[7] <= M[8];

                    //get new values from line_buffer.v
                    M[2] <= w0;
                    M[5] <= w1;
                    M[8] <= w2;

                end

                s2_condition_pipe <= s2_condition;

                if (s2_condition_pipe[0]) begin //pipeline needed
                    state <= S2;
                end

                valid_out <= ((scan >= 3)||(scan == 0)) && (current_height >= 3); 
            end

            S2:begin
                state <= S2;
            end

        endcase
    end 

end
endmodule