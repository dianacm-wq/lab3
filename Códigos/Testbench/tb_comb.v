`timescale 1ns / 1ps

module tb_comb_selector;

    // Señales de entrada (registros)
    reg clk;
    reg reset;
    reg btn2_pulse;

    // Señales de salida (cables)
    wire [1:0] sel_A;
    wire [1:0] sel_B;
    wire [3:0] leds;

    // Instancia del módulo a probar
    comb_selector uut (
        .clk(clk),
        .reset(reset),
        .btn2_pulse(btn2_pulse),
        .sel_A(sel_A),
        .sel_B(sel_B),
        .leds(leds)
    );

    // Generación del reloj (período de 10ns = 100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Configuración para GTKWave
        $dumpfile("comb_selector.vcd");
        $dumpvars(0, tb_comb_selector);

        // Monitor para imprimir los cambios en la consola
        $monitor("Tiempo: %0t ns | btn2_pulse: %b | Estado Interno: %d | sel_A: %d | sel_B: %d | leds: %b", 
                 $time, btn2_pulse, uut.estado, sel_A, sel_B, leds);

        $display("---------------------------------------------------");
        $display("Iniciando simulacion del Selector Combinacional...");
        $display("---------------------------------------------------");

        // Inicialización
        clk = 0;
        reset = 1;         // Inicia con reset activo[cite: 6]
        btn2_pulse = 0;

        // Liberar reset después de 20ns
        #20;
        reset = 0;
        $display("\n--- Reset liberado, estado inicial (0) ---");

        // Generar 7 pulsos del botón para recorrer los 6 estados y comprobar el reinicio a 0[cite: 6]
        repeat (7) begin
            #15;
            btn2_pulse = 1; // Simula que se presionó el botón
            #10;
            btn2_pulse = 0; // Se suelta el botón (pulso de un ciclo)
        end

        #20;
        $display("---------------------------------------------------");
        $display("Simulacion terminada.");
        $display("---------------------------------------------------");
        $finish;
    end

endmodule