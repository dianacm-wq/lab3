# Lab03 – ALU + Banco de Registros + Diseño Modular

## Integrantes:
- Ana Lucía Molina López - 1061697969
- Nicolás Ramírez González - 1023371323
- Diana Margarita Castillo - 1011201869
## Contenido:
- Descripción del sistema
- Explicación de la arquitectura modular
    - Banco de registros (reg_bank.v)
    - Combinaciones de registros (comb_selector.v)
    - ALU (alu.v)
    - Módulo de visualización (display_tm1637.v)
    - Módulo de integración (top.v)
- Simulaciones
- Implementación de la FPGA
    - Proyecto en Vivado
    - Funcionamiento en FPGA (Video)
- Análisis de resultados

## Descripción del sistema
Este sistema digital constituye una arquitectura modular de procesamiento de datos de 4 bits implementada en la tarjeta FPGA Zybo Z7. Inicialmente, el usuario ingresa un dato de 4 bits mediante los switches SW[3:0] para almacenarlo en el banco de registros ($R_0$ a $R_3$). El registro de destino se selecciona pulsando secuencialmente el botón BTN[0], e indicando la selección activa a través del LED RGB (asignando un color/estado específico para cada registro: $R_0$, $R_1$, $R_2$ y $R_3$). La escritura efectiva del dato en el registro seleccionado se realiza en el instante en que se presiona el botón BTN[1] ($write$ _ $enable$).

Posteriormente, mediante el módulo de selección secuencial (comb _ selector ), el usuario define la pareja de operandos ($A$ y $B$) que se enviarán a la ALU. La conmutación entre las distintas combinaciones de registros se realiza mediante el botón BTN[2], mientras que los LEDs [3:0] se encienden para indicar visualmente cuáles registros están participando en la operación activa. La Unidad Aritmético-Lógica (ALU) recibe los operandos A y B y ejecuta la función seleccionada mediante los switches SW[2:0]. El repertorio de operaciones disponibles incluye operaciones aritméticas y lógicas: Suma, Resta, AND, OR, XOR, Desplazamiento e Identidad. 

Finalmente, el resultado de 4 bits generado por la ALU no altera el banco de registros; en su lugar, se captura y almacena temporalmente en un registro de salida (latch) únicamente al presionar el botón BTN[3]. Dicho resultado se visualiza en un display de 7 segmentos (TM1637), conservando el último valor calculado hasta que el usuario vuelva a presionar BTN3 para ejecutar una nueva operación.

## Explicación de la arquitectura modular
### Banco de registros (reg_bank.v):
 Descripción: 
 
Este módulo se encarga de almacenar los operandos de 4 bits que el usuario ingresa mediante los switches. Permite guardar datos en una memoria de 4 posiciones ($R_0$ a $R_3$) e incluye un puntero interno (estado) que avanza cíclicamente al presionar el botón de selección. Para brindar retroalimentación visual al usuario en la Zybo Z7, cada registro seleccionado se identifica con un color en el LED RGB:

|   Código  |  Registro | Estado LED RGB|
| --------- | --------- | ---------     |
|  00       | R0        |      (verde)  |
|  01       | R1        |      (verde)  |
|  10       | R2        |    (verde)    |
|  11       | R3        |     (verde)   | 

Entradas y salidas del módulo:


|   Señal      |  Tipo     | Ancho de bits |  Descripción                                                               |
| ---------    | --------- | ---------     |  -----------                                                               |
|  clk         | Entrada   |    1          |  Reloj principal del sistema (125 MHz).                                    |
|  Reset       | Entrada   |    1          | Reinicia la selección  de estado a 0 ($R_0$).                              |
|  data_in     | Entrada   |    4          | Dato de entrada de 4 bits proveniente de los switches (SW[3:0]).           |
| write_addr   | Entrada   |    1          | Pulso del botón BTN0 para cambiar el registro seleccionado.                |
| write_enable | Entrada   |    1          | Pulso del botón BTN1 para habilitar la escritura del dato en el registro.  |
| addr_a       | Entrada   |    2          | Dirección de 2 bits para seleccionar el registro leído por la salida A.    |
| addr_b       | Entrada   |    2          | Dirección de 2 bits para seleccionar el registro leído por la salida B.    |
| out_a        | Salida    |    4          | Valor de 4 bits del registro seleccionado como operando A.                 | 
| out_b        | Salida    |    4          | Valor de 4 bits del registro seleccionado como operando B.                 |


### Combinaciones de registros (comb_selector.v):

Descripción: 

El módulo de combinaciones actúa como el organizador y enrutador secuencial de datos dentro de la arquitectura. Su función principal es seleccionar cuál par de registros ($R_0$ a $R_3$) del banco de memoria será entregado a la ALU como los operandos de entrada $A$ y $B$.









