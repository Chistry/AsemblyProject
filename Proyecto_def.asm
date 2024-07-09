.data

msg1: .asciiz "Inicializando conversor de n�meros \n"
msg2: .asciiz "Ingrese abajo el valor que corresponda al tipo del n�mero que desea ingresar \n \n"
msg3: .asciiz "1. Binario (Complemento a 2)\n"
msg4: .asciiz "2. Decimal empaquetado\n"
msg5: .asciiz "3. Base 10\n"
msg6: .asciiz "4. Octal\n"
msg7: .asciiz "5. Hexadecimal\n"
msg8: .asciiz "6. Decimal\n"

numHex: .space 9
numBinario: .space 16
numEmp: .space 16
numOctal: .space 8

mensajeEntrada: .asciiz "Introduzca un numero entero positivo N => "
    mensajeConversion: .asciiz "\nSelecciona el tipo de conversion:\n1- Hexadecimal\n2- Octal\n3- Base 10\n4- Decimal Empaquetado\n5- Binario en Complemento a 2\nElección: "
    mensajeHexadecimal: .asciiz "El numero en hexadecimal es: "
    mensajeOctal: .asciiz "El numero en octal es: "
    mensajeBase10: .asciiz "El numero en base 10 es: "
    mensajeDecimalEmpaquetado: .asciiz "El numero en decimal empaquetado es: "
    mensajeBinarioComplemento: .asciiz "El numero en binario complemento a 2 es: "
    signoPositivo: .asciiz "+"
    signoNegativo: .asciiz "-"
    digitosHex: .asciiz "0123456789ABCDEF"
    digitosOct: .asciiz "01234567"
    salto: .asciiz "\n"
    
inputFraccion: .asciiz "Ingrese un n�mero decimal con parte fraccionaria (por ejemplo, 2.75): "
outputFraccion: .asciiz "El numero convertido a binario es: "
inputDecimal: .space 20
ParteEntera: .space 25
ParteFraccion: .space 9
punto: .asciiz "."

.macro hexadecimal
# Input del ususario
li $v0 8
la $a0 numHex
li $a1 9
syscall

li $t0 0 # Resultado
li $t1 0 # Pointer

bucleCasteo:
lb $t2 numHex($t1) # Se carga el bit correspondiente a la posici�n en la que se encuentre el lector
beq $t2 0 finBucleCasteo # Se comprueba si debe seguir el bucle

blt $t2 58 esNumero # Se verifica si es un n�mero
b esLetra # Se verifica si es una letra

esNumero:
addi $t2 $t2 -48 # Se le resta su valor seg�n la tabla ascii
b continuarBucleCasteo

esLetra:
addi $t2 $t2 -55 # Se le resta su valor seg�n la tabla ascii
b continuarBucleCasteo

continuarBucleCasteo:

# Se realiza un shift para pasar al siguiente valor en el n�mero hexadecimal
sll $t0 $t0 4
or $t0 $t0 $t2

addi $t1 $t1 1 # Se le suma 1 al pointer
b bucleCasteo
finBucleCasteo:
.end_macro

.macro empaquetado
li $v0, 12
la $a0, numEmp
li $a1, 16
syscall

li $t0 0
li $t1 10

convertir:
lb $t2, 0($a0)  # cargar el siguiente byte
andi $t3, $t2, 0xF0  # extraer el nibble
sra $t3, $t3, 4    # shift a la derecha para obtener el valor entero
add $t0, $t0, $t3  # sumar el valor entero al resultado
addi $a0, $a0, 1   # aumentar el valor del valor de recorrido
bne $a0, $a1, convertir  # repetir hasta que se hayan cargado todos los bytes
.end_macro

.macro binario
li $v0, 12
la $a0, numBinario
li $a1, 16
syscall

li $t0, 0   # Contador de bits
li $t1, 0   # Suma parcial
li $t2, -1  # Complemento a 1

loop:
# Obtener el d�gito actual
lb $t3, numBinario($t0)

# Verificar si es 1
beq $t3, 1, oneFound

