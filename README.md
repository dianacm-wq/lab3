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
    - Módulo Anti-rebote (debounce.v)
    - Gestor de Botones (botones.v)
    - Divisor de Frecuencia (DivFreq.v)
    - Módulo de visualización (display_tm1637.v)
    - Módulo de integración (top.v)
- Simulaciones
- Implementación de la FPGA
    - Funcionamiento en FPGA (Video)
- Análisis de resultados
- Conclusiones

## Descripción del sistema
Este sistema digital constituye una arquitectura modular de procesamiento de datos de 4 bits implementada en la tarjeta FPGA Zybo Z7.
Inicialmente, el usuario ingresa un dato de 4 bits mediante los switches SW[3:0] para almacenarlo en el banco de registros ($R_0$ a $R_3$). 

El registro de destino se selecciona pulsando secuencialmente el botón BTN[0], e indicando la selección activa a través del estado interno del módulo. La escritura efectiva del dato en el registro seleccionado se realiza en el instante en que se presiona el botón BTN[1] (write_enable).

Posteriormente, mediante el módulo de selección secuencial (comb_selector), el usuario define la pareja de operandos ( $A$ y $B$ ) que se enviarán a la ALU. La conmutación entre las distintas combinaciones de registros se realiza mediante el botón BTN[2], mientras que los LEDs LED[3:0] se encienden para indicar visualmente cuáles registros están participando en la operación activa.

La Unidad Aritmético-Lógica (ALU) recibe los operandos $A$ y $B$ y ejecuta la función seleccionada mediante los switches SW[2:0]. El repertorio de operaciones disponibles incluye operaciones aritméticas y lógicas: Suma, Resta, AND, OR, XOR, NOT, Desplazamiento a la izquierda y Desplazamiento a la derecha.

Finalmente, el resultado generado por la ALU (de 5 bits para contemplar el acarreo/extensión) no altera el banco de registros; en su lugar, se captura y actualiza en la interfaz de salida únicamente al presionar el botón BTN[3]. Dicho resultado se visualiza en un display de 7 segmentos controlado mediante el protocolo del driver TM1637, conservando el último valor calculado de forma estable hasta que el usuario vuelva a presionar BTN[3].

## Explicación de la arquitectura modular
### Banco de registros (reg_bank.v):
 Descripción: 
 
Este módulo se encarga de almacenar los operandos de 4 bits que el usuario ingresa mediante los switches. Permite guardar datos en una memoria síncrona de 4 posiciones ($R_0$ a $R_3$) e incluye estados internos que avanzan cíclicamente de $0$ a $3$ al recibir un pulso en la señal write_addr (BTN[0]). La escritura solo ocurre en el registro apuntado si write_enable (BTN[1]) se encuentra activo.
Para brindar retroalimentación visual al usuario en la Zybo Z7, cada registro seleccionado se identifica con un color en el LED RGB:

|   Código  |  Registro | Estado LED RGB|
| --------- | --------- | ---------     |
|  00       | R0        |      Rojo     |
|  01       | R1        |      Verde    |
|  10       | R2        |      Azul     |
|  11       | R3        |      Blanco   | 

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

El módulo actúa como el organizador y enrutador secuencial de datos dentro de la arquitectura. Su función principal es seleccionar qué par de registros ($R_0$ a $R_3$) del banco de memoria se entregarán a la ALU como operandos $A$ y $B$. Al recibir un pulso en btn2_pulse (BTN[2]), conmuta secuencialmente a través de 6 combinaciones predefinidas. Además, genera una máscara de 4 bits para los LEDs integrados, encendiendo únicamente los indicadores correspondientes a los dos registros en uso.

Tabla de combinaciones y mapeo de LEDs

