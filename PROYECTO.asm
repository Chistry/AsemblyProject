.data
inputFraccion: .asciiz "Ingrese un número decimal con parte fraccionaria (por ejemplo, 2.75): "
outputFraccion: .asciiz "El numero convertido a binario es: "
inputDecimal: .space 20
ParteEntera: .space 25
ParteFraccion: .space 9
punto: .asciiz "."

.text
li $v0, 4
la $a0, inputFraccion
syscall

li $v0, 8 
la $a0, inputDecimal 
li $a1, 20
syscall

li $t0, 0 # Registro para recorrer la cadena
li $t1, 0 # Registro para almacenar la parte entera
li $t2, 0 # Registro para manipulación de caracteres
li $t3, 0 # Registro para almacenar la parte fraccionaria
li $t7, 1 # Registro para tener tener la cantidad de multiplicaciones por 10 según la cantidad de digitos que tenga la fracción fracción

recorrer:
lb $t2, inputDecimal($t0)
beq $t2, '.', empezar_fraccion # Si el byte es el punto, pasa a la parte fraccionaria
beq $t2, 0, fin_recorrer # Si es el final de la cadena, termina de iterar en el
subi $t2, $t2, '0' # Convertir ASCII a número (restar el valor ASCII de '0')
mul $t1, $t1, 10 # Multiplicar el valor acumulado por 10
add $t1, $t1, $t2 # Sumar el nuevo numero al acumulado
addi $t0, $t0, 1 # Sumar 1 por cada iteración
b recorrer 
	
empezar_fraccion:
addi $t0, $t0, 1 # Se avanza un byte, porque la anterior iteración teminó en el punto

fraccion_bucle:
lb $t2, inputDecimal($t0)
beqz $t2, fin_recorrer # Si es el final de la cadena, termina de iterar en el
beq $t2, 10, fin_recorrer # Si es el final de la cadena, termina de iterar en el
subi $t2, $t2, '0' # Convertir ASCII a número
mul $t3, $t3, 10 # Multiplicar el valor acumulado por 10
add $t3, $t3, $t2 # Sumar el nuevo numero al acumulado
mul $t7, $t7, 10 # Multiplicar por 10 cada digito que encuentre
addi $t0, $t0, 1 # Sumar 1 por cada iteración
b fraccion_bucle

fin_recorrer: # Convertir la parte entera a binario y almacenarla en ParteEntera
li $t4, 23 # Contador de bits ParteEntera

convertir_a_binario_parteentera:
beqz $t1, fin_conversion_parteentera
andi $t2, $t1, 1 # Extraer el bit menos significativo
addi $t2, $t2, '0' # Convertir el bit a ASCII '0' o '1'
sb $t2, ParteEntera($t4) # Almacenar el bit en ParteEntera
srl $t1, $t1, 1 # Shift a la derecha el valor de $t1
subi $t4, $t4, 1 # Restar uno por cada iteración
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
beq $t3, $t7, rellenar_fraccion_ceros # Si $t3 = $t7, se termina el proceso de conversión de fracción
beqz $t3, rellenar_fraccion_ceros # Si $t3 = $t7, se termina el proceso de conversión de fracción
# Si el bit no es 1, almacenar '0'
li $t2, '0'
sb $t2, ParteFraccion($t5)
addi $t5, $t5, 1
b convertir_fraccion_a_binario

fraccion_almacenar_uno:
sub $t3, $t3, $t7 # Se resta $t3 a $t7 para tener el nuevo número a comparar
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

mostrar_resultado: # Mostrar resultado de la conversión
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