# Verificar si es 0
beq $t3, 0, zeroFound

j exit

oneFound:
# Sumar 2^t1 al complemento a 1
sll $t4, $t1, 1
add $t1, $t1, $t4
addi $t1, $t1, 1

zeroFound:
# Negar el complemento a 1
xor $t1, $t1, $t2

# Sumar el bit actual al resultado
and $t5, $t3, 1
add $t1, $t1, $t5

# Incrementar el contador de bits
addi $t0, $t0, 1

# Continuar el ciclo
j loop

exit:
.end_macro

.macro octal

# Input del usuario
li $v0, 4                                   
la $a0, numOctal                               
syscall                                        

# Se lee el input del usuario
li $v0, 5                                   
syscall
                                        
move $t0, $v0                                  

li $v0, 0                                       # Resultado
li $t2, 1                                       # Multiplicador

conversion:
# Se extrae el primer d�gito del octal
addi $t1, $t0, -4                             
andi $t1, $t1, 0x0F                           

# Multiplicar los d�gitos por la potencia de 8 que les corresponda
mul $t3, $t1, $t2                           
add $v0, $v0, $t3                            

# Actualizar el valor para el siguiente d�gito
mul $t2, $t2, 8                             

# Verificar si se tiene que repetir el bucle
bne $t0, $zero, conversion                          

.end_macro

.text

############ Mapeo del texto inicial del programa ############

li $v0 4
la $a0 msg1
syscall

li $v0 4
la $a0 msg2
syscall

li $v0 4
la $a0 msg3
syscall

li $v0 4
la $a0 msg4
syscall

li $v0 4
la $a0 msg5
syscall

li $v0 4
la $a0 msg6
syscall

li $v0 4
la $a0 msg7
syscall

li $v0 4
la $a0 msg8
syscall

############ Mapeo del texto inicial del programa ############

### Input del usuario ###

li $v0 5
syscall

move $t0 $v0

### Input del usuario ###

### Salto a la rama adecuada seg�n el input del usuario ###

beq $t0 1 conversionBinario
beq $t0 2 conversionDecimalEmp
beq $t0 3 conversionBase10
beq $t0 4 conversionOctal
beq $t0 5 conversionHexadecimal
beq $t0 6 conversionDecimal

### Salto a la rama adecuada seg�n el input del usuario ###

### Ramas de conversi�n ###

conversionBinario:

binario #llamada al macro

conversionDecimalEmp:

empaquetado #llamada al macro

conversionBase10:

# No se coloca nada ya que el numero introducido no debe convertirse

conversionOctal:

octal #llamada al macro

conversionHexadecimal:

hexadecimal #llamada al macro

conversionDecimal:

li $v0, 4
la $a0, inputFraccion
syscall

li $v0, 8 
la $a0, inputDecimal 
li $a1, 20
syscall

li $t0, 0 # Registro para recorrer la cadena
li $t1, 0 # Registro para almacenar la parte entera
li $t2, 0 # Registro para manipulaci�n de caracteres
li $t3, 0 # Registro para almacenar la parte fraccionaria
li $t7, 1 # Registro para tener tener la cantidad de multiplicaciones por 10 seg�n la cantidad de digitos que tenga la fracci�n fracci�n

recorrer:
lb $t2, inputDecimal($t0)
beq $t2, '.', empezar_fraccion # Si el byte es el punto, pasa a la parte fraccionaria
beq $t2, 0, fin_recorrer # Si es el final de la cadena, termina de iterar en el
subi $t2, $t2, '0' # Convertir ASCII a n�mero (restar el valor ASCII de '0')
mul $t1, $t1, 10 # Multiplicar el valor acumulado por 10
add $t1, $t1, $t2 # Sumar el nuevo numero al acumulado
addi $t0, $t0, 1 # Sumar 1 por cada iteraci�n
b recorrer 
	
empezar_fraccion:
addi $t0, $t0, 1 # Se avanza un byte, porque la anterior iteraci�n temin� en el punto

