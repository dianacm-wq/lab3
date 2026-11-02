module DivFreq (
    input CLK,
    input reset,
    output reg DivCLK
);
    reg [9:0] contador; // Numero de bits = log2(Numero de contador)

    always @(posedge CLK, posedge reset) begin
        if (reset) begin
            contador <= 10'd0;
            DivCLK   <= 1'd0;
        end
        else if (contador == 10'd599) begin // Numero de contador = (frecuencia original)/([frecuencia de salida]*2)-1
            contador <= 10'd0;
            DivCLK   <= ~DivCLK;
        end
        else begin
            contador <= contador + 10'd1;
        end
    end
endmodule
