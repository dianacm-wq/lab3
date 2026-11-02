module reg_bank (
    input clk,
    input reset,
    input [3:0] data_in,
    input write_enable,
    input write_addr,
    input [1:0] addr_a,
    input  [1:0] addr_b,
    output [3:0] out_a,
    output [3:0] out_b
);
    reg [3:0] registers [0:3];

    initial begin
        registers[0] = 4'b0000;
        registers[1] = 4'b0000;
        registers[2] = 4'b0000;
        registers[3] = 4'b0000;
    end

    reg [1:0] estado;

    always @(posedge clk, posedge reset) begin
        if (reset) estado <= 0;
        else begin
            if (write_addr) begin
                if (estado == 2'd3) estado <= 2'd0;
                else estado <= estado + 2'd1;
            end else if (write_enable) registers[estado] <= data_in;
        end
    end

    assign out_a = registers[addr_a];
    assign out_b = registers[addr_b];
endmodule

