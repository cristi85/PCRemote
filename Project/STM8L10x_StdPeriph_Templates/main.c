/**
  ******************************************************************************
  * @file    Project/STM8L15x_StdPeriph_Template/main.c
  * @author  MCD Application Team
  * @version V1.6.0
  * @date    28-June-2013
  * @brief   Main program body
  ******************************************************************************
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
#include "board.h"
#include "config.h"
#include "delay.h"
#include "stm8l10x_it.h"

/** @addtogroup STM8L15x_StdPeriph_Template
  * @{
  */

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static bool FLAG_Battery_Low = FALSE;
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
extern u8 Btn_pressed;
/**
  * @brief  Main program.
  * @param  None
  * @retval None
  */
void main(void)
{
  disableInterrupts();
  Config();
  enableInterrupts();
  LED_OFF;
  //USART_SendData8('A');
    
  /* Infinite loop */
  while (1)
  {
    if(FLAG_new_rc5_frame)
    {
      LED_ON;
      FLAG_LEDtimeout = TRUE;
      if(RC5_frame.address == 0x0)
      {
        switch(RC5_frame.command)
        {
          case 0xc: // Power
          {
            USART_SendData8('A');
            break;
          }
          // ========= Media Player Commands ==========
          case 0x39: // CH+ Button - Fast Forward
          {
            USART_SendData8('B');
            break;
          }
          case 0x38: // CH- Button - Rewind
          {
            USART_SendData8('b');
            break;
          }
          case 0xf: // Play/Pause
          {
            USART_SendData8('C');
            break;
          }
          case 0x19: // Red button - Toggle fullscreen
          {
            USART_SendData8('D');
            break;
          }
          case 0x10: // Vol+ Button - Volume Increase
          {
            USART_SendData8('E');
            break;
          }
          case 0x11: // Vol- Button - Volume Decrease
          {
            USART_SendData8('e');
            break;
          }
          case 0x12: // Brightness+ Button - Brightness Increase
          {
            USART_SendData8('F');
            break;
          }
          case 0x13: // Brightness- Button - Brightness Decrease
          {
            USART_SendData8('f');
            break;
          }
          case 0x1d: // Contrast+ Button - Contrast Increase
          {
            USART_SendData8('G');
            break;
          }
          case 0x1c: // Contrast- Button - Contrast Decrease
          {
            USART_SendData8('g');
            break;
          }
          // ======== END Media Player Commands =========
          
          // ======== Winamp Commands =========
          case 0x2b: // Play Button - Play
          {
            USART_SendData8('H');
            break;
          }
          case 0xe: // Pause Button - Pause
          {
            USART_SendData8('h');
            break;
          }
          case 0x29: // Stop Button - Stop
          {
            USART_SendData8('I');
            break;
          }
          case 0xb: // Rewind Button - Rewind
          {
            USART_SendData8('j');
            break;
          }
          case 0xa: // Fast forward Button - Fast forward
          {
            USART_SendData8('J');
            break;
          }
          case 0x2a: // Next track Button - Next track
          {
            USART_SendData8('K');
            break;
          }
          case 0x2e: // Previous track Button - Previous track
          {
            USART_SendData8('k');
            break;
          }
          case 0xd: // Mute Button - Mute
          {
            USART_SendData8('L');
            break;
          }
          // ======== END Winamp Commands =========
          default: 
          {
            USART_SendData8('X');  // unassigned command
            break;
          }
        }
      }
      FLAG_new_rc5_frame = FALSE;
    }
  }
}

#ifdef  USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