fraccion_bucle:
lb $t2, inputDecimal($t0)
beqz $t2, fin_recorrer # Si es el final de la cadena, termina de iterar en el
beq $t2, 10, fin_recorrer # Si es el final de la cadena, termina de iterar en el
subi $t2, $t2, '0' # Convertir ASCII a n�mero
mul $t3, $t3, 10 # Multiplicar el valor acumulado por 10
add $t3, $t3, $t2 # Sumar el nuevo numero al acumulado
mul $t7, $t7, 10 # Multiplicar por 10 cada digito que encuentre
addi $t0, $t0, 1 # Sumar 1 por cada iteraci�n
b fraccion_bucle

fin_recorrer: # Convertir la parte entera a binario y almacenarla en ParteEntera
li $t4, 23 # Contador de bits ParteEntera

convertir_a_binario_parteentera:
beqz $t1, fin_conversion_parteentera
andi $t2, $t1, 1 # Extraer el bit menos significativo
addi $t2, $t2, '0' # Convertir el bit a ASCII '0' o '1'
sb $t2, ParteEntera($t4) # Almacenar el bit en ParteEntera
srl $t1, $t1, 1 # Shift a la derecha el valor de $t1
subi $t4, $t4, 1 # Restar uno por cada iteraci�n
b convertir_a_binario_parteentera

fin_conversion_parteentera:
    
rellenar_ceros: # Rellenar con ceros el resto de ParteEntera si quedaron bits sin llenar
li $t2, '0'
sb $t2, ParteEntera($t4)
subi $t4, $t4, 1
bgez $t4, rellenar_ceros
    
li $t5, 0 # Contador de bits para ParteFraccion

convertir_fraccion_a_binario: # Convertir la parte fraccionaria a binario y almacenarla en ParteFraccion
bge $t5, 8, mostrar_resultado 
mul $t3, $t3, 2 # Multiplicar la parte fraccionaria por 2
bge $t3, $t7, fraccion_almacenar_uno # Si $t3 >= $t7, se va a fraccion_almacenar_uno para almacenar '1'
beq $t3, $t7, rellenar_fraccion_ceros # Si $t3 = $t7, se termina el proceso de conversi�n de fracci�n
beqz $t3, rellenar_fraccion_ceros # Si $t3 = $t7, se termina el proceso de conversi�n de fracci�n
# Si el bit no es 1, almacenar '0'
li $t2, '0'
sb $t2, ParteFraccion($t5)
addi $t5, $t5, 1
b convertir_fraccion_a_binario

fraccion_almacenar_uno:
sub $t3, $t3, $t7 # Se resta $t3 a $t7 para tener el nuevo n�mero a comparar
li $t2, '1'
sb $t2, ParteFraccion($t5)
addi $t5, $t5, 1
b convertir_fraccion_a_binario

rellenar_fraccion_ceros: # Rellenar con ceros el resto de ParteFraccion si quedaron bits sin llenar
li $t2, '0'
bge $t5, 8, mostrar_resultado

rellenar_fraccion:
sb $t2, ParteFraccion($t5)
addi $t5, $t5, 1
b rellenar_fraccion_ceros

mostrar_resultado: # Mostrar resultado de la conversi�n
li $v0, 4
la $a0, outputFraccion
syscall

li $v0, 4
la $a0, ParteEntera
syscall
    
li $v0, 4
la $a0, punto
syscall

li $v0, 4
la $a0, ParteFraccion
syscall

li $v0, 10 
syscall

### Ramas de Conversi�n ###

main:
    # Imprimir mensaje de entrada
    li $v0, 4
    la $a0, mensajeEntrada
    syscall

    # Leer el número entero N	
    li $v0, 5
    syscall
    move $t0, $v0  # Guardar el número en $t0

    # Imprimir mensaje de selección de conversión
    li $v0, 4
    la $a0, mensajeConversion
    syscall

    # Leer la elección de conversión
    li $v0, 5
    syscall
    move $t1, $v0  # Guardar la elección en $t1

    # Según la elección, realizar la conversión e imprimir
    beq $t1, 1, convertirHexadecimal
    beq $t1, 2, convertirOctal
    beq $t1, 3, imprimirBase10
    beq $t1, 4, convertirDecimalEmpaquetado
    beq $t1, 5, convertirBinarioComplemento
    j finPrograma

