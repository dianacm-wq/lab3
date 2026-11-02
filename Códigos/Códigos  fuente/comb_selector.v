module comb_selector (
    input clk,
    input reset,
    input btn2_pulse,          // Señal de que se presiono BTN2
    output reg [1:0] sel_A,    // Le dirá al banco qué cajón poner en A
    output reg [1:0] sel_B,    // Le dirá al banco qué cajón poner en B
    output reg [3:0] leds      // Prende los foquitos
);

    reg [2:0] estado;

    always @(posedge clk, posedge reset) begin
        if (reset) estado <= 0;
        else begin
            if (btn2_pulse) begin
                if (estado == 3'd5) estado <= 3'd0;
                else estado <= estado + 3'd1;
            end
        end
    end

    always @(*) begin
        case(estado)
            3'd0: begin sel_A = 2'd0; sel_B = 2'd1; leds = 4'b0011; end // R0 y R1
            3'd1: begin sel_A = 2'd0; sel_B = 2'd2; leds = 4'b0101; end // R0 y R2
            3'd2: begin sel_A = 2'd0; sel_B = 2'd3; leds = 4'b1001; end // R0 y R3
            3'd3: begin sel_A = 2'd1; sel_B = 2'd2; leds = 4'b0110; end // R1 y R2
            3'd4: begin sel_A = 2'd1; sel_B = 2'd3; leds = 4'b1010; end // R1 y R3
            3'd5: begin sel_A = 2'd2; sel_B = 2'd3; leds = 4'b1100; end // R2 y R3
            default: begin sel_A = 2'd0; sel_B = 2'd1; leds = 4'b0011; end
        endcase
    end
endmodule
