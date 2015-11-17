/**
  ******************************************************************************
  * @file     stm8s_it.c
  * @author   MCD Application Team
  * @version  V2.1.0
  * @date     18-November-2011
  * @brief    Main Interrupt Service Routines.
  *           This file provides template for all peripherals interrupt service
  *           routine.
  ******************************************************************************
  * @attention
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2011 STMicroelectronics</center></h2>
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "stm8s_it.h"
#include "board.h"
#include "ds18b20.h"
#include "osa.h"
#include "rf_send.h"
#include "display.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/

//#define ULTRASONIC_WATCHDOG
//#define ENABLE_SONAR
//#define ENABLE_RF_PULSE_REC

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

#define RF_RCVSTATE_WAITSTART   (u8)0
#define RF_RCVSTATE_REC8BITS    (u8)1
#define RF_RCVSTATE_WAIT        (u8)2
#define RF_START_WIDTH          (u16)1000
#define RF_MIDDLEBIT            (u16)625
#define KL_15_SYNC_CYCLES       (u8)3
#define DIG_IN_DEB_TIME         (u8)15     /* 30ms digital input debounce time */
#define BTN_DEPRESSED           (u8)0
#define BTN_PRESSED             (u8)1
#define KL_15_OFF_TIME          (u16)2000 /* after 4000ms of KL15 off, the system will be put in low power RF listening mode */
#define KL_15_ON_TIME           (u16)1000 /* after 2000ms of KL15 on, the system will be put in normal operational mode */
#define KL_15_SYNC_TIME         (u16)2500 /* 5000ms, timer for 3 KL15 power-on cycles for entering Key Sync mode */

volatile RFmsg_t RcvRFmsg;
static volatile RFmsg_t RcvRFmsg_sdw;
volatile _Bool RF_bytes_ready = FALSE;
volatile u16 RF_PulsePeriod = 0;
volatile u16 KL15_timer = 0;
volatile _Bool KL15_timer_started = FALSE;
volatile _Bool SYSTEM_ON = FALSE;
volatile u8 KL15_DEB_STATE = BTN_DEPRESSED;

#ifdef ENABLE_RF_PULSE_REC
  u16 temp2[10];
  u8 idx_temp2 = 0;
#endif

#ifdef ENABLE_SONAR
  #define CAPTURE_ERR_CNT_THRS 10
  #define SENSOR_ALIVE_THRS 1000    /* 1000*2ms = 2000ms */
  static volatile u16 CAPTURE_delta = 0;
  static u8 CAPTURE_status = 0;
  static u8 CAPTURE_ovf_cnt = 0;
  static u8 CAPTURE_no_trig_cnt = 0;
  static u8 CAPTURE_no_err_cnt = 0;
  static u16 sensor_alive_cnt = 0;
  static u8 tmpccr3h;
  static u8 tmpccr3l;
  static volatile _Bool EVENT_cap_new_mes = FALSE;
  static volatile _Bool ERROR_cap_ovf = FALSE;
  static volatile _Bool ERROR_cap_no_trig = FALSE;
  static volatile _Bool ERROR_cap_sens_not_resp = FALSE;
#endif


static u8 Power_fail_tmr = 0;
static u8 KL_15_on_cycles = 0;
static u8 kl15_0_cnt = 0;
static u8 kl15_1_cnt = 0;
static u16 kl15_off_cnt = 0;
static u16 kl15_on_cnt = 0;
static volatile _Bool POWER_timer_en = FALSE;


/* Public variables */
volatile _Bool FLAG_RF_START_REC = FALSE;
volatile _Bool FLAG_IT_RTC_SET_DATE_TIME = FALSE;
volatile _Bool FLAG_IT_FLSH_READ_STORED_DATA = FALSE;
volatile _Bool FLAG_IT_FLSH_GET_OCCUPIED_SPC = FALSE;
volatile _Bool FLAG_IT_FLSH_GET_HEADER_SIZE = FALSE;
volatile _Bool FLAG_IT_FLSH_READ_HEADER = FALSE;
volatile _Bool FLAG_KL15_TIMED_NUM_PWRON = FALSE;
volatile _Bool FLAG_SYSTEM_ON = FALSE;
volatile _Bool FLAG_KL15_ON = FALSE;
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
/* Public functions ----------------------------------------------------------*/

