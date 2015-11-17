/**
  ******************************************************************************
  * @file     Project/STM8L10x_StdPeriph_Templates/stm8l10x_it.c
  * @author   MCD Application Team
  * @version  V1.2.1
  * @date     30-September-2014
  * @brief    This file contains all the interrupt routines.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; COPYRIGHT 2014 STMicroelectronics</center></h2>
  *
  * Licensed under MCD-ST Liberty SW License Agreement V2, (the "License");
  * You may not use this file except in compliance with the License.
  * You may obtain a copy of the License at:
  *
  *        http://www.st.com/software_license_agreement_liberty_v2
  *
  * Unless required by applicable law or agreed to in writing, software 
  * distributed under the License is distributed on an "AS IS" BASIS, 
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "stm8l10x_it.h"
#include "board.h"
/** @addtogroup STM8L10x_StdPeriph_Templates
  * @{
  */
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* IR RC5 code receive */
typedef enum 
{
  RC5_RCV_START     = 0,
  RC5_RCV_BITS      = 1
} RC5_RcvState_t;
static volatile RC5_RcvState_t RC5_rcvstate = RC5_RCV_START;
static volatile u8 RC5_rcvsubstate = 0;
RC5_frame_t RC5_frame;
u8  FLAG_new_rc5_frame = FALSE;
static u16 cap_rise, cap_fall;
static u8  FLAG_rise_edge = FALSE;
static u8  FLAG_fall_edge = FALSE;
static u8  FLAG_CC_Error = FALSE;
static u16 rc5_bittime = 0;
static u16 rc5_halfbittime = 0;
static volatile u8 test_cnt = 0;
static u16 rc5_offset = 0;
static u8  IRtimeoutcnt = 0;
static u8  LEDtimeoutcnt = 0;
u8 FLAG_LEDtimeout = FALSE;
static u8  rc5_currentbit = 0;
static u16 rc5_cap_offset = 0;
#define IR_TIMEOUT      (u8)25  /* 50ms timeout */
#define LED_TIMEOUT     (u8)20
#define IR_EDGES_JITTER (u8)100

static volatile u16 rcv_buff[50];
static volatile idx = 0;
static volatile u8 FLAG_markfirst = FALSE;
static volatile u8 first = 0;

static volatile test = 0;
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
/* Public functions ----------------------------------------------------------*/

u8 Btn_pressed = 0;

#ifdef _COSMIC_
/**
  * @brief  Dummy interrupt routine
  * @param  None
  * @retval None
*/
INTERRUPT_HANDLER(NonHandledInterrupt,0)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}
#endif

