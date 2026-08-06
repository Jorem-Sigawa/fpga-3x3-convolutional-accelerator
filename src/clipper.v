module clipper (
    input wire valid_in,
    input wire signed [19:0] acc,

    output reg [7:0] res, //reg does not necessarily mean flip-flop, it just means its assignment depends on some procedure
    output wire valid_out
);
always @ (*) begin
    if (acc > 20'sd255) begin
        res = 8'd255;
    end

    else if (acc < 20'sd0) begin
        res = 8'd0;
    end

    else begin
        res = acc[7:0];
    end
end

assign valid_out = valid_in;



endmodule