/*
  CAPTURE_status = 0   init value timer 1 capture ISR not reached
  CAPTURE_status = 1   CC3 interrupt occured, time between rising and falling edge greater than 65.536ms
  CAPTURE_status = 2   CC3 interrupt occured, no rising edge trigger occured previously
  CAPTURE_status = 3   CC3 interrupt occured, capture ok (no timer overflow, rising edge trigger occured), EVENT_cap_new_mes = FALSE
  CAPTURE_status = 4   CC3 interrupt occured, capture ok (no timer overflow, rising edge trigger occured), EVENT_cap_new_mes = TRUE
  CAPTURE_status = 5   timer 1 capture occured, CC3 interrupt capture not occured
*/
extern OST_SMSG smsg_rx_rec;
extern OST_FLAG8 F_RFbytesReady;
extern void Power_FailDetected(void);
extern volatile _Bool FLAG_RF_SyncKey;
extern OST_TASK_POINTER tp_TASK_1000mS;
extern OST_TASK_POINTER tp_TASK_SystemResumeNormal;

#ifdef _COSMIC_
/**
  * @brief Dummy Interrupt routine
  * @par Parameters:
  * None
  * @retval
  * None
*/
INTERRUPT_HANDLER(NonHandledInterrupt, 25)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*_COSMIC_*/

/**
  * @brief TRAP Interrupt routine
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER_TRAP(TRAP_IRQHandler)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Top Level Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TLI_IRQHandler, 0)

{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Auto Wake Up Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(AWU_IRQHandler, 1)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Clock Controller Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(CLK_IRQHandler, 2)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief External Interrupt PORTA Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTA_IRQHandler, 3)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
  if(!POWER_timer_en) 
  {
    Power_FailDetected();
    POWER_timer_en = TRUE;
  }
}

/**
  * @brief External Interrupt PORTB Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTB_IRQHandler, 4)
{
  
}

/**
  * @brief External Interrupt PORTC Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTC_IRQHandler, 5)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief External Interrupt PORTD Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTD_IRQHandler, 6)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief External Interrupt PORTE Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTE_IRQHandler, 7)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

#ifdef STM8S903
/**
  * @brief External Interrupt PORTF Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTF_IRQHandler, 8)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S903*/

#if defined (STM8S208) || defined (STM8AF52Ax)
/**
  * @brief CAN RX Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(CAN_RX_IRQHandler, 8)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief CAN TX Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(CAN_TX_IRQHandler, 9)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S208 || STM8AF52Ax */

