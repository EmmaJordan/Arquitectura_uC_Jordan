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
.global asm_downsampleM
.global asm_pack32to16
.global asm_fusion
.global asm_corr

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
    	ldrh	r8, [r0], 2 	@carga un registro r8 con un valor de memoria r0 y luego r0+=2;
    							@es decir, carga en r8 lo que hay en r0 (*vectorIn) e incrementa el puntero de vectorIn
    	mul 	r9, r8, r3  	@multiplica r8 por r3 (escalar) y lo guarda en r6
		strh 	r9, [r1], 2 	@carga en memoria r1 lo que tengo en r9 y luego r1+=2;
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
@   r0: * vectorIn
@   r1: * vectorOut
@	r2: longitud
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

	asm_filtroVentana10:

    push {r4}
    push {r5}
    push {r6}			//indiceVentana
    push {r7}
    push {r8}
	mov r3, 0			// indice

		.ventana_while:

			mov r4, 0			@ promedio lo vuelve a 0 en cada vuelta
			mov r5, 0			@ i=0

		.ventana_for:

			add r6, r3, r5		@ r6 = indice+i
			cmp r6, r2			@ if(r6<longitud)
			blt .ventana_salto	@ salgo condicional, Less Than
								@ sino, ventana salió del arreglo
			udiv r7, r6, r2		@ r7 = (indice+i) / longitudVectorIn
			mul r7, r7, r2		@ r7 = r7*longitudVectorin
			sub r6, r6, r7		@ r6 = (indice+i) % longitudVectorIn

		.ventana_salto:

			mov r8, 2
			mul r6, r6, r8		@ (indice+i) = (indice+i)*2
			add r6, r0, r6		@ (indice+1)*2+vectorIn
			ldrh r8, [r6]		@ r8 <-- guarda valor apuntado a vectorIn
			add r4, r4, r8		@ suma valor apuntado y acumula
			add r5, 1			@ i++ (for)
			cmp r5, 10			@ i<10 (for)
			blt .ventana_for    @ vuelve a iniciar (for)

			mov r8, 10			@r8 = longitudVentana = 10
			udiv r8, r4, r8		@r8 = sumaAcumulada/10 = promedio
			strh r8, [r1], 2    @guarda en memoria r1 (vectorOut) el promedio e incrementa puntero
			add r3, 1			@índice++
			cmp r3, r2			@if(indice<longitudVectorin)
			blt .ventana_while	@salto condicional Less Than

	pop {r8}
    pop {r7}
	pop {r6}
    pop {r5}
    pop {r4}

	bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N);
