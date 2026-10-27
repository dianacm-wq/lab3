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
Este sistema digital constituye una arquitectura modular de procesamiento de datos de 4 bits. Inicialmente, el usuario ingresa cada uno de los operandos (4 bits) que se van a almacenar en los registros (R0 a R3), a través los switches(INDICAR LOS SWITCHES QUE SE VAN A USAR). Luego se asigna un registro para cada operando , el cual se selecciona a través del botón físico de la FPGA BTN[0]. Cada registro seleccionado se visualiza a través del leds RGB asignados (INDICAR LA COMBINACIÓN DE LEDS ASIGNADOS PARA CADA REGISTRO) y se almacena en el momento en el que se oprime el botón BTN[1]. Posteriormente,  mediante el módulo de selección secuencia, el usuario administra la combinación de operandos (A y B) enviados a la ALU (Unidad Aritmético-Lógica) a través de los switches designados para esta unidad (INDICAR LOS SWITCHES ASIGNADOS). Para este diseño, las operaciones habilidas para la ALU son:( suma, resta, AND, OR, XOR INDICAR TODAS LAS OPERACIONES QUE SE DESIGNAN EN EL CÓDIGO)






 Posteriormente esta unidad realiza las operaciones aritméticas y lógicas seleccionadas por el usuario (suma, resta, AND, OR, XOR). Finalmente el resultado obtenido se almacena temporalmente para ser visualizado en un display de 7 segmentos (TM1637), conservando el último valor calculado hasta que se ejecute una nueva operación.

### Explicación de la arquitectura modular
#### ALU (alu.v):
Este módulo tiene la función de 


