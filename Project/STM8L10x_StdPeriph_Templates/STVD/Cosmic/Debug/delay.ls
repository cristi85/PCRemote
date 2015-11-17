   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.23 - 17 Sep 2014
   3                     ; Generator (Limited) V4.3.13 - 22 Oct 2014
   4                     ; Optimizer V4.3.11 - 22 Oct 2014
  61                     ; 12 void delay_ms(u16 n_ms)
  61                     ; 13 {
  63                     .text:	section	.text,new
  64  0000               _delay_ms:
  66  0000 89            	pushw	x
  67       00000000      OFST:	set	0
  70                     ; 15   CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, ENABLE);
  72  0001 ae0401        	ldw	x,#1025
  73  0004 cd0000        	call	_CLK_PeripheralClockConfig
  75                     ; 18   TIM4->PSCR = 0;
  77  0007 725f52e7      	clr	21223
  78                     ; 21   TIM4->ARR = 38;
  80  000b 352652e8      	mov	21224,#38
  81                     ; 25   TIM4->CNTR = 4;  //value may have to be changed
  83  000f 350452e6      	mov	21222,#4
  84                     ; 28   TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);
  86  0013 721152e4      	bres	21220,#0
  87                     ; 31   TIM4->CR1 |= TIM4_CR1_CEN;
  89  0017 721052e0      	bset	21216,#0
  91  001b 2009          	jra	L33
  92  001d               L14:
  93                     ; 35     while((TIM4->SR1 & TIM4_FLAG_Update) == 0);
  95  001d 720152e4fb    	btjf	21220,#0,L14
  96                     ; 36     TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);
  98  0022 721152e4      	bres	21220,#0
  99  0026               L33:
 100                     ; 33   while(n_ms--)
 102  0026 1e01          	ldw	x,(OFST+1,sp)
 103  0028 5a            	decw	x
 104  0029 1f01          	ldw	(OFST+1,sp),x
 105  002b 5c            	incw	x
 106  002c 26ef          	jrne	L14
 107                     ; 40   TIM4->CR1 &= (u8)(~TIM4_CR1_CEN);
 109  002e 721152e0      	bres	21216,#0
 110                     ; 41   CLK_PeripheralClockConfig(CLK_Peripheral_TIM4, DISABLE);
 112  0032 ae0400        	ldw	x,#1024
 113  0035 cd0000        	call	_CLK_PeripheralClockConfig
 115                     ; 42 }
 118  0038 85            	popw	x
 119  0039 81            	ret	
 153                     ; 52 void delay_tim4(u8 _delay)
 153                     ; 53 {
 154                     .text:	section	.text,new
 155  0000               _delay_tim4:
 159                     ; 54   TIM4->CNTR = 3;
 161  0000 350352e6      	mov	21222,#3
 162                     ; 55   TIM4->ARR = _delay;
 164  0004 c752e8        	ld	21224,a
 165                     ; 56   TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);  // clear update flag
 167  0007 721152e4      	bres	21220,#0
 168                     ; 57   TIM4->CR1 |= TIM4_CR1_CEN;             // Enable Counter
 170  000b 721052e0      	bset	21216,#0
 172  000f               L56:
 173                     ; 58   while((TIM4->SR1 & TIM4_FLAG_Update) == 0);
 175  000f 720152e4fb    	btjf	21220,#0,L56
 176                     ; 59   TIM4->SR1 &= (u8)(~TIM4_FLAG_Update);
 178  0014 721152e4      	bres	21220,#0
 179                     ; 60   TIM4->CR1 &= (u8)(~TIM4_CR1_CEN);      // Disable Counter
 181  0018 721152e0      	bres	21216,#0
 182                     ; 61 }
 185  001c 81            	ret	
 200                     	xdef	_delay_tim4
 201                     	xdef	_delay_ms
 202                     	xref	_CLK_PeripheralClockConfig
 221                     	end
