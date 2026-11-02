module botones (
    input CLK,
    input reset,
    input [3:0] BTN,
    output [3:0] pulso
);
    debounce d1 (
        .clk   (CLK),
        .reset (reset),
        .btn_in(BTN[0]),
        .pulse (pulso[0])
    );

    debounce d2 (
        .clk   (CLK),
        .reset (reset),
        .btn_in(BTN[1]),
        .pulse (pulso[1])
    );

    debounce d3 (
        .clk   (CLK),
        .reset (reset),
        .btn_in(BTN[2]),
        .pulse (pulso[2])
    );

    debounce d4 (
        .clk   (CLK),
        .reset (reset),
        .btn_in(BTN[3]),
        .pulse (pulso[3])
    );
endmodule
