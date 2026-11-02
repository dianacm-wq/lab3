module top3 (
    input OriginalCLK,
    input reset,
    input [3:0] switches,
    input [3:0] buttons,
    output DIO,
    output CLKtm,
    output [3:0] leds
);

    wire CLK;
    wire [3:0] pulso;

    DivFreq M0 (
        .CLK   (OriginalCLK),
        .reset (reset),
        .DivCLK(CLK)
    );

    botones M1 (
        .CLK  (CLK),
        .reset(reset),
        .BTN  (buttons),
        .pulso(pulso)
    );

    wire [1:0] combinacion1;
    wire [1:0] combinacion2;

    comb_selector M2 (
        .clk       (CLK),
        .reset     (reset),
        .btn2_pulse(pulso[2]),
        .sel_A     (combinacion1),
        .sel_B     (combinacion2),
        .leds      (leds)
    );

    wire [3:0] out_a;
    wire [3:0] out_b;
    
    reg_bank M3 (
        .clk         (CLK),
        .reset       (reset),
        .data_in     (switches),
        .write_enable(pulso[1]),
        .write_addr  (pulso[0]),
        .addr_a      (combinacion1),
        .addr_b      (combinacion2),
        .out_a       (out_a),
        .out_b       (out_b)
    );

    wire [4:0] resultado;

    alu M4 (
        .a (out_a),
        .b (out_b),
        .op(switches[2:0]),
        .y (resultado)
    );

    display_tm1637 M5 (
        .reset    (reset),
        .clk      (CLK),
        .ALUin    (resultado),
        .CambioAlu(pulso[3]),
        .tm_clk   (CLKtm),
        .tm_dio   (DIO)
    );
endmodule