| Estado      | Operando A   | Operando B    |  LEDs activos | Registros representados |
|-------------|--------------|-------------- |---------------|-------------------------|
|    3'd0     |2'd0 ($R_0$)  | 2'd1 ($R_1$)  | 4'b0011       | $R_0, R_1$              |
|    3'd1     |2'd0 ($R_0$)  | 2'd2 ($R_2$)  | 4'b0101       | $R_0, R_2$              |
|    3'd2     |2'd0 ($R_0$)  | 2'd3 ($R_3$)  | 4'b1001       | $R_0, R_3$              |
|    3'd3     |2'd1 ($R_1$)  | 2'd2 ($R_2$)  | 4'b0110       | $R_1, R_2$              |
|    3'd4     |2'd1 ($R_1$)  | 2 d3 ($R_3$)  | 4'b1010       | $R_1, R_3$              |
|    3'd5     |2'd2 ($R_2$)  | 2'd3 ($R_3$)  | 4'b1100       | $R_2, R_3$              |

### Unidad Aritmético-Lógica (alu.v)

Descripción:

La ALU es un bloque combinacional que procesa las entradas de 4 bits a y b según la operación seleccionada por el vector op[2:0]. La salida y tiene un ancho de 5 bits ($Y[4:0]$) para permitir la representación de acarreos o bits adicionales resultantes de operaciones aritméticas o desplazamientos.

Tabla de Operaciones

|Código de operación  |Operación    |Expresión Verilog           |Descripción                                                       |
|---------------------|------------ |--------------------------- |--------------------------------------------------------          |
|3'b000               |  Suma       | y = {1'b0, a} + {1 me0, b} |   Suma aritmética con acarreo en $Y[4]$.                         |
|3'b001               |  Resta      | y = {1'b0, a} - {1'b0, b}  |   Resta aritmética entre $A$ y $B$.                              |
|3'b010               |  AND        | y = {1'b0, a & b}          |   Operación lógica bit a bit AND.                                |
|3'b011               |  OR         | y = {1'b0, a | b}          |   Operación lógica bit a bit OR.                                 |
|3'b100               |  XOR        | y = {1'b0, a ^ b}          |   Operación lógica bit a bit XOR.                                |
|3'b101               |  NOT        | y = {1'b0, ~a}             |   Inversión lógica bit a bit del operando $A$.                   |
|3'b110               | Shift Left  | y = {a, 1'b0}              |   Desplazamiento a la izquierda de $A$ (multiplicación por 2).   |
|3'b111               | Shift Right | y = {2'b00, a[3:1]}        |   Desplazamiento a la derecha de $A$ (división entera por 2).    |

### Módulo Anti-rebote  (debounce.v)

Descripción:
Los botones físicos sufren transitorios mecánicos (rebotes) al presionarse o soltarse, generando múltiples pulsos en microsegundos. El módulo debounce implementa una Máquina de Estados Finitos (FSM) combinada con un temporizador de retardo para generar un único pulso limpio de duración de 1 ciclo de reloj por cada pulsación real.

Principio de Funcionamiento de cada estado:
- Estado 0 (Reposo): Espera a que la entrada del botón (btn_in) pase a alto (1).
-  Estado 1 (Filtro de Rebote): Inicia la cuenta de un temporizador de 11 bits (cnt) hasta llegar a $2000$ ciclos de reloj. Esto introduce un retardo de estabilización mecánica ($\approx 19.2\text{ ms}$).
-  Estado 2 (Verificación): Reinicia la cuenta e evalúa la señal. Si el botón sigue presionado, transita al Estado 3; si fue un ruido pasajero, va al Estado 4.
-   Estado 3 (Generación de Pulso): La salida pulse se activa en 1 durante exactamente un ciclo de reloj y avanza al Estado 4.
-   Estado 4 (Espera de Liberación): Mantiene la salida en 0 y espera a que el usuario suelte el botón (btn_in == 0) para retornar al Estado 0.   

Entradas y salidas

| Señal |Tipo    | Ancho (bits) | Descripción                                  |
|-------|------  |--------------|-------------                                 |
|clk    |Entrada |1             |Reloj del sistema preescalado (DivCLK).       |
|reset  |Entrada |1             |Señal de reinicio global.                     |
|btn_in |Entrada |1             | Entrada ruidosa proveniente del botón físico.|
|pulse  |Salida  |1             |Pulso limpio de duración de 1 ciclo de reloj. |

### Gestor de Botones (botones.v)

Descripción

