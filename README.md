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

### Descripción del sistema
Este sistema digital constituye una arquitectura modular de procesamiento de datos de 4 bits implementada en la tarjeta FPGA Zybo Z7. Inicialmente, el usuario ingresa un dato de 4 bits mediante los switches SW[3:0] para almacenarlo en el banco de registros ($R_0$ a $R_3$). El registro de destino se selecciona pulsando secuencialmente el botón BTN[0], e indicando la selección activa a través del LED RGB (asignando un color/estado específico para cada registro: $R_0$, $R_1$, $R_2$ y $R_3$). La escritura efectiva del dato en el registro seleccionado se realiza en el instante en que se presiona el botón BTN[1] ($write$ _ $enable$).

Posteriormente, mediante el módulo de selección secuencial (comb _ selector ), el usuario define la pareja de operandos ($A$ y $B$) que se enviarán a la ALU. La conmutación entre las distintas combinaciones de registros se realiza mediante el botón BTN[2], mientras que los LEDs [3:0] se encienden para indicar visualmente cuáles registros están participando en la operación activa. La Unidad Aritmético-Lógica (ALU) recibe los operandos A y B y ejecuta la función seleccionada mediante los switches SW[2:0]. El repertorio de operaciones disponibles incluye operaciones aritméticas y lógicas: Suma, Resta, AND, OR, XOR, Desplazamiento e Identidad. 

Finalmente, el resultado de 4 bits generado por la ALU no altera el banco de registros; en su lugar, se captura y almacena temporalmente en un registro de salida (latch) únicamente al presionar el botón BTN[3]. Dicho resultado se visualiza en un display de 7 segmentos (TM1637), conservando el último valor calculado hasta que el usuario vuelva a presionar BTN3 para ejecutar una nueva operación.

### Explicación de la arquitectura modular
#### Banco de registros (reg_bank.v):
 Descripción
 
Este módulo tiene la función de almacenar los operandos que el usuario ingresa en cada uno de los registros disponibles (4 registros). A continuación se muestran la secuencia binaria designada para cada registro, junto con su respectivo color de Led RGB:

|   Código  |  Registro | Estado LED RGB|
| --------- | --------- | ---------     |
|  00       | R0        |    Rojo       |
|  01       | R1        |    Verde      |
|  10       | R2        |    Azul       |
|  11       | R3        |   Blanco      | 

Entradas y salidas

|   Señal   |  Tipo     | Ancho de bits |  Descripción |
| --------- | --------- | ---------     |  ----------- |
|  00       | R0        |    Rojo       |              |
|  01       | R1        |    Verde      |              |
|  10       | R2        |    Azul       |              |
|  11       | R3        |   Blanco      |              |


Máquina de estados finitos: 










