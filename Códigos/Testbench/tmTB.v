`timescale 1ns / 1ps

module tb_display_tm1637;

    // Entradas al módulo (Regs en el Testbench)
    reg reset;
    reg clk;
    reg [4:0] ALUin;
    reg CambioAlu;

    // Salidas del módulo (Wires en el Testbench)
    wire tm_clk;
    wire tm_dio;

    // Instancia del Módulo bajo prueba (UUT)
    display_tm1637 uut (
        .reset(reset),
        .clk(clk),
        .ALUin(ALUin),
        .CambioAlu(CambioAlu),
        .tm_clk(tm_clk),
        .tm_dio(tm_dio)
    );

    // Generación del Reloj (Periodo de 10ns = 100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Configuración para generar archivo de ondas VCD (compatible con GTKWave)
        $dumpfile("display_tm1637.vcd");
        $dumpvars(0, tb_display_tm1637);

        // Inicialización de señales
        clk = 0;
        reset = 1;
        ALUin = 5'h0;
        CambioAlu = 0;

        // Mantener en reset durante 20 ns
        #20;
        reset = 0;

        // Esperar a que la primera secuencia automática (estado inicial 0x40 -> 0xC0 -> ALU) termine
        #1875;

        // Simular primer cambio en la ALU (Enviar el digito '5' = 4'h5)
        ALUin = 5'h5;
        CambioAlu = 1;
        #50;
        CambioAlu = 0; // Pulso de cambio corto

        // Esperar la transmisión completa del nuevo valor
        #1000;

        // Simular segundo cambio en la ALU (Enviar la letra 'A' = 4'hA)
        ALUin = 5'h1A;
        CambioAlu = 1;

        // Esperar transmisión
        #3000;
        $finish;
    end

endmodule