/**
  * @brief  Timer2 Capture/Compare Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM2_CAP_IRQHandler, 20)
{
  /* - cap_rise - timer value on rising edge 
     - cap_fall - timer value on falling edge
     - timer is reset on falling edge     */
  if(TIM2_GetITStatus(TIM2_IT_CC1) == SET)
  {
    cap_rise = TIM2_GetCapture1();
    FLAG_rise_edge = TRUE;
  }
  else FLAG_rise_edge = FALSE;
  if(TIM2_GetITStatus(TIM2_IT_CC2) == SET)
  {
    cap_fall = TIM2_GetCapture2();
    FLAG_fall_edge = TRUE;
  }
  else FLAG_fall_edge = FALSE;
  if(FLAG_rise_edge && FLAG_fall_edge)
  {
    FLAG_CC_Error = TRUE;
  }
  // capture logging
  /*if(!FLAG_markfirst)
  {
    FLAG_markfirst = TRUE;
    if(FLAG_rise_edge)      first = 1;
    else if(FLAG_fall_edge) first = 2;
  }
  if(FLAG_rise_edge) rcv_buff[idx++] = cap_rise;
  else rcv_buff[idx++] = cap_fall;*/
  // ---------------
  IRtimeoutcnt = 0;
  switch(RC5_rcvstate)
  {
    case RC5_RCV_START:
    {
      switch(RC5_rcvsubstate)
      {
        case 0:
        { // first IR falling edge, timer is reset
          RC5_frame.valid = 1;
          RC5_frame.togglebit = 0;
          RC5_frame.address = 0;
          RC5_frame.command = 0;
          rc5_currentbit = 0;
          RC5_rcvsubstate = 1;
          rc5_offset = 0;
          break;
        }
        case 1:
        {
          if(FLAG_fall_edge)
          {
            rc5_halfbittime = cap_rise;
            rc5_bittime = cap_fall;
            //rc5_oneandhalfbittime = rc5_bittime + rc5_halfbittime;
            //rc5_twobittime = rc5_bittime + rc5_bittime;
            RC5_rcvsubstate = 0;
            RC5_rcvstate = RC5_RCV_BITS;
          }
          break;
        }
        default: break;
      }
      break;
    }
    case RC5_RCV_BITS:
    {
      if(FLAG_rise_edge)
      {
        if(cap_rise+rc5_offset <= rc5_bittime+IR_EDGES_JITTER && cap_rise+rc5_offset >= rc5_bittime-IR_EDGES_JITTER)
        {
          //found "0" bit
          rc5_currentbit++;
          if(rc5_currentbit > 11) FLAG_new_rc5_frame = TRUE;
          if(rc5_offset > 0) rc5_offset = 0;
        }
        else if(cap_rise <= rc5_halfbittime+IR_EDGES_JITTER && cap_rise >= rc5_halfbittime-IR_EDGES_JITTER)
        {
          rc5_offset = cap_rise;
        }
        else RC5_frame.valid = 0;
      }
      else if(FLAG_fall_edge)
      {
        if(cap_fall-cap_rise+rc5_offset <= rc5_bittime+IR_EDGES_JITTER && cap_fall-cap_rise+rc5_offset >= rc5_bittime-IR_EDGES_JITTER)
        {
          //found "1" bit
          if     (rc5_currentbit == 0) RC5_frame.togglebit = 1;
          else if(rc5_currentbit <= 5) RC5_frame.address |= (u8)(1<<(5-rc5_currentbit));
          else RC5_frame.command |= (u8)(1<<(11-rc5_currentbit));
          rc5_currentbit++;
          if(rc5_currentbit > 11) FLAG_new_rc5_frame = TRUE;
          else {}
          if(rc5_offset > 0) rc5_offset = 0;
        }
        else if(cap_fall-cap_rise <= rc5_halfbittime+IR_EDGES_JITTER && cap_fall-cap_rise >= rc5_halfbittime-IR_EDGES_JITTER)
        {
          rc5_offset = cap_fall-cap_rise;
        }
        else RC5_frame.valid = 0;
      }
      break;
    }
    default: break;
  }
  
  TIM2_ClearITPendingBit(TIM2_IT_CC1);
  TIM2_ClearITPendingBit(TIM2_IT_CC2);
}

/**
  * @brief  Timer4 Update/Overflow Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 25)  /* every 2.048ms */
{
  if(TIM4_GetITStatus(TIM4_IT_Update) == SET)
  {
    /* CHECK IR SENSOR EDGES TIMEOUT */
    if(IRtimeoutcnt < 255) IRtimeoutcnt++;
    if(IRtimeoutcnt >= IR_TIMEOUT)
    {
      RC5_rcvstate = RC5_RCV_START;
      RC5_rcvsubstate = 0;
    }
    if(FLAG_LEDtimeout)
    {
      if(LEDtimeoutcnt < 255) LEDtimeoutcnt++;
      if(LEDtimeoutcnt >= LED_TIMEOUT)
      {
        LED_OFF;
        LEDtimeoutcnt = 0;
        FLAG_LEDtimeout = FALSE;
      }
    }
    TIM4_ClearITPendingBit(TIM4_IT_Update);
  }
}

/**
  * @brief  TRAP interrupt routine
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
  * @brief  FLASH Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(FLASH_IRQHandler,1)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  Auto Wake Up Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(AWU_IRQHandler,4)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PORTB Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTIB_IRQHandler, 6)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PORTD Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTID_IRQHandler, 7)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN0 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI0_IRQHandler, 8)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN1 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI1_IRQHandler, 9)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN2 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI2_IRQHandler, 10)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN3 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI3_IRQHandler, 11)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN4 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI4_IRQHandler, 12)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN5 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI5_IRQHandler, 13)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN6 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI6_IRQHandler, 14)

{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  External IT PIN7 Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI7_IRQHandler, 15)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  Comparator Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(COMP_IRQHandler, 18)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  Timer2 Update/Overflow/Trigger/Break Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM2_UPD_OVF_TRG_BRK_IRQHandler, 19)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */

}


/**
  * @brief  Timer3 Update/Overflow/Trigger/Break Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM3_UPD_OVF_TRG_BRK_IRQHandler, 21)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}
/**
  * @brief  Timer3 Capture/Compare Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TIM3_CAP_IRQHandler, 22)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  SPI Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(SPI_IRQHandler, 26)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}
/**
  * @brief  USART TX Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(USART_TX_IRQHandler, 27)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @brief  USART RX Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(USART_RX_IRQHandler, 28)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}


/**
  * @brief  I2C Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(I2C_IRQHandler, 29)
{
    /* In order to detect unexpected events during development,
       it is recommended to set a breakpoint on the following instruction.
    */
}

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

