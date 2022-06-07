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
