`timescale 1ns / 1ps

module tb_reg_bank;

    // Entradas
    reg clk;
    reg reset;
    reg [3:0] data_in;
    reg write_enable;
    reg write_addr;
    reg [1:0] addr_a;
    reg [1:0] addr_b;

    // Salidas
    wire [3:0] out_a;
    wire [3:0] out_b;

    // Instancia del módulo
    reg_bank uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .out_a(out_a),
        .out_b(out_b)
    );

    // Generación del reloj (período 10ns)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("reg_bank.vcd");
        $dumpvars(0, tb_reg_bank);
        
        $monitor("Tiempo: %0t | Estado(Reg_Dest): %d | WE: %b | WA: %b | In: %h | AddrA: %d -> OutA: %h | AddrB: %d -> OutB: %h", 
                 $time, uut.estado, write_enable, write_addr, data_in, addr_a, out_a, addr_b, out_b);

        // Inicialización
        clk = 0;
        reset = 1;
        data_in = 4'h0;
        write_enable = 0;
        write_addr = 0;
        addr_a = 2'd0;
        addr_b = 2'd1;

        #20;
        reset = 0;

        // 1. Escribir en el Registro 0 (estado inicial = 0)[cite: 7]
        data_in = 4'hA;
        write_enable = 1;
        #10; write_enable = 0;

        // 2. Cambiar de registro y escribir en el Registro 1
        write_addr = 1; #10; write_addr = 0; // Incrementa estado a 1[cite: 7]
        data_in = 4'hB;
        write_enable = 1; #10; write_enable = 0;

        // 3. Cambiar de registro y escribir en el Registro 2
        write_addr = 1; #10; write_addr = 0; // Incrementa estado a 2[cite: 7]
        data_in = 4'hC;
        write_enable = 1; #10; write_enable = 0;

        // 4. Cambiar de registro y escribir en el Registro 3
        write_addr = 1; #10; write_addr = 0; // Incrementa estado a 3[cite: 7]
        data_in = 4'hD;
        write_enable = 1; #10; write_enable = 0;

        // 5. Probar lectura asíncrona cambiando las direcciones de salida[cite: 7]
        #10;
        addr_a = 2'd0; addr_b = 2'd2; // Esperado: A=A, B=C
        #10;
        addr_a = 2'd1; addr_b = 2'd3; // Esperado: A=B, B=D
        #10;
        
        $finish;
    end

endmodule