   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.23 - 17 Sep 2014
   3                     ; Generator (Limited) V4.3.13 - 22 Oct 2014
   4                     ; Optimizer V4.3.11 - 22 Oct 2014
  65                     ; 3 void Config()
  65                     ; 4 {
  67                     .text:	section	.text,new
  68  0000               _Config:
  72                     ; 18   CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, ENABLE);
  74  0000 ae0401        	ldw	x,#1025
  75  0003 cd0000        	call	_CLK_PeripheralClockConfig
  77                     ; 19   TIM4_DeInit();
  79  0006 cd0000        	call	_TIM4_DeInit
  81                     ; 20   TIM4_TimeBaseInit(TIM4_Prescaler_32, 125);  // 2.048ms timebase @ 2MHz System clock
  83  0009 ae057d        	ldw	x,#1405
  84  000c cd0000        	call	_TIM4_TimeBaseInit
  86                     ; 21   TIM4_ITConfig(TIM4_IT_Update, ENABLE);
  88  000f ae0101        	ldw	x,#257
  89  0012 cd0000        	call	_TIM4_ITConfig
  91                     ; 22   TIM4_Cmd(ENABLE);
  93  0015 a601          	ld	a,#1
  94  0017 cd0000        	call	_TIM4_Cmd
  96                     ; 25   CLK_PeripheralClockConfig(CLK_Peripheral_TIM2, ENABLE);
  98  001a ae0101        	ldw	x,#257
  99  001d cd0000        	call	_CLK_PeripheralClockConfig
 101                     ; 26   TIM2_TimeBaseInit(TIM2_Prescaler_2, TIM2_CounterMode_Up, 0xFFFF);  // 1us timebase @ 2MHz system clock
 103  0020 aeffff        	ldw	x,#65535
 104  0023 89            	pushw	x
 105  0024 ae0100        	ldw	x,#256
 106  0027 cd0000        	call	_TIM2_TimeBaseInit
 108  002a 85            	popw	x
 109                     ; 27   TIM2_ICInit/*TIM2_PWMIConfig*/(TIM2_Channel_1,
 109                     ; 28               TIM2_ICPolarity_Rising,
 109                     ; 29               TIM2_ICSelection_IndirectTI,
 109                     ; 30               TIM2_ICPSC_Div1,
 109                     ; 31               2);
 111  002b 4b02          	push	#2
 112  002d 4b00          	push	#0
 113  002f 4b02          	push	#2
 114  0031 5f            	clrw	x
 115  0032 cd0000        	call	_TIM2_ICInit
 117  0035 5b03          	addw	sp,#3
 118                     ; 32   TIM2_ICInit/*TIM2_PWMIConfig*/(TIM2_Channel_2,
 118                     ; 33               TIM2_ICPolarity_Falling,
 118                     ; 34               TIM2_ICSelection_DirectTI,
 118                     ; 35               TIM2_ICPSC_Div1,
 118                     ; 36               2);
 120  0037 4b02          	push	#2
 121  0039 4b00          	push	#0
 122  003b 4b01          	push	#1
 123  003d ae0101        	ldw	x,#257
 124  0040 cd0000        	call	_TIM2_ICInit
 126  0043 5b03          	addw	sp,#3
 127                     ; 37   TIM2_SelectInputTrigger(TIM2_TRGSelection_TI2FP2);
 129  0045 a660          	ld	a,#96
 130  0047 cd0000        	call	_TIM2_SelectInputTrigger
 132                     ; 38   TIM2_SelectSlaveMode(TIM2_SlaveMode_Reset);  // Reset timer on selected trigger signal
 134  004a a604          	ld	a,#4
 135  004c cd0000        	call	_TIM2_SelectSlaveMode
 137                     ; 39   TIM2_ITConfig(TIM2_IT_CC1, ENABLE);
 139  004f ae0201        	ldw	x,#513
 140  0052 cd0000        	call	_TIM2_ITConfig
 142                     ; 40   TIM2_ITConfig(TIM2_IT_CC2, ENABLE);
 144  0055 ae0401        	ldw	x,#1025
 145  0058 cd0000        	call	_TIM2_ITConfig
 147                     ; 41   TIM2_Cmd(ENABLE);
 149  005b a601          	ld	a,#1
 150  005d cd0000        	call	_TIM2_Cmd
 152                     ; 44   CLK_PeripheralClockConfig(CLK_Peripheral_USART, ENABLE);
 154  0060 ae2001        	ldw	x,#8193
 155  0063 cd0000        	call	_CLK_PeripheralClockConfig
 157                     ; 45   USART_DeInit();
 159  0066 cd0000        	call	_USART_DeInit
 161                     ; 46   GPIO_Init(USART_PORT, USARTRX_PIN, GPIO_Mode_Out_PP_Low_Slow);
 163  0069 4bc0          	push	#192
 164  006b 4b04          	push	#4
 165  006d ae500a        	ldw	x,#20490
 166  0070 cd0000        	call	_GPIO_Init
 168  0073 85            	popw	x
 169                     ; 47   GPIO_Init(USART_PORT, USARTTX_PIN, GPIO_Mode_In_PU_No_IT);
 171  0074 4b40          	push	#64
 172  0076 4b08          	push	#8
 173  0078 ae500a        	ldw	x,#20490
 174  007b cd0000        	call	_GPIO_Init
 176  007e 85            	popw	x
 177                     ; 48   USART_Init(19200, USART_WordLength_8D, USART_StopBits_1, USART_Parity_No, USART_Mode_Rx | USART_Mode_Tx);
 179  007f 4b0c          	push	#12
 180  0081 4b00          	push	#0
 181  0083 4b00          	push	#0
 182  0085 4b00          	push	#0
 183  0087 ae4b00        	ldw	x,#19200
 184  008a 89            	pushw	x
 185  008b 5f            	clrw	x
 186  008c 89            	pushw	x
 187  008d cd0000        	call	_USART_Init
 189  0090 5b08          	addw	sp,#8
 190                     ; 49   USART_ITConfig(USART_IT_RXNE, ENABLE);
 192  0092 4b01          	push	#1
 193  0094 ae0255        	ldw	x,#597
 194  0097 cd0000        	call	_USART_ITConfig
 196  009a 84            	pop	a
 197                     ; 50   USART_Cmd(ENABLE);
 199  009b a601          	ld	a,#1
 200  009d cd0000        	call	_USART_Cmd
 202                     ; 53   GPIO_Init(LED_PORT, LED_PIN, GPIO_Mode_Out_PP_Low_Slow);
 204  00a0 4bc0          	push	#192
 205  00a2 4b08          	push	#8
 206  00a4 ae5005        	ldw	x,#20485
 207  00a7 cd0000        	call	_GPIO_Init
 209  00aa 85            	popw	x
 210                     ; 55   GPIO_Init(IRIN_PORT, IRIN_PIN, GPIO_Mode_In_FL_No_IT); 
 212  00ab 4b00          	push	#0
 213  00ad 4b01          	push	#1
 214  00af ae5005        	ldw	x,#20485
 215  00b2 cd0000        	call	_GPIO_Init
 217  00b5 85            	popw	x
 218                     ; 56 }
 221  00b6 81            	ret	
 234                     	xdef	_Config
 235                     	xref	_USART_ITConfig
 236                     	xref	_USART_Cmd
 237                     	xref	_USART_Init
 238                     	xref	_USART_DeInit
 239                     	xref	_TIM4_ITConfig
 240                     	xref	_TIM4_Cmd
 241                     	xref	_TIM4_TimeBaseInit
 242                     	xref	_TIM4_DeInit
 243                     	xref	_TIM2_SelectSlaveMode
 244                     	xref	_TIM2_SelectInputTrigger
 245                     	xref	_TIM2_ITConfig
 246                     	xref	_TIM2_Cmd
 247                     	xref	_TIM2_ICInit
 248                     	xref	_TIM2_TimeBaseInit
 249                     	xref	_GPIO_Init
 250                     	xref	_CLK_PeripheralClockConfig
 269                     	end
