.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32
.global asm_productoEscalar16
.global asm_productoEscalar12
.global asm_productoEscalar12_usat
.global asm_max
.global asm_invertir
.global asm_filtroVentana10

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint32_t *vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: *vector
@   r1: longitud
@
.thumb_func
    asm_zeros:
        @ Registros usados
        @   r2: valor cero
        mov r2, 0           @ constante cero en r2
    .asm_zeros_loop:
        str r2, [r0], 4    	@str carga en memoria el valor de un registro
        					@carga en memoria (r0=*vector[0]) lo que tengo en r2 (0) y luego r0+=4 --> r0=*vector[1];
        					@ sizeof(uint32_t) == 4, *vector++ = r2. //
        subs r1, 1          @ r1-=1; longitud--; y actualiza flag de estado del procesador
        bne .asm_zeros_loop @vuelve a repetir el ciclo, con salto condicional (NE: not equal, flag Z=0), es decir mientras r1 no sea 0
        bx lr				@retorna link register


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@	r2: longitud
@	r3: escalar
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

    asm_productoEscalar32:

    push {r5}
	push {r6}

    .loop32:
    	ldr	r5, [r0], 4 	@carga un registro r5 con un valor de memoria r0 y luego r0+=4;
    						@es decir, carga en r5 lo que hay en r0 (*vectorIn) e incrementa el puntero de vectorIn
    	mul r6, r5, r3  	@multiplica r5 por r3 (escalar) y lo guarda en r6
		str r6, [r1], 4 	@carga en memoria r1 lo que tengo en r6 y luego r1+=4;
							@es decir, carga en r1 vectorIn[0]*escalar e incrementa el puntero de vectorOut
    	subs r2, 1      	@decrementa en 1 a r2 (longitud--)y actualiza flag de estado del procesador
        bne	.loop32			@vuelve a .loop32, ejecución condicional (Not Equal, es decir Z=0)

        pop {r6}
        pop {r5}

        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@	r2: longitud
@	r3: escalar
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

    asm_productoEscalar16: //Nota: da el mismo resultado ldr y str con parámetro 4, que ldrh t strh con parámetro 2

    push {r8}
	push {r9}

    .loop16:
    	ldrh	r8, [r0], 2 	@carga un registro r8 con un valor de memoria r0 y luego r0+=4;
    							@es decir, carga en r8 lo que hay en r0 (*vectorIn) e incrementa el puntero de vectorIn
    	mul 	r9, r8, r3  	@multiplica r8 por r3 (escalar) y lo guarda en r6
		strh 	r9, [r1], 2 	@carga en memoria r1 lo que tengo en r9 y luego r1+=4;
								@es decir, carga en r1 vectorIn[0]*escalar e incrementa el puntero de vectorOut
    	subs 	r2, 1      		@decrementa en 1 a r2 (longitud--)
        bne		.loop16			@vuelve a .loop16, ejecución condicional (Not Equal, es decir Z=0)

        pop {r9}
        pop {r8}

        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@	r2: longitud
@	r3: escalar
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

    asm_productoEscalar12:

    push {r4}
	push {r5}
	push {r6}
	mov r6, #0x0FFF		//valor a saturar
    .asm_productoEscalar12_loop12:
		    	ldrh  	r4, [r0], 2 	@ carga un registro r4 con un valor de memoria r0 y luego r0+=2;
		    							@ es decir, carga en r4 lo que hay en r0 (*vectorIn) e incrementa el puntero de vectorIn
		    	mul 	r5, r4,  r3  	@ multiplica r4 por r3 (escalar) y lo guarda en r5
				cmp		r6, r5		    @ compara r5 con r6 (resta)
				bhi		isNO			@ higher unsigned

		isYES: //Saturó
				mov 	r5, r6  		@ satura resultado a 12 bits
				b isNO 					@ salto incondicional a done

		isNO:
				strh  	r5, [r1], 2		@ carga en memoria r1 lo que tengo en r5 y luego r1+=2; <----
										@ es decir, carga en r1 vectorIn[0]*escalar e incrementa el puntero de vectorOut
		    	subs 	r2, 1      		@ decrementa en 1 a r2 (longitud--)
		        bne		.asm_productoEscalar12_loop12			@ vuelve a .loop12, ejecución condicional (Not Equal, es decir Z=0)

	pop {r6}
    pop {r5}
    pop {r4}

    bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@	r2: longitud
