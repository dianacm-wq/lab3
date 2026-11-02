module alu (
    input      [3:0] a,
    input      [3:0] b,
    input      [2:0] op,
    output reg [4:0] y
);
    always @(*) begin
        case (op)
            3'b000:  y = {1'b0, a} + {1'b0, b};
            3'b001:  y = {1'b0, a} - {1'b0, b};
            3'b010:  y = {1'b0, a & b};
            3'b011:  y = {1'b0, a | b};
            3'b100:  y = {1'b0, a ^ b};
            3'b101:  y = {1'b0, ~a};
            3'b110:  y = {a, 1'b0};
            3'b111:  y = {2'b00, a[3:1]};
            default: y = 5'b00000;
        endcase
    end
endmodule