/**
  * @brief SPI Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(SPI_IRQHandler, 10)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Timer1 Update/Overflow/Trigger/Break Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM1_UPD_OVF_TRG_BRK_IRQHandler, 11)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
  //while(1);
  TIM1_ClearITPendingBit(TIM1_IT_UPDATE);
}

/**
  * @brief Timer1 Capture/Compare Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM1_CAP_COM_IRQHandler, 12)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
  static u8 RF_rcvMsgState;
  static u8 RF_data;
  static u8 RF_bits;
  static u8 RF_bytes;
  static u8 CHKSUM;
  
  static u8 _highB, _lowB;

  disableInterrupts();
  
  if(TIM1->SR1 & TIM1_IT_CC2)
  {
    // if a capture was made from capture register 3
    _highB = TIM1->CCR2H;
    _lowB = TIM1->CCR2L;
    RF_PulsePeriod = (u16)(_lowB);
    RF_PulsePeriod |= (u16)((u16)_highB << 8);

    TIM1->SR1 = (u8)(~(u8)TIM1_IT_CC2);        // clear TIM1 CC3 interrupt flag 
  }
#ifdef ENABLE_RF_PULSE_REC
  if(FLAG_RF_START_REC)
  {
    if(idx_temp2 < 10)
    {
      temp2[idx_temp2++] = RF_PulsePeriod;
    }
    else
    {
      idx_temp2 = 0;
      FLAG_RF_START_REC = FALSE;
    }
  }
#endif

  switch(RF_rcvMsgState)
  {
    case RF_RCVSTATE_WAITSTART: 
         {
           // wait for a start pulse
           if(RF_PulsePeriod > (u16)1150 && RF_PulsePeriod < (u16)1350)
           {
             // exit if start pulse
             RF_bits = 0;
             RF_bytes = 0;
             RF_rcvMsgState = RF_RCVSTATE_REC8BITS;
           }
           break;
         }
    case RF_RCVSTATE_REC8BITS:
         {
           // now we had a start pulse, record 8 bits
           if(RF_PulsePeriod >= RF_START_WIDTH) 
           {
             // unexpected start pulse, reset data recording
             RF_bits = 0;
             RF_bytes = 0;
           }
           else
           {
             if(RF_PulsePeriod >= RF_MIDDLEBIT)   // 0 bit = 500uS, 1 bit = 750uS
             {
               // record 1 bit, else a 0 will be shifted and therefore recorded
               RF_data |= 0x01;
             }
             RF_bits++;
             if(RF_bits < 8) RF_data <<= 1;
             if(RF_bits == 8)
             {
               // we received 8 good bits
               u8 i;
               
               RcvRFmsg_sdw.RFmsgarray[RF_bytes++] = RF_data;
               if(RF_bytes == RFSEND_DATALEN) 
               {
                 if(!OS_Flag_Check_On_I(F_RFbytesReady, 0x01))  // if flag is reset (old RF data was processed by software)
                 {
                   CHKSUM = 0;
                   for(i=0;i<RFSEND_DATALEN-1;i++)
                   {
                     RcvRFmsg.RFmsgarray[i] = RcvRFmsg_sdw.RFmsgarray[i];   // copy received data from shadow buffer to public one go wait for a start pulse
                     CHKSUM += RcvRFmsg.RFmsgarray[i];
                   }
                   CHKSUM = (u8)(~CHKSUM);
                   
                   RF_rcvMsgState = RF_RCVSTATE_WAITSTART;
                   if((RcvRFmsg.RFmsgmember.RFremoteID == RFREMOTEID) && (CHKSUM == RcvRFmsg_sdw.RFmsgmember.RFmsgCHKSUM))  //if code matches RF remote code and message checksum is ok
                   {
                     OS_Flag_Set_I(F_RFbytesReady, 0x01);  // set new RF data available flag
                   }
                 }
                 else 
                 {
                   // software did not process old RF data
                   RF_rcvMsgState = RF_RCVSTATE_WAIT;   // go to wait state until SW reads RF_rxdata and resets RF_bytes_ready flag
                 }
                 RF_bytes = 0;  // reset bytes index
                 }
                 RF_data = 0;
                 RF_bits = 0;
               }
             }
           break;
         }
    case RF_RCVSTATE_WAIT:
         {
           if(!OS_Flag_Check_On_I(F_RFbytesReady, 0x01))  // if flag is reset (old RF data was processed by software)
           {
             u8 i;
             CHKSUM = 0;
             for(i=0;i<RFSEND_DATALEN-1;i++)
             {
               RcvRFmsg.RFmsgarray[i] = RcvRFmsg_sdw.RFmsgarray[i];   // copy received data from shadow buffer to public one go wait for a start pulse
               CHKSUM += RcvRFmsg.RFmsgarray[i];
             }
             CHKSUM = (u8)(~CHKSUM);
             
             RF_rcvMsgState = RF_RCVSTATE_WAITSTART;   //go wait for a start pulse
             if((RcvRFmsg.RFmsgmember.RFremoteID == RFREMOTEID) && (CHKSUM == RcvRFmsg.RFmsgmember.RFmsgCHKSUM))  //if code matches RF remote code and message checksum is ok
             {
               OS_Flag_Set_I(F_RFbytesReady, 0x01);  // set new RF data available flag
             }
           }
           break;
         }
  }
  
  #ifdef ENABLE_SONAR
  CAPTURE_status = 5;
  if(TIM1->SR1 & TIM1_IT_CC3)
  {    
    TIM1->CR1 &= (u8)(~(0x01));      // after measurement stop the timer, to be restarted by sonar rising edge 
    TIM1->CNTRH = 0x00;        // reset timer 
    TIM1->CNTRL = 0x00; 
    sensor_alive_cnt = 0;      // reset ultrasonic sensor alive watchdog 
    ERROR_cap_sens_not_resp = FALSE;
    CAPTURE_status = 4;	
    if(!(TIM1->SR1 & TIM1_IT_TRIGGER))  
    {
      // if no trigger occured previously
      CAPTURE_status = 2;
      if(CAPTURE_no_trig_cnt < (u8)255) ++CAPTURE_no_trig_cnt; 
      if(CAPTURE_no_trig_cnt >= (u8)CAPTURE_ERR_CNT_THRS)
      {
        CAPTURE_no_err_cnt = 0;
        ERROR_cap_no_trig = TRUE;
      }
    }
    else if(TIM1->SR1 & TIM1_IT_UPDATE)
    {
      // if we have timer overflow since last trigger - echo out of specification of sonar 
      CAPTURE_status = 1;
      if(CAPTURE_ovf_cnt < (u8)255) ++CAPTURE_ovf_cnt;
      if(CAPTURE_ovf_cnt >= (u8)CAPTURE_ERR_CNT_THRS)
      {
        CAPTURE_no_err_cnt = 0;
        ERROR_cap_ovf = TRUE;
      }
    }
    else if(EVENT_cap_new_mes == FALSE)
    {
      tmpccr3h = TIM1->CCR3H;
      tmpccr3l = TIM1->CCR3L;
      CAPTURE_delta = (u16)(tmpccr3l);
      CAPTURE_delta |= (u16)((u16)tmpccr3h << 8);
      EVENT_cap_new_mes = TRUE;    // new distance measurement value 
      CAPTURE_status = 3;
    }
    if(CAPTURE_no_err_cnt < (u8)255)  ++CAPTURE_no_err_cnt;
    if(CAPTURE_no_err_cnt >= (u8)CAPTURE_ERR_CNT_THRS) 
    {
      CAPTURE_ovf_cnt = 0;
      CAPTURE_no_trig_cnt = 0;
      ERROR_cap_ovf = FALSE;
      ERROR_cap_no_trig = FALSE;
    }
    TIM1->SR1 = (u8)(~(u8)TIM1_IT_UPDATE);     // clear TIM1 UPDATE interrupt flag 
    TIM1->SR1 = (u8)(~(u8)TIM1_IT_CC3);        // clear TIM1 CC3 interrupt flag 
    TIM1->SR1 = (u8)(~(u8)TIM1_IT_TRIGGER);    // clear TIM1 TRIGGER interrupt flag 
  }
  #endif
  enableInterrupts();
}

#ifdef STM8S903
/**
  * @brief Timer5 Update/Overflow/Break/Trigger Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM5_UPD_OVF_BRK_TRG_IRQHandler, 13)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Timer5 Capture/Compare Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM5_CAP_COM_IRQHandler, 14)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

#else /*STM8S208, STM8S207, STM8S105 or STM8S103 or STM8AF62Ax or STM8AF52Ax or STM8AF626x */
/**
* @brief Timer2 Update/Overflow/Break Interrupt routine.
* @param  None
* @retval None
*/
INTERRUPT_HANDLER(TIM2_UPD_OVF_BRK_IRQHandler, 13)
{
  /* In order to detect unexpected events during development,
  it is recommended to set a breakpoint on the following instruction.
  */
}

