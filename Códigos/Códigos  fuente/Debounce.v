module debounce (
    input  clk,
    input reset,
    input  btn_in,      // botón crudo
    output reg pulse    // 1 ciclo por cada pulsación
);
    reg [10:0] cnt = 0;
    reg [2:0] estado;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            estado <= 0;
            cnt <= 0;
        end else begin
            case (estado)
                3'd0: if (btn_in) estado <= 3'd1;
                3'd1: if (cnt == 11'd2000) estado <= 3'd2;
                    else cnt = cnt + 11'd1;
                3'd2: begin
                    cnt <= 11'd0;
                    if (btn_in) estado <= 3'd3;
                    else estado <= 3'd4;
                end
                3'd3: estado <= 3'd4;
                3'd4: if (!btn_in) estado <= 3'd0;
                default:;
            endcase
        end
    end

    always @(*) begin
        case (estado)
            3'd0, 3'd1, 3'd4: pulse = 0;
            3'd3: pulse = 1;
            default: pulse = 0;
        endcase
    end
endmodule