@
@ Parametros recibidos:
@   r0: * vector
@   r1: * vector
@	r2: longitud
@	r3: N
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

	asm_downsampleM:

	push {r4}				@ indiceN
	push {r5}				@ indiceOut

	mov r4, 1

	.downSample_for:

		ldr r5, [r0], 4		@ r5 = *vectorIn; *vectorIn++;
		cmp r4, r3			@ if ( indiceN==N )
		beq .downSample_1	@ salto condicional Equal
		str r5, [r1], 4		@ vectorOut = *vectorIn; *vectorOut++
		bal .downSample_2	@ salto condicional Any Value

	.downSample_1:

		mov r4, 0			@ índiceN = 1

	.downSample_2:

		add  r4, 1			@ índiceN++
		subs r2, 1			@ longitud --
		bne .downSample_for @ salto condicional Not Equal (for)

	pop {r6}
	pop {r5}
	pop {r4}
	bx lr

	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void pack32to16 (int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vectorIn
@   r1: * vectorOut
@	r2: longitud
@
@ Valor de retorno:
@   Ninguno
@
.thumb_func

asm_pack32to16:

add r0, 2

.pack32to16_while:

	ldrh r3, [r0], 4		@r3 = *vectorIn (parte alta h), *vectorIn++; (4 bytes)
	strh r3, [r1], 2		@vectorOut = *vectorIn; vectorOut++; (2 bytes)
	subs r2, 1          	@ --longitud
    bne	.pack32to16_while   @salto condicional Not Equal
	bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void fusion(int16_t *salida, int16_t *s1, int16_t *s2, uint16_t cant);
@
@ Parametros recibidos:
@   r0: *salida
@   r1: *s1
@	r2: *s2
@	r3: cant
@
@ Valor de retorno:
@   Ninguno
@
#define salida r0
#define s1 r1
#define s2 r2
#define cant r3

.thumb_func

asm_fusion:
//Ejemplo cantidad = 10
push {r4-r5, lr}
asr cant,1 			//shift un bit a la derecha --> cantidad = 5 (mitad de veces con instrucciones SIMD)
sub cant,1			//longitud--; --> cantidad = 4 (loop 4 a 0)

	fusion_while:
		ldr r4, [s1, cant, LSL 2]   	@ cant = 4 --> r4 = *(s1+16)  <-- avanza de a 32 bits (guarda de 2 valores de 16 bits)
										@ cant = 3 --> r4 = *(s1+12)
										@ cant = 2 --> r4 = *(s1+8)
										@ cant = 1 --> r4 = *(s1+4)
										@ cant = 0 --> r4 = *(s1+0)

		ldr r5, [s2, cant, LSL 2]   	@ cant = 4 --> r5 = *(s2+16)  <-- avanza de a 32 bits (guarda de a 2 valores de 16 bits)
										@ cant = 3 --> r5 = *(s2+12)
										@ cant = 2 --> r5 = *(s2+8)
										@ cant = 1 --> r5 = *(s2+4)
										@ cant = 0 --> r5 = *(s2+0)

		shadd16 r5, r5, r4				@ instrucción SIMD semi-suma  <-- suma r4a con r5a y r4b con r5b

		str r5, [salida, cant, LSL 2]	@ cant = 4 --> *(salida+16) = r5  <-- avanza de a 32 bits (carga de a 2 valores de 16 bits)
										@ cant = 3 --> *(salida+12) = r5
										@ cant = 2 --> *(salida+8)  = r5
										@ cant = 1 --> *(salida+4)  = r5
										@ cant = 0 --> *(salida+0)  = r5

		subs cant, 1					@longitud--;
		bpl fusion_while				@salto condicional Positive or Zero

pop {r4-r5, pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void fusion(int16_t *vectorX, int16_t *vectorY, int16_t *vectorCorr, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: *vectorX
@   r1: *vectorY
@	r2: *vectorCorr
@	r3: longitud
@
@ Valor de retorno:
@   Ninguno
@

#define vectorX 	r0
#define vectorY 	r1
#define vectorCorr	r2
#define longitud 	r3

.thumb_func

asm_corr:
//Ejemplo cantidad = 10
push {r4-r6, lr}
asr longitud,1 			//shift un bit a la derecha --> cantidad = 5 (mitad de veces con instrucciones SIMD)
sub longitud,1			//longitud--; --> cantidad = 4 (loop 4 a 0)

	corr_while:
		ldr r4, [vectorX, longitud, LSL 2]   	@ longitud = 4 --> r4 = *(vectorX+16)  <-- avanza de a 32 bits (guarda de 2 valores de 16 bits)
												@ longitud = 3 --> r4 = *(vectorX+12)
												@ longitud = 2 --> r4 = *(vectorX+8)
												@ longitud = 1 --> r4 = *(vectorX+4)
												@ longitud = 0 --> r4 = *(vectorX+0)

		ldr r5, [vectorY, longitud, LSL 2]   	@ longitud = 4 --> r5 = *(vectorY+16)  <-- avanza de a 32 bits (guarda de a 2 valores de 16 bits)
												@ longitud = 3 --> r5 = *(vectorY+12)
												@ longitud = 2 --> r5 = *(vectorY+8)
												@ longitud = 1 --> r5 = *(vectorY+4)
												@ longitud = 0 --> r5 = *(vectorY+0)

		shadd16 r6, r5, r4						@ smuad: instrucción SIMD Signed Dual Multiply Add

		str r6, [vectorCorr, longitud, LSL 2]	@ longitud = 4 --> *(vectorCorr+16) = r6  <-- avanza de a 32 bits (carga de a 2 valores de 16 bits)
												@ longitud = 3 --> *(vectorCorr+12) = r5
												@ longitud = 2 --> *(vectorCorr+8)  = r5
												@ longitud = 1 --> *(vectorCorr+4)  = r5
												@ longitud = 0 --> *(vectorCorr+0)  = r5

		subs longitud, 1						@longitud--;
		bpl corr_while							@salto condicional Positive or Zero

pop {r4-r6, pc}
