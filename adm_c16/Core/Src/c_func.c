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

void invertir (uint16_t * vector, uint32_t longitud)
{
	uint16_t aux;
	uint32_t index1 = 0, index2 = longitud - 1, loops;

	loops = longitud/2;
	while(loops--)
	{
		aux = vector[index2];
		vector[index2] = vector[index1];
		vector[index1] = aux;
		index1++;
		index2--;
	}
}
