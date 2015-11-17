#include "board.h"

void Config()
{
  /* Fmaster = 16MHz */
  //CLK_SYSCLKConfig(CLK_PRESCALER_HSIDIV1);
  //CLK_HSECmd(ENABLE);
  //CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
  /* Automatic clock switching from HSI/8 to HSE */
  CLK_DeInit();
  CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
  CLK->ECKR |= 0x01;   /* HSEEN: High speed external crystal oscillator enable */
  while(!(CLK->ECKR & 0x02));  /* HSERDY: High speed external crystal oscillator ready, waint until HSE ready */
  CLK->SWCR |= 0x02;   /* set SWEN bit: Switch start/stop */
  CLK->SWR = 0xB4;     /* HSE selected as master clock source */
  while(CLK->SWCR & 0x01);   /* wait until switch busy: SWBSY = 1 */
  /* Alternative to try
     CLK_LSICmd(ENABLE);
     CLK_SYSCLKDivConfig(CLK_SYSCLKDiv_1);
     CLK_SYSCLKSourceConfig(CLK_SYSCLKSource_LSI);
     CLK_SYSCLKSourceSwitchCmd(ENABLE);
     while (((CLK->SWCR)& 0x01)==0x01); */
  
  /* Enable peripheral clock */
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);   /* 8bit: for implementing delays */
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);   /* 16bit: for capture of ultrasonic distance pulse width */
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE);   /* 16bit: PWM output for dimming of the display */
  //CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);    /* Enable I2C peripheral clock */
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);      /* Enable SPI peripheral clock */
  CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);    /* Enable UART1 peripheral clock */

  /* Sonar Pin init */  
  #ifdef ENABLE_SONAR
  GPIO_Init(SONAR_TRIG_PORT, SONAR_TRIG_PIN, GPIO_MODE_OUT_PP_LOW_FAST);      /* Sonar trigger pin - output push-pull */
  GPIO_Init(SONAR_TMR_TRIG_PORT, SONAR_TMR_TRIG_PIN, GPIO_MODE_IN_PU_NO_IT);  /* Sonar timer trigger start pin(rising) - input pullup */
  GPIO_Init(SONAR_TMR_CAP_PORT, SONAR_TMR_CAP_PIN, GPIO_MODE_IN_PU_NO_IT);    /* Sonar timer trigger capture pin(falling) - input pullup */
  #endif

  /* Output open drain low - onboard LED */
  GPIO_Init(LED_PORT, LED_PIN, GPIO_MODE_OUT_OD_HIZ_SLOW);

  /* Input pull up no IT - onboard Button */
  //GPIO_Init(BTN_PORT, BTN_PIN, GPIO_MODE_IN_PU_NO_IT);
  
 /* Configure External interrupts KL15 input */
  /* TODO: ext sensitivity can be changed when I1 and I0 in the CCR register are both set to 1 - Disable interrupt*/
  //EXTI_DeInit();
  //EXTI_SetExtIntSensitivity(EXTI_PORT_GPIOB, EXTI_SENSITIVITY_RISE_FALL);
  
  /* Input pull up IT - KL15 input */
  GPIO_Init(KL15_PORT, KL15_PIN, GPIO_MODE_IN_PU_NO_IT);

  /* output open drain high - 1 Wire bus - released */
  GPIO_Init(ONEWIREBUS_PORT, ONEWIREBUS_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
  
  /* Input with weak pull-up - RF receive pin*/
  GPIO_Init(RFRCV_PORT, RFRCV_PIN, GPIO_MODE_IN_PU_NO_IT);         /* RF receive timer trigger reset and capture pin(falling) - input pullup */

  GPIO_Init(RFSEND_PORT, RFSEND_PIN, GPIO_MODE_OUT_PP_LOW_FAST);   /* RF send for testing */
  
  /* Hardware SPI pin init */
  GPIO_Init(GPIOC, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);   //SCK
  GPIO_Init(GPIOC, GPIO_PIN_6, GPIO_MODE_OUT_PP_LOW_FAST);   //MOSI
  GPIO_Init(GPIOC, GPIO_PIN_7, GPIO_MODE_IN_PU_NO_IT);       //MISO
  GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_OUT_PP_HIGH_FAST);  //CS

  /* Display Interface */
  GPIO_Init(DISP_PORT, DISP_SDI_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
  GPIO_Init(DISP_PORT, DISP_nOE_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
  GPIO_Init(DISP_PORT, DISP_LE_PIN, GPIO_MODE_OUT_PP_LOW_FAST);    
  GPIO_Init(DISP_PORT, DISP_CLK_PIN, GPIO_MODE_OUT_PP_LOW_FAST);

  /* UART1 Configuration */
  UART1_DeInit();
  GPIO_Init(USART_PORT, USART_TX_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
  GPIO_Init(USART_PORT, USART_RX_PIN, GPIO_MODE_IN_PU_NO_IT);
  UART1_Init(115200, UART1_WORDLENGTH_8D, UART1_STOPBITS_1, UART1_PARITY_NO, 
                UART1_SYNCMODE_CLOCK_DISABLE, UART1_MODE_TXRX_ENABLE);
  UART1_ITConfig(UART1_IT_RXNE, ENABLE);
  UART1_Cmd(ENABLE);

  /* Software I2C Pin Configuration */
  GPIO_Init(SOFTI2C_PORT, SOFTI2C_SCL_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
  GPIO_Init(SOFTI2C_PORT, SOFTI2C_SDA_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);


  /* TIMER4 configuration - OS_Timer() and Power fail external interrupt debouncing*/
  TIM4_DeInit();
  TIM4_TimeBaseInit(TIM4_PRESCALER_128, 250);                 /* 2MS overflow interval - 500Hz*/
  TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
  TIM4_ClearITPendingBit(TIM4_IT_UPDATE);
  TIM4_Cmd(ENABLE);

  
  /* TIMER1 configuration  - RF receive bit timing
     Timer configured in Trigger standard mode
     Timer is started by falling edge of input, 
     on the following falling edge of input we make a capture
  */
  TIM1_DeInit();
  TIM1_TimeBaseInit(16, TIM1_COUNTERMODE_UP, 4000, 0x00);    // 4ms overflow period, 1us resolution                                                        
  TIM1->SMCR |= 0x04;                                        // Slave mode control register
                                                             // Clock/trigger/slave mode selection, SMS = 100
                                                             // 100: Reset mode - Rising edge of the selected trigger signal (TRGI) re-initializes the counter and
                                                             // generates an update of the registers
                                                             // 110: Trigger standard mode - The counter starts at a rising edge of the trigger TRGI (but, it is not
                                                             // reset). Only the start of the counter is controlled.
                                                             
  TIM1->SMCR |= 0x60;                                        // Slave mode control register, Trigger selection, TS = 110
                                                             // 101: Filtered timer input 1 (TI1FP1)
                                                             // 110: Filtered timer input 2 (TI2FP2)
                                                             
  TIM1->CCMR2 |= 0x01;                                       // Capture/compare mode register 2, CC2S[1:0]: Capture/compare 2 selection, CC2S = 01
                                                             // 00: CC2 channel is configured as output
                                                             // 01: CC2 channel is configured as input, IC2 is mapped on TI2FP2
                                                             // 10: CC2 channel is configured as input, IC2 is mapped on TI1FP2
  
  TIM1->CCER1 |= 0x10;                                       // Capture/compare enable register 1, CC2E = 1
  /*TIM1->CCER1 &= (u8)(~(0x10));*/                          // Capture/compare enable register 1, CC2E = 0
                                                             // CC2E: Capture/compare 1 output enable, CC1 channel is configured as input: This bit determines 
                                                             // if a capture of the counter value can be made in the input capture/compare register 2 (TIM1_CCR2) or not.
                                                             // 0: Capture disabled
                                                             // 1: Capture enabled
                                                             
  TIM1->CCER1 |= (u8)(0x20);                                 // Capture/compare enable register 1, CC2P = 1
                                                             // CC2P: Capture/compare 2 output polarity, when CC1 channel configured as input for trigger function: 1: 
                                                             // Trigger on a low level or falling edge of TI1F
                                                             
  /*TIM1->CCMR3 |= 0x01;*/                                   // CC3S[1:0]: Capture/compare 3 selection = 01: CC3 channel is configured as input, IC3 is mapped on TI3FP3
  
  /*TIM1->CCER2 |= 0x01;*/                                   // CC3E = 1, CC3E: Capture/compare 3 output enable, CC3 channel is configured as input: This bit determines 
                                                             // if a capture of the counter value can be made in the input capture/compare register 3 (TIM1_CCR3) or not.
                                                             
  /*TIM1->CCER2 |= 0x02;*/                                   // CC3P = 1, CC3P: Capture/compare 3 output polarity, CC3 channel configured as input for trigger function: 1: Trigger 
                                                             // on a low level or falling edge of TI1F
                                                             
  //investigate if we can use a single pin for reset trigger and capture
  TIM1_ITConfig(TIM1_IT_CC2, ENABLE);                        // interrupt on timer capture compare 3 - falling edge of pulse
  TIM1_ClearITPendingBit(TIM1_FLAG_CC2);
  TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
  TIM1_Cmd(ENABLE);
  
  /* TIMER2 configuration - PWM output for display dimming - output on PD3: DISP_PORT->DISP_nOE_PIN */
  TIM2_DeInit();
  //TIM2_TimeBaseInit(TIM2_PRESCALER_1, 10000);    // 0.625MS period - 1,6Khz
  //TIM2_OC2Init(TIM2_OCMODE_PWM1, TIM2_OUTPUTSTATE_ENABLE, 5000, TIM2_OCPOLARITY_HIGH);  // set duty to 50% and output to TIM2 OC2 (PD3)
  //TIM2_OC2PreloadConfig(ENABLE);
  //TIM2_Cmd(ENABLE);
}