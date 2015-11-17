#ifndef _BOARD_H_
#define _BOARD_H_

#include "stm8l10x_conf.h"

/* Board LED
PD0: Port D0 / Timer 1 - break input / Configurable clock output [AFR5]
*/
#define LED_PORT  GPIOB 
#define LED_PIN   GPIO_Pin_3
#define LED_OFF   (LED_PORT->ODR |= LED_PIN)
#define LED_ON    (LED_PORT->ODR &= (u8)(~LED_PIN))
#define LED_STATE (LED_PORT->IDR & LED_PIN)

//IR
#define IRIN_PORT   GPIOB
#define IRIN_PIN    GPIO_Pin_0 
#define IRIN_STATE  (IRIN_PORT->ODR |= IRIN_PIN)

//USART
#define USART_PORT   GPIOC
#define USARTRX_PIN  GPIO_Pin_2 
#define USARTTX_PIN  GPIO_Pin_3 

#endif