Los botones mecánicos sufren de rebotes eléctricos al presionar. El módulo debounce implementa una máquina de estados finitos (FSM) asistida por un contador síncrono que filtra las transiciones espurias y entrega un único pulso limpio de un ciclo de reloj por cada pulsación real. El módulo botones instancia cuatro unidades de filtrado para acondicionar los botones BTN0 a BTN3.

Entradas y salidas

| Señal | Tipo      | Ancho (bits) | Descripción                                                 |
|-------|-----------|--------------|-------------                                                |
|CLK    |Entrada    |1             |Reloj preescalado del sistema (DivCLK).                      |
|reset  |Entrada    |1             | Reinicio asíncrono.                                         |
|BTN    | Entrada   |4             | Bus con los 4 botones físicos de la Zybo Z7 (BTN0 a BTN3).  |
|pulso  |Salida     |4             |Bus de pulsos filtrados asignados a cada función del sistema.|

### Divisor de Frecuencia (DivFreq.v)

Descripción

La tarjeta Zybo Z7 proporciona un reloj principal (OriginalCLK) de  $125\text{ MHz}$. Trabajar a esta frecuencia tan elevada dificulta el filtrado del rebote mecánico de los botones y la gestión temporal para periféricos lentos como la pantalla TM1637. El módulo DivFreq reduce la frecuencia de reloj del sistema a una frecuencia de trabajo adecuada (DivCLK) mediante un contador entero binario.   

Principio de Funcionamiento:
Utiliza un contador de 10 bits (contador) que incrementa con cada flanco de subida de OriginalCLK. Al alcanzar la cuenta límite de $599$, el contador se reinicia a $0$ y conmuta (toggle) el estado de la señal DivCLK. 

$$f_{\text{salida}} = \frac{f_{\text{original}}}{2 \times (N+ 1)} = \frac{125\text{ MHz}}{2 \times (599 + 1)} = \frac{125\text{ MHz}}{1200} \approx 104.16\text{ kHz}$$

Entradas y salidas:

| Señal | Tipo   | Ancho (bits) | Descripción                                               |
|------ |-----   |------------- |------------                                               |
|CLK    |Entrada | 1            |Reloj principal de entrada de la FPGA ($125\text{ MHz}$).  |
|reset  |Entrada | 1            |Reinicio asíncrono que restablece el contador a $0$.       |
|DivCLK |Salida  | 1            |Reloj dividido de salida ($\approx 104.16\text{ kHz}$).    |


### Módulo de visualización (display_tm1637.v)

Descripción

Este módulo se encarga de recibe el resultado de 5 bits generado por la ALU y el pulso CambioAlu (BTN[3]). Al presionar BTN[3], se actualiza el registro interno de captura (latch) con el valor actual de ALUin. Adicionalmente este módulo se encarga de transmitir en formato de protocolo serie de dos hilos (CLKtm y DIO) la información hacia el controlador del display de 7 segmentos TM1637.

Entradas y salidas

|Señal     | Tipo          | Ancho (bits) | Descripción                                                     |
|----------|---------------|--------------|----------------------------                                     |
|clk       | Entrada       |1             |Reloj del sistema (DivCLK).                                      |
|reset     |Entrada        |1             |Reinicio global.                                                 |
|ALUin     |Entrada        |5             |Bus con el resultado inmediato generado por la ALU (y[4:0]).     |
|CambioAlu |Entrada        |1             |Pulso del botón BTN3 (pulso[3]) para habilitar la actualización. |
|tm_clk    |Salida         |1             |Línea de reloj serial de la interfaz TM1637 (CLKtm).             |
|tm_dio    |Salida / Inout |1             |Línea de datos seriales bidireccional (DIO).                     |

### Módulo de integración (top.v)

Descripción

Es el módulo jerárquico superior (Top Module). No realiza lógica de procesamiento de datos directamente; su rol se limita a instanciar e interconectar las entradas y salidas físicas de la Zybo Z7 (Switches, Botones, LEDs, Display) con las entradas y salidas de los submódulos (DivFreq, botones, comb_selector, reg_bank, alu, display_tm1637).

##  Simulaciones 

