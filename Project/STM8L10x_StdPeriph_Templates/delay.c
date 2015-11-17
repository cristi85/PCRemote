/* Includes ------------------------------------------------------------------*/

#include "board.h"

static volatile u8 debug;

/**
  * @brief  delay for some time in ms unit
  * @param  n_ms is how many ms of time to delay
  * @retval None
  */
void delay_ms(u16 n_ms)
{
/* Init TIMER 4 */
  CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, ENABLE);

/* Init TIMER 4 prescaler: TIM4_Prescaler_1: 38KHz / 1 = 38KHz */
  TIM4->PSCR = 0;

/* LSI 38KHz --> Auto-Reload value: 38KHz / 1 = 38KHz, 38KHz / 1k = 38 */
  TIM4->ARR = 38;
  
/* Counter value: 4, to compensate the initialization of TIMER*/
    
  TIM4->CNTR = 4;  //value may have to be changed

/* clear update flag */
  TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);

/* Enable Counter */
  TIM4->CR1 |= TIM4_CR1_CEN;

  while(n_ms--)
  {
    while((TIM4->SR1 & TIM4_FLAG_Update) == 0);
    TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);
  }

/* Disable Counter */
  TIM4->CR1 &= (u8)(~TIM4_CR1_CEN);
  CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, DISABLE);
}

/**
  * @brief  delay for some time in 4us unit(not so accurate for small values for n_4us)
            Timer4 has to be configured with prescaler 8 (for 2MHz SYSCLK) and peripheral clock enabled before calling this function
            Timer4 will be incremented every 4us
            Delay range for this function is 4us to 1020us for n_4us of 1 to 255
  * @param n_26us is how many 26.31us of time to delay
  * @retval None
  */
void delay_tim4(u8 _delay)
{
  TIM4->CNTR = 3;
  TIM4->ARR = _delay;
  TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);  // clear update flag
  TIM4->CR1 |= TIM4_CR1_CEN;             // Enable Counter
  while((TIM4->SR1 & TIM4_FLAG_Update) == 0);
  TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);
  TIM4->CR1 &= (u8)(~TIM4_CR1_CEN);      // Disable Counter
}