/**
* @brief Timer2 Capture/Compare Interrupt routine.
* @param  None
* @retval None
*/
INTERRUPT_HANDLER(TIM2_CAP_COM_IRQHandler, 14)
{
  /* In order to detect unexpected events during development,
  it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S903*/

#if defined (STM8S208) || defined(STM8S207) || defined(STM8S007) || defined(STM8S105) || \
    defined(STM8S005) ||  defined (STM8AF62Ax) || defined (STM8AF52Ax) || defined (STM8AF626x)
/**
  * @brief Timer3 Update/Overflow/Break Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM3_UPD_OVF_BRK_IRQHandler, 15)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief Timer3 Capture/Compare Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM3_CAP_COM_IRQHandler, 16)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S208, STM8S207 or STM8S105 or STM8AF62Ax or STM8AF52Ax or STM8AF626x */

#if defined (STM8S208) || defined(STM8S207) || defined(STM8S007) || defined(STM8S103) || \
    defined(STM8S003) ||  defined (STM8AF62Ax) || defined (STM8AF52Ax) || defined (STM8S903)
/**
  * @brief UART1 TX Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(UART1_TX_IRQHandler, 17)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief UART1 RX Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(UART1_RX_IRQHandler, 18)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
  volatile u8 rx_data = (u8)UART1->DR;
  /*
  RC commands:
  0x11 - RTC:  Set time and date             FLAG_IT_RTC_SET_DATE_TIME
  0x12 - FLASH: Read Data to UART            FLAG_IT_FLSH_READ_STORED_DATA
  0x13 - FLASH: Get occupied space to UART   FLAG_IT_FLSH_GET_OCCUPIED_SPC
  0x14 - FLASH: Get header size to UART      FLAG_IT_FLSH_GET_HEADER_SIZE
  0x15 - FLASH: Read header to UART          FLAG_IT_FLSH_READ_HEADER
  */
  OS_Smsg_Send_I(smsg_rx_rec, (OST_SMSG)rx_data);

  //UART1_ClearITPendingBit(UART1_IT_RXNE);
}
#endif /*STM8S208 or STM8S207 or STM8S103 or STM8S903 or STM8AF62Ax or STM8AF52Ax */