###  Capturas obtenidas en GTKWave
- Banco de registros (reg_bank.v)
<img width="1366" height="696" alt="{01710E1A-56C3-4635-BD83-D47C3B2609E4}" src="https://github.com/user-attachments/assets/7b98594b-8349-42c6-ab77-baee8e96409c" />

- Combinaciones de registros (comb_selector.v)

<img width="1364" height="697" alt="{C7A8E30A-A133-4E19-A9FB-02500FFBC123}" src="https://github.com/user-attachments/assets/6b46ffde-8b93-4b77-b4f8-0101093cc6f2" />

- ALU (alu.v)

<img width="1366" height="700" alt="{59B9AAFE-C317-40F8-9BDF-F6207D5CA25B}" src="https://github.com/user-attachments/assets/ee379731-00e7-4962-95d8-0e424f9981f4" />

- Módulo de visualización (display_tm1637.v)

<img width="1366" height="694" alt="{9653510F-4AD9-4BB7-B1FE-034521AABE9D}" src="https://github.com/user-attachments/assets/a2ff44e8-18a5-4d51-879f-9c91f956960f" />

## Implementación en FPGA (Zybo Z7)
 
 ### Funcionamiento en FPGA (Video)
 
https://drive.google.com/drive/folders/1x_4HrH6c9QFBktMU9a3DDq7Sq63LrpKO

## Análisis de Resultados
1. Aislamiento Físico y Funcional mediante Diseño Modular: La metodología de diseño modular implementada permitió desacoplar las diferentes etapas de la arquitectura digital (almacenamiento en reg_bank.v, enrutamiento de operandos en comb_selector.v, procesamiento en alu.v y despliegue en display_tm1637.v). Este aislamiento funcional ofreció ventajas operativas determinantes durante la etapa de pruebas:

- Depuración independiente: Cada módulo pudo simularse de forma individual mediante sus respectivos testbenches, asegurando que los fallos lógicos se corrigieran antes de la integración en el top-level (top3.v).
-  Modularidad del flujo de datos: La ALU opera de forma puramente combinacional calculando el resultado de forma instantánea a partir de las entradas proporcionadas por el banco de registros, sin preocuparse por la sincronización de las lecturas ni por la física del display serial.

 2. Impacto del Filtrado Anti-rebote (debounce.v) en las Máquinas de Estado: La inclusión de los módulos de filtrado de rebote (debounce.v) fue un factor crítico para garantizar la estabilidad del sistema. Los botones mecánicos de la tarjeta Zybo Z7 generan múltiples transitorios inductivos y capacitivos (rebotes) durante los primeros milisegundos de cada pulsación.   Sin el filtrado de rebote:
 
 - El módulo reg_bank.v capturaba múltiples flancos falsos al presionar BTN0, haciendo que el puntero de selección de registro avanzara aleatoriamente a través de varios estados ($R0 \rightarrow R3$) en una sola pulsación.
 - De manera análoga, el selector de combinaciones (comb_selector.v) se saltaba pares de operandos de forma impredecible al pulsar BTN2.

Con la implementación de la FSM de 5 estados con retardo de $\approx 19.2\text{ ms }$ en debounce.v, el sistema garantiza la generación de un único pulso de un ciclo de reloj por cada acción del usuario. Esto asegura que la selección de registros y la conmutación de combinaciones ocurran exactamente de un estado a la vez.  

3. Estabilidad de la Visualización mediante el Latch de Salida: La restricción del sistema exigía conservar el valor de la última operación ejecutada sin mostrar valores transitorios. Para dar cumplimiento a esta regla, el registro de retención tipo latch integrado a la entrada del módulo display_tm1637.v actuó como una barrera de sincronización entre la ALU y la pantalla.

## Conclusiones

- Se logró validar una arquitectura digital completa en la FPGA Zybo Z7 dividiendo las funciones en módulos desacoplados y fácilmente depurables.

- El uso de un banco de registros de 4 posiciones y un selector de combinaciones permitió alimentar dinámicamente a la ALU de 4 bits sin necesidad de modificar el cableado o la lógica interna.

- La estrategia de retención de datos en la etapa de visualización garantiza un comportamiento predecible del sistema, permitiendo al usuario configurar operandos e inspeccionar operaciones previas de manera clara.

