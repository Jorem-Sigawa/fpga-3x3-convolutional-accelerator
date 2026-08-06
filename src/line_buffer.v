//LATENCY is 2*width + 3
//valid_out corresponds to w0, w1, w2

module line_buffer(
    input clk, nrst, start, //count here is the number of the pixel at that row (if current pixel is 5th in a row then count is 5), 0-indexed
    input [11:0] count, //comes from scan
    input [11:0] current_height, //increments when every pixel in a row has been processed
    input [11:0] width, //needs 12 bits to support 4k images
    input [11:0] height,
    input [7:0] pixel_in,
    output reg [7:0] w0,w1,w2,
    output reg valid_out //when the first meaningful result is made after start becomes high

);

parameter MAX_WIDTH = 4096;

reg [1:0] state;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

reg [7:0] line_buffer1 [0:MAX_WIDTH-1];
reg [7:0] line_buffer2 [0:MAX_WIDTH-1];

wire write_condition;
assign write_condition = (current_height >= 2);

reg [1:0] write_condition_pipe;

always @ (posedge clk) begin
    if (!nrst) begin
        state <= S0;
        write_condition_pipe <= 1'b0;
        w0 <= 0;
        w1 <= 0;
        w2 <= 0;
        valid_out <= 0; //instead of erasing two entire line_buffers (which is expensive), simply set valid_out to 0
    end
    else begin

        case (state)

            S0:begin
                if (start) begin //opening sequence, nrst -> start
                    state <= S1;
                end
            end

            S1:begin

                write_condition_pipe <= write_condition;

                valid_out  <= (write_condition_pipe[0]);//valid_out

                line_buffer1[count] <= line_buffer2[count];
                line_buffer2[count] <= pixel_in;


                if (current_height >= 2) begin
                    w0 <= line_buffer1[count];
                    w1 <= line_buffer2[count];
                    w2 <= pixel_in;
                end

                if (current_height == height) begin
                    state <= S2;
                end

                //$display("line_buffer1[count]=%0d, line_buffer2[count]=%0d, pixel_in=%0d, count=%0d", line_buffer1[count], line_buffer2[count], pixel_in, count);
            end

            S2:begin
                state <= S2;
            end

        endcase

    end
end

endmodule