/**
  * @brief I2C Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(I2C_IRQHandler, 19)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

#if defined(STM8S105) || defined(STM8S005) ||  defined (STM8AF626x)
/**
  * @brief UART2 TX interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(UART2_TX_IRQHandler, 20)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief UART2 RX interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(UART2_RX_IRQHandler, 21)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /* STM8S105 or STM8AF626x */

#if defined(STM8S207) || defined(STM8S007) || defined(STM8S208) || defined (STM8AF52Ax) || defined (STM8AF62Ax)
/**
  * @brief UART3 TX interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(UART3_TX_IRQHandler, 20)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @brief UART3 RX interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(UART3_RX_IRQHandler, 21)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S208 or STM8S207 or STM8AF52Ax or STM8AF62Ax */

#if defined(STM8S207) || defined(STM8S007) || defined(STM8S208) || defined (STM8AF52Ax) || defined (STM8AF62Ax)
/**
  * @brief ADC2 interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(ADC2_IRQHandler, 22)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#else /*STM8S105, STM8S103 or STM8S903 or STM8AF626x */
/**
* @brief ADC1 interrupt routine.
* @par Parameters:
* None
* @retval
* None
*/
INTERRUPT_HANDLER(ADC1_IRQHandler, 22)
{
  /* In order to detect unexpected events during development,
  it is recommended to set a breakpoint on the following instruction.
  */
}
#endif /*STM8S208 or STM8S207 or STM8AF52Ax or STM8AF62Ax */