convertirHexadecimal:
    # Imprimir mensaje de número hexadecimal
    li $v0, 4
    la $a0, mensajeHexadecimal
    syscall

    # Determinar el signo y convertir número a positivo si es negativo
    bltz $t0, hexSignoNegativo
    la $a0, signoPositivo
    j printHexSigno

hexSignoNegativo:
    la $a0, signoNegativo
    negu $t0, $t0

printHexSigno:
    li $v0, 4
    syscall

    # Inicializar variables para hexadecimal
    li $t2, 7  # Contador de dígitos hexadecimales (32 bits -> 8 dígitos)
    li $t3, 28 # Desplazamiento inicial (4 bits por dígito)
    li $t5, 0  # Bandera para eliminar ceros a la izquierda

    imprimirHex:
        bltz $t2, finConversionHex  # Si el contador de dígitos es negativo, salir del bucle
        srlv $t4, $t0, $t3          # Desplazar el número a la derecha por $t3 bits
        andi $t4, $t4, 0xF          # Obtener los 4 bits menos significativos
        beqz $t4, skipZeroHex       # Omitir ceros a la izquierda
        li $t5, 1                   # Activar bandera
        lb $a0, digitosHex($t4)     # Obtener el carácter hexadecimal correspondiente
        li $v0, 11                  # Imprimir un solo carácter
        syscall
        j continuarHex

    skipZeroHex:
        bnez $t5, imprimirHex       # Imprimir ceros significativos

    continuarHex:
        subi $t3, $t3, 4            # Decrementar el desplazamiento en 4 bits
        subi $t2, $t2, 1            # Decrementar el contador de dígitos
        j imprimirHex

    finConversionHex:
    # Imprimir un salto de línea
    li $v0, 4
    la $a0, salto
    syscall
    j finPrograma

convertirOctal:
    # Imprimir mensaje de número octal
    li $v0, 4
    la $a0, mensajeOctal
    syscall

    # Determinar el signo y convertir número a positivo si es negativo
    bltz $t0, octSignoNegativo
    la $a0, signoPositivo
    j printOctSigno

octSignoNegativo:
    la $a0, signoNegativo
    negu $t0, $t0

printOctSigno:
    li $v0, 4
    syscall

    # Inicializar variables para octal
    li $t2, 10  # Contador de dígitos octales (32 bits -> 11 dígitos)
    li $t3, 30  # Desplazamiento inicial (3 bits por dígito)
    li $t5, 0   # Bandera para eliminar ceros a la izquierda

    imprimirOctal:
        bltz $t2, finConversionOct  # Si el contador de dígitos es negativo, salir del bucle
        srlv $t4, $t0, $t3          # Desplazar el número a la derecha por $t3 bits
        andi $t4, $t4, 0x7          # Obtener los 3 bits menos significativos
        beqz $t4, skipZeroOct       # Omitir ceros a la izquierda
        li $t5, 1                   # Activar bandera
        lb $a0, digitosOct($t4)     # Obtener el carácter octal correspondiente
        li $v0, 11                  # Imprimir un solo carácter
        syscall
        j continuarOct

    skipZeroOct:
        bnez $t5, imprimirOctal     # Imprimir ceros significativos

    continuarOct:
        subi $t3, $t3, 3            # Decrementar el desplazamiento en 3 bits
        subi $t2, $t2, 1            # Decrementar el contador de dígitos
        j imprimirOctal

    finConversionOct:
    # Imprimir un salto de línea
    li $v0, 4
    la $a0, salto
    syscall
    j finPrograma

imprimirBase10:
    # Imprimir mensaje de número en base 10
    li $v0, 4
    la $a0, mensajeBase10
    syscall

    # Imprimir el número en base 10 directamente
    li $v0, 1
    move $a0, $t0
    syscall

    # Imprimir un salto de línea
    li $v0, 4
    la $a0, salto
    syscall
    j finPrograma

