module scan ( //ASM implementation of an automatically repeating counter
    input clk, nrst, start, //synchronous variables
    input [11:0] height,
    input [11:0] width,
    output reg [11:0] scan, //12 bits to process 4k images
    output reg [11:0] iteration //corresponds to how many rows have been processed in the line_buffer, current_height = iterations
);


reg [1:0] state;

localparam S0 = 2'b00; //start
localparam S1 = 2'b01; //scan row
localparam S2 = 2'b10; //reset and repeat
localparam S3 = 2'b11; //stop until rst


always @(posedge clk) begin
    if (!nrst) begin
        state <= S0;
        scan <= 0;
        iteration <= 0;
    end
    else begin
        case (state)

            S0: begin
                if (start) begin
                    scan <= 0;
                    state <= S1;
                end
                else begin
                    state <= S0;
                end
            end

            S1: begin
                scan <= scan + 1;

                if (scan == width - 2) begin
                    state <= S2; 
                    iteration <= iteration + 1;
                end
            end

            S2: begin
                if (iteration == height) begin
                    state <= S3;
                end
                else begin
                    scan <= 0;
                    state <= S1;
                end
            end

            S3: begin
                state <= S3;
            end
        endcase
    end 
end

endmodule