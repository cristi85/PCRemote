#ifndef _BOARD_H_
#define _BOARD_H_

#include "stm8s_conf.h"

/* 1Wire Bus 
PB6: Port B6
*/
#define ONEWIREBUS_PORT   GPIOB
#define ONEWIREBUS_PIN    GPIO_PIN_6
#define OW_LOW()  (ONEWIREBUS_PORT->ODR &= (u8)(~ONEWIREBUS_PIN))   /* drive 1-wire bus low */
#define OW_HIGH() (ONEWIREBUS_PORT->ODR |= ONEWIREBUS_PIN)          /* release 1-wire bus */
#define OW_READ() (u8)(ONEWIREBUS_PORT->IDR & ONEWIREBUS_PIN)       /* read 1-wire bus */

/* Board LED
PD0: Port D0 / Timer 1 - break input / Configurable clock output [AFR5]
*/
#define LED_PORT  GPIOD 
#define LED_PIN   GPIO_PIN_0
#define LED_OFF   (LED_PORT->ODR |= LED_PIN)
#define LED_ON    (LED_PORT->ODR &= (u8)(~LED_PIN))
#define LED_STATE (LED_PORT->IDR & LED_PIN)

/* Board Button
PB7, Button press means 0 in port IDR
*/
#define BTN_PORT  GPIOB 
#define BTN_PIN   GPIO_PIN_7
#define BTN_STATE (BTN_PORT->IDR & BTN_PIN)

// RF receive input pin
// PC2 / (TIM1-CH2)
// PC3 / (PC3: TIM1-CH3)
//---------------------
#define RFRCV_PORT  GPIOC
#define RFRCV_PIN   GPIO_PIN_2      //configured as trigger reset and capture for timer1 on falling edge

#define KL15_PORT   GPIOC
#define KL15_PIN    GPIO_PIN_1
#define KL15_STATE  (KL15_PORT->IDR & KL15_PIN)

//RF send for testing
#define RFSEND_PORT   GPIOC
#define RFSEND_PIN    GPIO_PIN_3 
#define RFSEND_LOW()  (RFSEND_PORT->ODR &= (u8)(~RFSEND_PIN))   /* drive RF out pin low */
#define RFSEND_HIGH() (RFSEND_PORT->ODR |= RFSEND_PIN)          /* drive RF out pin high */

/* Sonar trigger pin 
PB7: Port B7
Sonar capture pins:
PC2: Port C2 / Timer 1 - channel 2
PC3: Port C3 / Timer 1 - channel 3
*/
#ifdef ENABLE_SONAR
#define SONAR_TRIG_PORT  GPIOB
#define SONAR_TRIG_PIN   GPIO_PIN_7
#define SONAR_TMR_TRIG_PORT GPIOC
#define SONAR_TMR_TRIG_PIN  GPIO_PIN_2
#define SONAR_TMR_CAP_PORT  GPIOC
#define SONAR_TMR_CAP_PIN   GPIO_PIN_3
#define SONAR_TRIG_ON    (SONAR_TRIG_PORT->ODR |= SONAR_TRIG_PIN)
#define SONAR_TRIG_OFF   (SONAR_TRIG_PORT->ODR &= (u8)(~SONAR_TRIG_PIN))
#define SONAR_TRIG_STATE (SONAR_TRIG_PORT->IDR & SONAR_TRIG_PIN)
#endif

/* Software I2C CONFIG
PB2: Port B2 / I2C clock
PB3: Port B3 / I2C data
*/
#define SOFTI2C_PORT     GPIOB
#define SOFTI2C_SCL_PIN  GPIO_PIN_2
#define SOFTI2C_SDA_PIN  GPIO_PIN_3

/* Hardware SPI CONFIG
PE5: Port E5 / SPI master/slave select (SPI NSS)
PC5: Port C5 / SPI clock
PC6: Port C6 / SPI MOSI
PC7: Port C7 / SPI MISO
*/
#define SPI_CS_HIGH  (GPIOC->ODR |= GPIO_PIN_4)
#define SPI_CS_LOW   (GPIOC->ODR &= (u8)(~GPIO_PIN_4))

/* Hardware USART
PD5: Port D5 / UART1 data transmit
PD6: Port D6 / UART1 data receive
 */
#define USART_PORT    GPIOD
#define USART_TX_PIN  GPIO_PIN_5
#define USART_RX_PIN  GPIO_PIN_6

/*-7 SEGMENT DISPLAY-
PD2: Port D2 / Timer 2 - channel 3[AFR1]
PD3: Port D3 / Timer 2 - channel 2/ADC external trigger
PD4: Port D4 / Timer 2 - channel 1/BEEP output
PD7: Port D7 / Top level interrupt / Timer 1 -channel 4 [AFR6]
*/
#define DISP_PORT     GPIOD
#define DISP_SDI_PIN  GPIO_PIN_2
#define DISP_nOE_PIN  GPIO_PIN_3
#define DISP_LE_PIN   GPIO_PIN_4
#define DISP_CLK_PIN  GPIO_PIN_7

#define DISP_SDI_1   (DISP_PORT->ODR |= DISP_SDI_PIN)
#define DISP_SDI_0   (DISP_PORT->ODR &= (u8)(~DISP_SDI_PIN))
#define DISP_nOE_1   (DISP_PORT->ODR |= DISP_nOE_PIN)
#define DISP_nOE_0   (DISP_PORT->ODR &= (u8)(~DISP_nOE_PIN))
#define DISP_LE_1    (DISP_PORT->ODR |= DISP_LE_PIN)
#define DISP_LE_0   (DISP_PORT->ODR &= (u8)(~DISP_LE_PIN))
#define DISP_CLK_1   (DISP_PORT->ODR |= DISP_CLK_PIN)
#define DISP_CLK_0   (DISP_PORT->ODR &= (u8)(~DISP_CLK_PIN))
#define DISP_nOE_STATE (DISP_PORT->IDR & DISP_nOE_PIN)

#endif