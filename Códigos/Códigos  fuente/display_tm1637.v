module display_tm1637 (
    input reset,
    input clk,
    input [4:0] ALUin,
    input CambioAlu,
    output reg tm_clk,
    output reg tm_dio
);
    reg [7:0] segmento1;
    wire [7:0] segmento2;

    always @(*) begin
        case(ALUin[3:0])
            4'h0: segmento1 = 8'b00111111;
            4'h1: segmento1 = 8'b00000110;
            4'h2: segmento1 = 8'b01011011;
            4'h3: segmento1 = 8'b01001111;
            4'h4: segmento1 = 8'b01100110;
            4'h5: segmento1 = 8'b01101101;
            4'h6: segmento1 = 8'b01111101;
            4'h7: segmento1 = 8'b00000111;
            4'h8: segmento1 = 8'b01111111;
            4'h9: segmento1 = 8'b01101111;
            4'hA: segmento1 = 8'b01110111;
            4'hB: segmento1 = 8'b01111100;
            4'hC: segmento1 = 8'b00111001;
            4'hD: segmento1 = 8'b01011110;
            4'hE: segmento1 = 8'b01111001;
            4'hF: segmento1 = 8'b01110001;
            default: segmento1 = 8'b00000000;
        endcase
    end

    assign segmento2 = ALUin[4] ? 8'h1 : 8'h0;

    reg [2:0] estado1;
    reg [7:0] data;
    reg [7:0] ALUact1;
    reg [7:0] ALUact2;
    reg start;
    reg [1:0] num_byte1;
    reg finish;

    // Maquina primaria de control
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            estado1 <= 0;
            ALUact1 <= 0;
            ALUact2 <= 0;
        end else begin
            case (estado1)
                3'd0: estado1 <= 3'd1;
                3'd1: if (finish) begin
                    estado1 <= 3'd2;
                end
                3'd2: if (finish)  estado1 <= 3'd3;
                3'd3: if (finish) estado1 <= 3'd4;
                3'd4: if (finish) estado1 <= 3'd5;
                3'd5: if (finish) begin
                    if (CambioAlu) begin 
                        ALUact1 <= segmento1;
                        ALUact2 <= segmento2;
                    end
                    estado1 <= 3'd0;
                end
                default: estado1 <= 3'd0;
            endcase
        end
    end

    always @(*) begin
        case (estado1)
            3'd0: begin
                start = 0;
                data = 0;
                num_byte1 = 0;
            end
            3'd1: begin
                start = 1;
                data = 8'h40;
                num_byte1 = 0;
            end
            3'd2: begin
                start = 1;
                data = 8'hC0;
                num_byte1 = 2'd2;
            end
            3'd3: begin
                start = 1;
                data = ALUact1;
                num_byte1 = 0;
            end
            3'd4: begin
                start = 1;
                data = ALUact2;
                num_byte1 = 0;
            end
            3'd5: begin
                start = 1;
                data = 8'h8f;
                num_byte1 = 0;
            end
            default: begin 
                start = 0;
                data = 0;
                num_byte1 = 0;
            end
        endcase
    end

    // Maquina secundaria de escritura
    reg [1:0] num_byte2;
    reg [7:0] data_actual;
    reg [3:0] estado2;
    reg [2:0] contador;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            estado2 <= 0;
            contador <= 0;
        end else begin
            case (estado2)
                4'd0: if (start) begin
                    contador <= 0;
                    estado2 <= 4'd1;
                    data_actual <= data;
                    num_byte2 <= num_byte1;
                end
                4'd1: estado2 <= 4'd2; 
                4'd2: estado2 <= 4'd3;
                4'd3: estado2 <= 4'd4;
                4'd4: estado2 <= 4'd5;
                4'd5: estado2 <= 4'd6;
                4'd6: if (contador == 3'd7) begin
                    if (num_byte2 == 0) estado2 <= 4'd7;
                    else begin
                        num_byte2 <= num_byte2 - 2'd1;
                        contador <= 0;
                        estado2 <= 4'd12;
                    end
                end else begin
                    contador <= contador + 3'd1;
                    data_actual <= data_actual >> 1;
                    estado2 <= 4'd3;
                end
                4'd7: estado2 <= 4'd8;
                4'd8: estado2 <= 4'd9;
                4'd9: estado2 <= 4'd10;
                4'd10: estado2 <= 4'd11;
                4'd11: estado2 <= 4'd0;
                4'd12: estado2 <= 4'd13;
                4'd13: begin 
                    estado2 <= 4'd1;
                    data_actual <= data;
                end
                default: estado2 <= 4'd0;
            endcase
        end
    end

    always @(*) begin
        finish = 0;
        tm_dio = 0;
        tm_clk = 0;
        case (estado2)
            4'd0: begin
                tm_dio = 1;
                tm_clk = 1;
            end
            4'd1: begin
                tm_dio = 0;
                tm_clk = 1;
            end
            4'd2: begin
                tm_dio = 0;
                tm_clk = 0;
            end
            4'd3: begin
                tm_dio = data_actual[0];
                tm_clk = 0;
            end
            4'd4, 4'd5: begin
                tm_dio = data_actual[0];
                tm_clk = 1;
            end
            4'd6: begin
                tm_dio = data_actual[0];
                tm_clk = 0;
            end
            4'd7: begin
                tm_dio = 0;
                tm_clk = 0;
                finish = 1;
            end
            4'd8: begin
                tm_dio = 0;
                tm_clk = 1;
            end
            4'd9: begin
                tm_dio = 0;
                tm_clk = 1;
            end
            4'd10: begin
                tm_dio = 0;
                tm_clk = 0;
            end
            4'd11: begin
                tm_dio = 0;
                tm_clk = 1;
            end
            4'd12: begin
                tm_dio = 0;
                tm_clk = 0;
                finish = 1;
            end
            4'd13: begin
                tm_dio = 0;
                tm_clk = 1;
            end
            default: begin
                tm_dio = 0;
                tm_clk = 0;
                finish = 0;
            end
        endcase
    end

endmodule
