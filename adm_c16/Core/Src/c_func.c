/*
 * c_func.c
 *
 *  Created on: 31 may. 2022
 *      Author: Win10
 */
#include "c_func.h"

void llenaArreglo32(uint32_t *vectorOut, uint32_t longitud)
{
	while(longitud--)
	{
		vectorOut[longitud] = longitud;
	}
}

void llenaArreglo16(uint16_t *vectorOut, uint32_t longitud)
{
	while(longitud--)
	{
		vectorOut[longitud] = longitud;
	}
}

void llenaArregloS1(int16_t *vectorOut, uint32_t longitud)
{
	int16_t i = 10;
	while(longitud--)
	{
		vectorOut[longitud] = i;
		i-=3;
	}
}

void llenaArregloS2(int16_t *vectorOut, uint32_t longitud)
{
	int16_t i = 13;
	while(longitud--)
	{
		vectorOut[longitud] = i;
		i-=4;
	}
}

void llenaArregloSignado1(int32_t *vectorOut, uint32_t longitud)
{
	while(longitud--)
	{
		vectorOut[longitud] = longitud;
	}
}

void llenaArregloSignado2(int32_t *vectorOut, uint32_t longitud)
{
	while(longitud--)
	{
		vectorOut[longitud] = -1;
	}
}

void llenaArregloSignado16(int16_t *vectorOut, uint32_t longitud)
{
	while(longitud--)
	{
		vectorOut[longitud] = -1;
	}
}

void llenaVectorCorr16(int16_t *vectorOut, uint32_t longitud)
{
	while(longitud--)
	{
		vectorOut[longitud] = -1;
	}
}

void llenaVectorX(int16_t *vectorOut, uint32_t longitud)
{
	int16_t valor = 21;
	while(longitud--)
	{
		vectorOut[longitud] = valor;
		valor -= 2;
	}
}

void llenaVectorY(int16_t *vectorOut, uint32_t longitud)
{
	int16_t valor = 24;
	while(longitud--)
	{
		vectorOut[longitud] = valor;
		valor -= 2;
	}
}


void llenaArregloSignado32(int32_t *vectorOut, uint32_t longitud)
{
	int32_t i=-10000;
	while(longitud--)
	{
		vectorOut[longitud] = i;
		i=i+30000;
	}
}

void llenaArregloSignado(int32_t *vectorOut, uint32_t longitud)
{
	int32_t i=70;
	while(longitud--)
	{
		vectorOut[longitud] = i;
		i-=10;
	}
	vectorOut[5] = 200;
}

//Recorro el arreglo de atrás hacia adelante
void zeros(uint32_t *vector, uint32_t longitud)
{
	while(longitud--)
	{
		vector[longitud] = 0;
	}
}

void productoEscalar32(uint32_t *vectorIn, uint32_t *vectorOut, uint32_t longitud, uint32_t escalar)
{
	while(longitud--)
	{
		vectorOut[longitud] = vectorIn[longitud] * escalar;
	}
}

void productoEscalar16(uint16_t *vectorIn, uint16_t *vectorOut, uint32_t longitud, uint16_t escalar)
{
	while(longitud--)
	{
		vectorOut[longitud] = vectorIn[longitud] * escalar;
	}
}

void productoEscalar12(uint16_t *vectorIn, uint16_t *vectorOut, uint32_t longitud, uint16_t escalar)
{
	while(longitud--)
	{
		vectorOut[longitud] = vectorIn[longitud] * escalar;
		if(vectorOut[longitud] > (uint16_t) 0x0FFF)
		{
			vectorOut[longitud] = (uint16_t) 0x0FFF;
		}
	}
}

int32_t max (int32_t * vectorIn, uint32_t longitud)
{
    int32_t valorMaximo  = vectorIn[longitud-1]; //Empiezo en el último valor
    int32_t indiceMaximo = longitud-1;			 //Empiezo en el último índice

    while(longitud--)
    {
        if(vectorIn[longitud] >= valorMaximo)
        {
        	valorMaximo  = vectorIn[longitud];
        	indiceMaximo = longitud;
        }
    }
    return indiceMaximo;
}

void invertir (uint16_t * vector, uint32_t longitud)
{
	uint16_t aux;
	uint32_t i1 = 0;					//i1 comienza en el primer elemento y luego se incrementa
	uint32_t i2 = longitud - 1; 		//i2 comienza en el último elelmento y luego se decrementa
	uint32_t inversiones = longitud/2;	//cantidad de inversiones (la mitad del elemento del arreglo, tanto si es par o impar)
	while(inversiones--)
	{
		aux = vector[i2];
		vector[i2] = vector[i1];
		vector[i1] = aux;
		i1++;
		i2--;
	}
}

void filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn)
{
	uint8_t longitudVentana = 10;
	uint32_t indice = 0;
	uint32_t indiceVentana = 0;
	uint32_t suma = 0;
	uint32_t promedio = 0;
	while(indice < longitudVectorIn) // desde 0 hasta 7
	{

		for(uint8_t i = 0; i<longitudVentana; i++) // desde 0 hasta 3
		{
			if( (indice+i) < longitudVectorIn)
			{
				indiceVentana = (indice+i);
			}
			else
			{
				indiceVentana = (indice+i) % longitudVectorIn;
			}
			suma += vectorIn[indiceVentana];
		}

		promedio = (float) suma/longitudVentana;
		vectorOut[indice] = promedio;
		indice++;
		suma = 0;
	}
}

void downsampleM(int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N)
{
	uint32_t indiceN = 0;	//recorre vector ignorando cada N elementos
	uint32_t indiceOut=0;	//índice vector de salida, será menor a medida que se quitan elementos

	for(uint32_t indiceIn=0; indiceIn<longitud; indiceIn++) //recorre vector de entrada
	{

		if( indiceN >= (N-1) )	//descarta el N-ésimo elemento, vuelve a contar desde 0
		{
			indiceN = 0;
		}
		else		   			//llega hasta N-1
		{
			vectorOut[indiceOut] = vectorIn[indiceIn];
			indiceOut++;
			indiceN ++;
		}
	}
}

void pack32to16 (int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud)
{
    while(longitud--)
    {
        vectorOut[longitud] = vectorIn[longitud] >> 16;
    }
}

void corr (int16_t *vectorX, int16_t *vectorY, int32_t *vectorCorr, uint32_t longitud)
{
	uint32_t longitudVector = longitud;
	while(longitud--)
	{
		vectorCorr[longitud] = 0;
		for(int32_t i = 0; i < longitudVector; i++)
		{
			if( i>=longitud )
			{
				vectorCorr[longitud] += (vectorX[i]*vectorY[i-longitud]);
			}
		}
	}
}