@	r3: escalar
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

    asm_productoEscalar12_usat:

    push {r8}
	push {r9}

    .loop12_usat:
    	ldrh  	r8, [r0], 2 	@carga un registro r8 con un valor de memoria r0 y luego r0+=2; <------
    							@es decir, carga en r8 lo que hay en r0 (*vectorIn) e incrementa el puntero de vectorIn
    	mul 	r9, r8,  r3  	@multiplica r8 por r3 (escalar) y lo guarda en r9
		usat 	r9, 12,  r9    //AGREGADO SATURACIÓN a 12 bits
		strh  	r9, [r1], 2 	@carga en memoria r1 lo que tengo en r9 y luego r1+=2; <----
								@es decir, carga en r1 vectorIn[0]*escalar e incrementa el puntero de vectorOut
    	subs 	r2, 1      		@decrementa en 1 a r2 (longitud--)
        bne		.loop12_usat	@vuelve a .loop12, ejecución condicional (Not Equal, es decir Z=0)

    pop {r9}
    pop {r8}

    bx lr

        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_invertir (uint16_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vector
@   r1: longitud
@
@ Valor de retorno:
@   Ninguno
@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ int32_t asm_max (int32_t * vectorIn, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vector
@   r1: longitud
@
@ Valor de retorno:
@   r0: posicion en el vector del maximo valor
@
.thumb_func

	    asm_max:

    	push {r4}
    	push {r5}

    	ldr r2, [r0], 4    		@ guardo en r2=*r0 (primer elemento del arreglo) e incremento puntero
    	mov r3, 1				@ r3 = 1; --> índice Máximo inicial
    	mov r4, 1				@ r4 = 1;
		subs r1, 1				@ r1-= 1; longitud--;
        beq .endMax				@ salto condicional Equal (Z=1) --> if(longitud==0) goto endMax

		.loopMax:
			add r4, 1			@ r4+=1; --> r4 = 2;
			ldr r5, [r0], 4		@ r5 = *r0
			cmp r2, r5			@ comparo elemento actual con anterior
			bgt .saltoMax		@ salto condicional Greater Than signed (Z=0, N=V) --> si encontré un nuevo máximo, goto salto
			mov r2, r5			@ actualizo elemento actual
			mov r3, r4			@ actualizo índice Máximo

		.saltoMax:
	    	subs r1, 1			@ r1-= 1; longitud--;
	        bne	.loopMax		@ salto condicional Not Equal (Z=0) --> if(longitud!=1) goto loopMax

	    .endMax:
	        sub r3, 1
	        mov r0, r3			@ guardo en valor de retorno el índice máximo

	    pop {r5}
	    pop {r4}
		bx lr

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_invertir (uint16_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vector
@   r1: longitud
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

    asm_invertir:
   		// N = número de bytes ocupados
    	// ejemplo longitud = 10 --> N = 2*10 = 20
		// 0 a longitud-1 -> 0 a 18 bytes
        push {r4}

        subs r1, 1			@longitud--; 	--> longitud = 9
        beq .end_invertir	@salto condicional Equal (Z=1) --> if(longitud==1) goto end_invertir

    	mov r3, 2			@r3 = 2
    	mul r4, r1, r3		@r4 = (longitud-1)*2 = 18
    	add r4, r0			@r4  = r4 + *vector[0] = 18 + *vector[0] = *vector[longitud-1]

    	add r1, 1			@longitud++;   --> longitud = 10;
    	udiv r1, r1, r3		@r1 = r1/r3    --> longitud = 5;

    	//r0 <-- puntero a primer elemento
    	//r4 <-- puntero a último elemento

	.loop_invertir:

    	ldrh r2, [r0]		@r2 = *vector[0]				//guarda en r2 el primer elemento
    	ldrh r3, [r4]		@r3 = *vector[longitud-1]		//guarda en r3 el último elemento
		strh r3, [r0],  2	@r0 = N + *vector [0]; r0+=2;   //guarda en memoria r0 el último elemento, y r0++; (sobreescribe último en primero)
		strh r2, [r4], -2   @r4 = vector[0]; r0-=2;			//guarda en memoria r0 el primer elemento, y r4--;

    	subs r1, 1			@longitud--; 	--> longitud = 4
        bne	.loop_invertir	@salto condicional Not Equal (Z=0) --> if(longitud!=1) goto loop_invertir

	.end_invertir:

        pop {r4}
        bx lr

        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn)
@
@ Parametros recibidos:
@   r0: * vector
@   r1: * vector
@	r2: longitud
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

	asm_filtroVentana10:

    push {r4}
    push {r5}
    push {r6}
    push {r7}
    push {r8}
	mov r3, 0			// indice

		.ventana_loop1:

			mov r4, 0			@ promedio
			mov r5, 0			@ i=0 (for)

		.ventana_for:

			add r6, r3, r5		@ r6 = indice+i
			cmp r6, r2			@ if(r6<longitud)
			blt .ventana_salto	@ salgo condicional, Less Than
								@ sino, ventana salió del arreglo
			udiv r7, r6, r2		@ (indice+i) % longitudVectorIn
			mul r7, r7, r2		@ indiceVentana = indiceVentana*longitud
			sub r6, r6, r7		@ r6 = (indice+i)*indiceVentana

		.ventana_salto:

			mov r8, 2
			mul r6, r6, r8		@ (indice+i) = (indice+i)*2
			add r6, r0, r6		@ (indice+1)*2+vectorIn
			ldrh r8, [r6]		@ r8 <-- puntero a próximo elemento de vectorIn
			add r4, r4, r8		@ promedio+=2
			add r5, 1			@ i++ (for)
			cmp r5, 10			@ i<10 (for)
			blt .ventana_for    @ vuelve a iniciar (for)

			mov r8, 10
			udiv r8, r4, r8
			strh r8, [r1], 2
			add r3, 1
			cmp r3, r2
			blt .ventana_loop1

	pop {r8}
    pop {r7}
	pop {r6}
    pop {r5}
    pop {r4}

	bx lr
