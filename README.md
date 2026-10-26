# Lab03 – ALU + Banco de Registros + Diseño Modular

## Integrantes:
- Ana Lucía Molina López - 1061697969
- Nicolás Ramírez González - 1023371323
- Diana Margarita Castillo - 1011201869
## Contenido:
- Descripción del sistema
- Explicación de la arquitectura modular
    - ALU (alu.v)
    - Banco de registros (reg_bank.v)
    - Combinaciones de registros (comb_selector.v)
    - Módulo de visualización (display_tm1637.v)
    - Módulo de integración (top.v)
- Simulaciones
- Implementación de la FPGA
    - Proyecto en Vivado
    - Funcionamiento en FPGA (Video)
- Análisis de resultados

### Descripción del sistema
Este sistema digital constituye una arquitectura modular de procesamiento de datos de 4 bits. Inicialmente, el banco de registros almacena los operandos (R0 a R3) ingresados por el usuario mediante los switches, mientras que un módulo de selección secuencial administra la combinación de operandos (A y B) enviados a la ALU (Unidad Aritmético-Lógica). Posteriormente esta unidad realiza las operaciones aritméticas y lógicas seleccionadas por el usuario (suma, resta, AND, OR, XOR). Finalmente el resultado obtenido se almacena temporalmente para ser visualizado en un display de 7 segmentos (TM1637), conservando el último valor calculado hasta que se ejecute una nueva operación.




