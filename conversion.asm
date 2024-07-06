.data

msg1: .asciiz "Inicializando conversor de números \n"
msg2: .asciiz "Ingrese abajo el valor que corresponda al tipo del número que desea ingresar \n \n"
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

.macro hexadecimal
# Input del ususario
li $v0 8
la $a0 numHex
li $a1 9
syscall

li $t0 0 # Resultado
li $t1 0 # Pointer

bucleCasteo:
lb $t2 numHex($t1) # Se carga el bit correspondiente a la posición en la que se encuentre el lector
beq $t2 0 finBucleCasteo # Se comprueba si debe seguir el bucle

blt $t2 58 esNumero # Se verifica si es un número
b esLetra # Se verifica si es una letra

esNumero:
addi $t2 $t2 -48 # Se le resta su valor según la tabla ascii
b continuarBucleCasteo

esLetra:
addi $t2 $t2 -55 # Se le resta su valor según la tabla ascii
b continuarBucleCasteo

continuarBucleCasteo:

# Se realiza un shift para pasar al siguiente valor en el número hexadecimal
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
# Obtener el dígito actual
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
# Se extrae el primer dígito del octal
addi $t1, $t0, -4                             
andi $t1, $t1, 0x0F                           

# Multiplicar los dígitos por la potencia de 8 que les corresponda
mul $t3, $t1, $t2                           
add $v0, $v0, $t3                            

# Actualizar el valor para el siguiente dígito
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

### Salto a la rama adecuada según el input del usuario ###

beq $t0 1 conversionBinario
beq $t0 2 conversionDecimalEmp
beq $t0 3 conversionBase10
beq $t0 4 conversionOctal
beq $t0 5 conversionHexadecimal
beq $t0 6 conversionDecimal

### Salto a la rama adecuada según el input del usuario ###

### Ramas de conversión ###

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




### Ramas de Conversión ###