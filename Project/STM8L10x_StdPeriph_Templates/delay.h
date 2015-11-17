#ifndef _DELAY_H_
#define _DELAY_H_

#include "board.h"

void delay_ms(u16);
void delay_tim4(u8);

#define DELAY_US( loops ) _asm("$N: \n decw X \n jrne $L \n nop", (u16)loops);

#endif