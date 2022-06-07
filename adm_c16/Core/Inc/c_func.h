/*
 * c_func.h
 *
 *  Created on: 31 may. 2022
 *      Author: Win10
 */

#ifndef INC_C_FUNC_H_
#define INC_C_FUNC_H_

#include <stdint.h>

void llenaArreglo32(uint32_t *vectorOut, uint32_t longitud);

void llenaArreglo16(uint16_t *vectorOut, uint32_t longitud);

void llenaArregloSignado(int32_t *vectorOut, uint32_t longitud);

void zeros(uint32_t *vector, uint32_t longitud);

void productoEscalar32(uint32_t *vectorIn, uint32_t *vectorOut, uint32_t longitud, uint32_t escalar);

void productoEscalar16(uint16_t *vectorIn, uint16_t *vectorOut, uint32_t longitud, uint16_t escalar);

void productoEscalar12(uint16_t *vectorIn, uint16_t *vectorOut, uint32_t longitud, uint16_t escalar);

int32_t max (int32_t * vectorIn, uint32_t longitud);

void invertir (uint16_t * vector, uint32_t longitud);

#endif /* INC_C_FUNC_H_ */
