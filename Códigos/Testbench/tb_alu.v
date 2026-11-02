`timescale 1ns / 1ps

module tb_alu;

    // Declaración de señales para conectar con la ALU
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    wire [4:0] y;

    // Instancia del módulo ALU bajo prueba
    alu uut (
        .a(a),
        .b(b),
        .op(op),
        .y(y)
    );

    initial begin
        // Configuración para GTKWave (opcional)
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu);

        // Monitor para imprimir los cambios en consola automáticamente
        $monitor("Tiempo: %0t ns | op: %b | a: %b (%d) | b: %b (%d) | Salida y: %b (%d)", 
                 $time, op, a, a, b, b, y, y);

        $display("---------------------------------------------------");
        $display("Iniciando simulacion de la ALU...");
        $display("---------------------------------------------------");

        // Valores base para las pruebas
        a = 4'b1010; // 10 en decimal
        b = 4'b0011; // 3 en decimal

        // Prueba 0: Suma (000)[cite: 5]
        op = 3'b000; 
        #10;
        
        // Prueba 1: Resta (001)[cite: 5]
        op = 3'b001; 
        #10;
        
        // Prueba 2: AND bit a bit (010)[cite: 5]
        op = 3'b010; 
        #10;
        
        // Prueba 3: OR bit a bit (011)[cite: 5]
        op = 3'b011; 
        #10;
        
        // Prueba 4: XOR bit a bit (100)[cite: 5]
        op = 3'b100; 
        #10;
        
        // Prueba 5: NOT a (101)[cite: 5]
        op = 3'b101; 
        #10;
        
        // Prueba 6: Shift Left a (110)[cite: 5]
        op = 3'b110; 
        #10;
        
        // Prueba 7: Shift Right a (111)[cite: 5]
        op = 3'b111; 
        #10;

        // Prueba adicional con otros valores para verificar el acarreo en la suma
        a = 4'b1111; // 15
        b = 4'b0001; // 1
        op = 3'b000; // Suma (15 + 1 = 16 -> 5'b10000)
        #10;

        $display("---------------------------------------------------");
        $display("Simulacion terminada.");
        $display("---------------------------------------------------");
        $finish;
    end

endmodule