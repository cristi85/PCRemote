#include "board.h"

void Config()
{
  //System clock at power up is HSI/8 = 16MHz/8 = 2MHz
  //CLK_MasterPrescalerConfig(CLK_MasterPrescaler_HSIDiv4);
  //CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_4);  //set HSI/4 = 4MHz SysClk to Core and Memory, minimum clock = 125KHz for CLK_SYSCLKDiv_128
  //PWR_PVDCmd(ENABLE);  //Power voltage detector and brownout Reset unit supply current 2,6uA
  //PWR_PVDLevelConfig(PWR_PVDLevel_2V26); //set Programmable voltage detector threshold to 2,26V
  //PWR_GetFlagStatus(PWR_FLAG_PVDOF);  //checks whether the specified PWR flag is set or not
  
  //Configure external interrupts - BTN1 and BTN2 presses
  //EXTI_SetPinSensitivity(EXTI_Pin_0 | EXTI_Pin_1, EXTI_Trigger_Falling_Low);
  //EXTI_SelectPort(EXTI_Port_B);
  //EXTI_SetHalfPortSelection(EXTI_HalfPort_B_MSB, ENABLE);
  
  // Timer 4 Configuration
  CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, ENABLE);
  TIM4_DeInit();
  TIM4_TimeBaseInit(TIM4_Prescaler_32, 125);  // 2.048ms timebase @ 2MHz System clock
  TIM4_ITConfig(TIM4_IT_Update, ENABLE);
  TIM4_Cmd(ENABLE);
  
  // Timer 2 Configuration
  CLK_PeripheralClockConfig(CLK_Peripheral_TIM2, ENABLE);
  TIM2_TimeBaseInit(TIM2_Prescaler_2, TIM2_CounterMode_Up, 0xFFFF);  // 1us timebase @ 2MHz system clock
  TIM2_ICInit/*TIM2_PWMIConfig*/(TIM2_Channel_1,
              TIM2_ICPolarity_Rising,
              TIM2_ICSelection_IndirectTI,
              TIM2_ICPSC_Div1,
              2);
  TIM2_ICInit/*TIM2_PWMIConfig*/(TIM2_Channel_2,
              TIM2_ICPolarity_Falling,
              TIM2_ICSelection_DirectTI,
              TIM2_ICPSC_Div1,
              2);
  TIM2_SelectInputTrigger(TIM2_TRGSelection_TI2FP2);
  TIM2_SelectSlaveMode(TIM2_SlaveMode_Reset);  // Reset timer on selected trigger signal
  TIM2_ITConfig(TIM2_IT_CC1, ENABLE);
  TIM2_ITConfig(TIM2_IT_CC2, ENABLE);
  TIM2_Cmd(ENABLE);
  
  /* USART Config */
  CLK_PeripheralClockConfig(CLK_Peripheral_USART, ENABLE);
  USART_DeInit();
  GPIO_Init(USART_PORT, USARTRX_PIN, GPIO_Mode_Out_PP_Low_Slow);
  GPIO_Init(USART_PORT, USARTTX_PIN, GPIO_Mode_In_PU_No_IT);
  USART_Init(19200, USART_WordLength_8D, USART_StopBits_1, USART_Parity_No, USART_Mode_Rx | USART_Mode_Tx);
  USART_ITConfig(USART_IT_RXNE, ENABLE);
  USART_Cmd(ENABLE);
  
  /* Output PP High - onboard LED to GND */
  GPIO_Init(LED_PORT, LED_PIN, GPIO_Mode_Out_PP_Low_Slow);

  GPIO_Init(IRIN_PORT, IRIN_PIN, GPIO_Mode_In_FL_No_IT); 
}