#ifdef STM8S903
/**
  * @brief Timer6 Update/Overflow/Trigger Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM6_UPD_OVF_TRG_IRQHandler, 23)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}
#else /*STM8S208, STM8S207, STM8S105 or STM8S103 or STM8AF52Ax or STM8AF62Ax or STM8AF626x */
/**
* @brief Timer4 Update/Overflow Interrupt routine.
* @param  None
* @retval None
*/
INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)     /* once every 2MS */
{
  /* In order to detect unexpected events during development,
  it is recommended to set a breakpoint on the following instruction.
  */
  /* Power fail external interrupt debouncing */
  if(POWER_timer_en)
  {
    if(Power_fail_tmr < 255) Power_fail_tmr++;
    if(Power_fail_tmr >= 10) 
    {
      Power_fail_tmr = 0;
      POWER_timer_en = FALSE;
	  //reset micro
      WWDG_SWReset();
    }
  }
  #ifdef ULTRASONIC_WATCHDOG
  // Ultrasonic sensor alive watchdog 
  if(sensor_alive_cnt < 65535)  sensor_alive_cnt++;   // to be reset in sensor ISR 
  if(sensor_alive_cnt >= SENSOR_ALIVE_THRS)
  {
    ERROR_cap_sens_not_resp = TRUE;
  }
  #endif
  /*----------------------------------*/
  //Cyclic_tick();
  //----------DEBOUNCE INPUTS--------------------
  /* Debounce KL15 input */
  if(KL15_STATE)
  {
    if(kl15_0_cnt < U8_MAX) kl15_0_cnt++;
    kl15_1_cnt = 0;
    if(kl15_0_cnt >= DIG_IN_DEB_TIME)
    {
      KL15_DEB_STATE = BTN_PRESSED;
    }
  }
  else
  {
    if(kl15_1_cnt < U8_MAX) kl15_1_cnt++;
    kl15_0_cnt = 0;
    if(kl15_1_cnt >= DIG_IN_DEB_TIME)
    {
      KL15_DEB_STATE = BTN_DEPRESSED;
    }
  }
  //---------------------------------------------
  if(KL15_DEB_STATE)
  {
    kl15_off_cnt = 0;
    if(kl15_on_cnt < U16_MAX) kl15_on_cnt++;
    // Rising edge on KL15
    if(!FLAG_KL15_TIMED_NUM_PWRON)
    {
      FLAG_KL15_TIMED_NUM_PWRON = TRUE;
      KL_15_on_cycles++;
      FLAG_KL15_ON = TRUE;
      // Start timer (5s)
      KL15_timer_started = TRUE;
      if(!SYSTEM_ON)
      {
        // Put system into normal operational mode
        SYSTEM_ON = TRUE;
        LED_ON;
      }
    }
    else
    {
      if(kl15_on_cnt >= KL_15_ON_TIME)
      {
        if(!SYSTEM_ON)
        {
          // Put system into normal operational mode
          SYSTEM_ON = TRUE;
          LED_ON;
        }
      }
      if(!FLAG_KL15_ON) 
      {
        KL_15_on_cycles++;
        FLAG_KL15_ON = TRUE;
      }
      if(KL_15_on_cycles == KL_15_SYNC_CYCLES && (KL15_timer < KL_15_SYNC_TIME))
      {
        // trigger sync procedure
        KL15_timer_started = FALSE;
        KL_15_on_cycles = 0;
        KL15_timer = 0;
        /*FLAG_RF_SyncKey = TRUE;
        OS_Task_Pause(tp_TASK_1000mS);
        OS_Task_Continue(tp_TASK_SystemResumeNormal);  // start timeout task
        Display_SetScreen(0, "5   ", NOCOMMA);
        Display_SetScreen32(1, 0);
        Display_Cyclic();*/
      }
    }
  }
  else
  {
    // Falling edge on KL15
    //start power off counter, after this, power off system
    kl15_on_cnt = 0;
    FLAG_KL15_ON = FALSE;
    if(kl15_off_cnt < U16_MAX) kl15_off_cnt++;
    
    if(FLAG_KL15_TIMED_NUM_PWRON )
    {
      if(KL15_timer >= KL_15_SYNC_TIME)
      {
        FLAG_KL15_TIMED_NUM_PWRON = FALSE;
      }
    }
    else
    {
      KL_15_on_cycles = 0;
      //if(kl15_off_cnt >= KL_15_OFF_TIME /*|| KL15_timer > KL_15_SYNC_TIME*/)
      //{
        if(SYSTEM_ON)
        {
          //Put system into low power RF listening mode
          SYSTEM_ON = FALSE;
          LED_OFF;
        }
      //}
    }
  }
  
  if(KL15_timer_started)
  {
    if(KL15_timer < U16_MAX)
    {
      KL15_timer++;
    }
    else
    {
      KL15_timer_started = FALSE;
      FLAG_KL15_TIMED_NUM_PWRON = FALSE;
    }
  }
  
  OS_Timer();
  TIM4_ClearITPendingBit(TIM4_IT_UPDATE);
}
#endif /*STM8S903*/

/**
  * @brief Eeprom EEC Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EEPROM_EEC_IRQHandler, 24)
{
  /* In order to detect unexpected events during development,
     it is recommended to set a breakpoint on the following instruction.
  */
}

/**
  * @}
  */

/******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE****/