convertirDecimalEmpaquetado:
    # Imprimir mensaje de número decimal empaquetado
    li $v0, 4
    la $a0, mensajeDecimalEmpaquetado
    syscall

    # Usar el número ingresado inicialmente para la conversión
    move $t2, $t0           # mover el número leído a $t2

    # Verificar si el número es negativo
    li $t1, 0               # inicializar $t1 en 0 (positivo)
    bltz $t2, negative      # si $t2 es negativo, saltar a etiqueta 'negative'

    # Caso positivo
    li $t1, 0xA             # si el número es positivo, $t1 será 0xA
    j convert               # saltar a la conversión

negative:
    li $t1, 0xB             # si el número es negativo, $t1 será 0xB
    negu $t2, $t2           # convertir el número a positivo

convert:
    li $t3, 0               # inicializar el resultado empaquetado en $t3
    li $t4, 4               # inicializar el contador de desplazamiento en 4 (dejar espacio para el signo)

loop:
    beqz $t2, finish        # si $t2 es 0, finalizar el loop
    li $t5, 10              # cargar el valor 10 en $t5 para la división
    divu $t2, $t5           # dividir $t2 entre 10
    mfhi $t6                # obtener el residuo (el dígito menos significativo)
    sllv $t6, $t6, $t4      # desplazar el dígito a la posición correcta usando $t4
    or $t3, $t3, $t6        # añadir el dígito al resultado
    mflo $t2                # obtener el cociente y almacenar en $t2
    addi $t4, $t4, 4        # mover a la siguiente posición (4 bits más)
    j loop                  # repetir el loop

finish:
    or $t3, $t3, $t1        # añadir el signo al resultado empaquetado en el primer nibble

    # Imprimir el resultado empaquetado en binario
    li $v0, 4               # syscall para imprimir string
    la $a0, mensajeDecimalEmpaquetado      # cargar la dirección del mensaje de salida
    syscall

    li $t7, 31              # contador para los bits (31 a 0)

print_loop:
    bgez $t7, print_bit     # si el contador es >= 0, imprimir el bit
    j end                   # si el contador es < 0, terminar

print_bit:
    srlv $t8, $t3, $t7      # desplazar el bit actual a la posición 0
    andi $t8, $t8, 1        # obtener el bit menos significativo
    addi $t8, $t8, 48       # convertir el bit en un carácter ASCII ('0' o '1')
    li $v0, 11              # syscall para imprimir un carácter
    move $a0, $t8           # cargar el carácter en $a0
    syscall
    subi $t7, $t7, 1        # decrementar el contador
    j print_loop            # repetir el loop

end:
    # Imprimir un salto de línea
    li $v0, 4
    la $a0, salto
    syscall
    j finPrograma

convertirBinarioComplemento:
    # Imprimir mensaje de número binario en complemento a 2
    li $v0, 4
    la $a0, mensajeBinarioComplemento
    syscall

    # Imprimir el número en binario complemento a 2
    li $t2, 31  # Contador de bits (32 bits -> 31 a 0)

    imprimirBinario:
        bltz $t2, finConversionBin  # Si el contador de bits es negativo, salir del bucle
        srlv $t4, $t0, $t2         # Desplazar el número a la derecha por $t2 bits
        andi $t4, $t4, 0x1         # Obtener el bit menos significativo
        addi $t4, $t4, 48          # Convertir el bit en carácter ASCII ('0' o '1')
        move $a0, $t4              # Mover el carácter a $a0
        li $v0, 11                 # Imprimir un solo carácter
        syscall
        subi $t2, $t2, 1           # Decrementar el contador de bits
        j imprimirBinario

    finConversionBin:
    # Imprimir un salto de línea
    li $v0, 4
    la $a0, salto
    syscall
    j finPrograma

finPrograma:
    # Salir del programa
    li $v0, 10
    syscall