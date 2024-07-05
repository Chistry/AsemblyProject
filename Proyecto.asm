.data
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

.text
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



