   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.23 - 17 Sep 2014
   3                     ; Generator (Limited) V4.3.13 - 22 Oct 2014
   4                     ; Optimizer V4.3.11 - 22 Oct 2014
  49                     ; 59 void USART_DeInit(void)
  49                     ; 60 {
  51                     .text:	section	.text,new
  52  0000               _USART_DeInit:
  56                     ; 63   (void)USART->SR;
  58  0000 c65230        	ld	a,21040
  59                     ; 64   (void)USART->DR;
  61  0003 c65231        	ld	a,21041
  62                     ; 66   USART->BRR2 = USART_BRR2_RESET_VALUE;  /* Set USART_BRR2 to reset value 0x00 */
  64  0006 725f5233      	clr	21043
  65                     ; 67   USART->BRR1 = USART_BRR1_RESET_VALUE;  /* Set USART_BRR1 to reset value 0x00 */
  67  000a 725f5232      	clr	21042
  68                     ; 69   USART->CR1 = USART_CR1_RESET_VALUE;  /* Set USART_CR1 to reset value 0x00 */
  70  000e 725f5234      	clr	21044
  71                     ; 70   USART->CR2 = USART_CR2_RESET_VALUE;  /* Set USART_CR2 to reset value 0x00 */
  73  0012 725f5235      	clr	21045
  74                     ; 71   USART->CR3 = USART_CR3_RESET_VALUE;  /* Set USART_CR3 to reset value 0x00 */
  76  0016 725f5236      	clr	21046
  77                     ; 72   USART->CR4 = USART_CR4_RESET_VALUE;  /* Set USART_CR4 to reset value 0x00 */
  79  001a 725f5237      	clr	21047
  80                     ; 73 }
  83  001e 81            	ret	
 256                     ; 100 void USART_Init(uint32_t BaudRate, USART_WordLength_TypeDef USART_WordLength,
 256                     ; 101                 USART_StopBits_TypeDef USART_StopBits, USART_Parity_TypeDef
 256                     ; 102                 USART_Parity, USART_Mode_TypeDef USART_Mode)
 256                     ; 103 {
 257                     .text:	section	.text,new
 258  0000               _USART_Init:
 260  0000 5204          	subw	sp,#4
 261       00000004      OFST:	set	4
 264                     ; 104   uint32_t BaudRate_Mantissa = 0;
 266                     ; 107   assert_param(IS_USART_BAUDRATE(BaudRate));
 268                     ; 109   assert_param(IS_USART_WordLength(USART_WordLength));
 270                     ; 111   assert_param(IS_USART_STOPBITS(USART_StopBits));
 272                     ; 113   assert_param(IS_USART_PARITY(USART_Parity));
 274                     ; 115   assert_param(IS_USART_MODE(USART_Mode));
 276                     ; 118   USART->CR1 &= (uint8_t)(~(USART_CR1_PCEN | USART_CR1_PS | USART_CR1_M));
 278  0002 c65234        	ld	a,21044
 279  0005 a4e9          	and	a,#233
 280  0007 c75234        	ld	21044,a
 281                     ; 121   USART->CR1 |= (uint8_t)((uint8_t)USART_WordLength | (uint8_t)USART_Parity);
 283  000a 7b0b          	ld	a,(OFST+7,sp)
 284  000c 1a0d          	or	a,(OFST+9,sp)
 285  000e ca5234        	or	a,21044
 286  0011 c75234        	ld	21044,a
 287                     ; 124   USART->CR3 &= (uint8_t)(~USART_CR3_STOP);
 289  0014 c65236        	ld	a,21046
 290  0017 a4cf          	and	a,#207
 291  0019 c75236        	ld	21046,a
 292                     ; 126   USART->CR3 |= (uint8_t)USART_StopBits;
 294  001c c65236        	ld	a,21046
 295  001f 1a0c          	or	a,(OFST+8,sp)
 296  0021 c75236        	ld	21046,a
 297                     ; 129   USART->BRR1 &= (uint8_t)(~USART_BRR1_DIVM);
 299  0024 725f5232      	clr	21042
 300                     ; 131   USART->BRR2 &= (uint8_t)(~USART_BRR2_DIVM);
 302  0028 c65233        	ld	a,21043
 303  002b a40f          	and	a,#15
 304  002d c75233        	ld	21043,a
 305                     ; 133   USART->BRR2 &= (uint8_t)(~USART_BRR2_DIVF);
 307  0030 c65233        	ld	a,21043
 308  0033 a4f0          	and	a,#240
 309  0035 c75233        	ld	21043,a
 310                     ; 135   BaudRate_Mantissa  = ((uint32_t)CLK_GetClockFreq() / BaudRate);
 312  0038 cd0000        	call	_CLK_GetClockFreq
 314  003b 96            	ldw	x,sp
 315  003c 1c0007        	addw	x,#OFST+3
 316  003f cd0000        	call	c_ludv
 318  0042 96            	ldw	x,sp
 319  0043 5c            	incw	x
 320  0044 cd0000        	call	c_rtol
 322                     ; 137   USART->BRR2 = (uint8_t)((BaudRate_Mantissa >> (uint8_t)8) & (uint8_t)0xF0);
 324  0047 7b03          	ld	a,(OFST-1,sp)
 325  0049 a4f0          	and	a,#240
 326  004b c75233        	ld	21043,a
 327                     ; 139   USART->BRR2 |= (uint8_t)(BaudRate_Mantissa & (uint8_t)0x0F);
 329  004e 7b04          	ld	a,(OFST+0,sp)
 330  0050 a40f          	and	a,#15
 331  0052 ca5233        	or	a,21043
 332  0055 c75233        	ld	21043,a
 333                     ; 141   USART->BRR1 = (uint8_t)(BaudRate_Mantissa >> (uint8_t)4);
 335  0058 96            	ldw	x,sp
 336  0059 5c            	incw	x
 337  005a cd0000        	call	c_ltor
 339  005d a604          	ld	a,#4
 340  005f cd0000        	call	c_lursh
 342  0062 5500035232    	mov	21042,c_lreg+3
 343                     ; 144   USART->CR2 &= (uint8_t)~(USART_CR2_TEN | USART_CR2_REN);
 345  0067 c65235        	ld	a,21045
 346  006a a4f3          	and	a,#243
 347  006c c75235        	ld	21045,a
 348                     ; 146   USART->CR2 |= (uint8_t)USART_Mode;
 350  006f c65235        	ld	a,21045
 351  0072 1a0e          	or	a,(OFST+10,sp)
 352  0074 c75235        	ld	21045,a
 353                     ; 147 }
 356  0077 5b04          	addw	sp,#4
 357  0079 81            	ret	
 505                     ; 171 void USART_ClockInit(USART_Clock_TypeDef USART_Clock, USART_CPOL_TypeDef USART_CPOL,
 505                     ; 172                      USART_CPHA_TypeDef USART_CPHA, USART_LastBit_TypeDef USART_LastBit)
 505                     ; 173 {
 506                     .text:	section	.text,new
 507  0000               _USART_ClockInit:
 509  0000 89            	pushw	x
 510       00000000      OFST:	set	0
 513                     ; 175   assert_param(IS_USART_CLOCK(USART_Clock));
 515                     ; 176   assert_param(IS_USART_CPOL(USART_CPOL));
 517                     ; 177   assert_param(IS_USART_CPHA(USART_CPHA));
 519                     ; 178   assert_param(IS_USART_LASTBIT(USART_LastBit));
 521                     ; 181   USART->CR3 &= (uint8_t)~(USART_CR3_CPOL | USART_CR3_CPHA | USART_CR3_LBCL);
 523  0001 c65236        	ld	a,21046
 524  0004 a4f8          	and	a,#248
 525  0006 c75236        	ld	21046,a
 526                     ; 183   USART->CR3 |= (uint8_t)((uint8_t)USART_CPOL | (uint8_t)USART_CPHA | (uint8_t)USART_LastBit);
 528  0009 9f            	ld	a,xl
 529  000a 1a05          	or	a,(OFST+5,sp)
 530  000c 1a06          	or	a,(OFST+6,sp)
 531  000e ca5236        	or	a,21046
 532  0011 c75236        	ld	21046,a
 533                     ; 185   if (USART_Clock != USART_Clock_Disable)
 535  0014 7b01          	ld	a,(OFST+1,sp)
 536  0016 2706          	jreq	L712
 537                     ; 187     USART->CR3 |= (uint8_t)(USART_CR3_CLKEN); /* Set the Clock Enable bit */
 539  0018 72165236      	bset	21046,#3
 541  001c 2004          	jra	L122
 542  001e               L712:
 543                     ; 191     USART->CR3 &= (uint8_t)(~USART_CR3_CLKEN); /* Clear the Clock Enable bit */
 545  001e 72175236      	bres	21046,#3
 546  0022               L122:
 547                     ; 193 }
 550  0022 85            	popw	x
 551  0023 81            	ret	
 606                     ; 201 void USART_Cmd(FunctionalState NewState)
 606                     ; 202 {
 607                     .text:	section	.text,new
 608  0000               _USART_Cmd:
 612                     ; 203   assert_param(IS_FUNCTIONAL_STATE(NewState));
 614                     ; 205   if (NewState != DISABLE)
 616  0000 4d            	tnz	a
 617  0001 2705          	jreq	L152
 618                     ; 207     USART->CR1 &= (uint8_t)(~USART_CR1_USARTD); /**< USART Enable */
 620  0003 721b5234      	bres	21044,#5
 623  0007 81            	ret	
 624  0008               L152:
 625                     ; 211     USART->CR1 |= USART_CR1_USARTD;  /**< USART Disable */
 627  0008 721a5234      	bset	21044,#5
 628                     ; 213 }
 631  000c 81            	ret	
 742                     ; 229 void USART_ITConfig(USART_IT_TypeDef USART_IT, FunctionalState NewState)
 742                     ; 230 {
 743                     .text:	section	.text,new
 744  0000               _USART_ITConfig:
 746  0000 89            	pushw	x
 747  0001 89            	pushw	x
 748       00000002      OFST:	set	2
 751                     ; 231   uint8_t uartreg, itpos = 0x00;
 753                     ; 232   assert_param(IS_USART_CONFIG_IT(USART_IT));
 755                     ; 233   assert_param(IS_FUNCTIONAL_STATE(NewState));
 757                     ; 236   uartreg = (uint8_t)((uint16_t)USART_IT >> (uint8_t)0x08);
 759  0002 9e            	ld	a,xh
 760  0003 6b01          	ld	(OFST-1,sp),a
 761                     ; 238   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)USART_IT & (uint8_t)0x0F));
 763  0005 9f            	ld	a,xl
 764  0006 a40f          	and	a,#15
 765  0008 5f            	clrw	x
 766  0009 97            	ld	xl,a
 767  000a a601          	ld	a,#1
 768  000c 5d            	tnzw	x
 769  000d 2704          	jreq	L02
 770  000f               L22:
 771  000f 48            	sll	a
 772  0010 5a            	decw	x
 773  0011 26fc          	jrne	L22
 774  0013               L02:
 775  0013 6b02          	ld	(OFST+0,sp),a
 776                     ; 240   if (NewState != DISABLE)
 778  0015 7b07          	ld	a,(OFST+5,sp)
 779  0017 2713          	jreq	L723
 780                     ; 243     if (uartreg == 0x01)
 782  0019 7b01          	ld	a,(OFST-1,sp)
 783  001b 4a            	dec	a
 784  001c 2607          	jrne	L133
 785                     ; 245       USART->CR1 |= itpos;
 787  001e c65234        	ld	a,21044
 788  0021 1a02          	or	a,(OFST+0,sp)
 790  0023 2012          	jp	LC002
 791  0025               L133:
 792                     ; 250       USART->CR2 |= itpos;
 794  0025 c65235        	ld	a,21045
 795  0028 1a02          	or	a,(OFST+0,sp)
 796  002a 2016          	jp	LC001
 797  002c               L723:
 798                     ; 256     if (uartreg == 0x01)
 800  002c 7b01          	ld	a,(OFST-1,sp)
 801  002e 4a            	dec	a
 802  002f 260b          	jrne	L733
 803                     ; 258       USART->CR1 &= (uint8_t)(~itpos);
 805  0031 7b02          	ld	a,(OFST+0,sp)
 806  0033 43            	cpl	a
 807  0034 c45234        	and	a,21044
 808  0037               LC002:
 809  0037 c75234        	ld	21044,a
 811  003a 2009          	jra	L533
 812  003c               L733:
 813                     ; 263       USART->CR2 &= (uint8_t)(~itpos);
 815  003c 7b02          	ld	a,(OFST+0,sp)
 816  003e 43            	cpl	a
 817  003f c45235        	and	a,21045
 818  0042               LC001:
 819  0042 c75235        	ld	21045,a
 820  0045               L533:
 821                     ; 267 }
 824  0045 5b04          	addw	sp,#4
 825  0047 81            	ret	
 848                     ; 275 uint8_t USART_ReceiveData8(void)
 848                     ; 276 {
 849                     .text:	section	.text,new
 850  0000               _USART_ReceiveData8:
 854                     ; 277   return USART->DR;
 856  0000 c65231        	ld	a,21041
 859  0003 81            	ret	
 893                     ; 287 uint16_t USART_ReceiveData9(void)
 893                     ; 288 {
 894                     .text:	section	.text,new
 895  0000               _USART_ReceiveData9:
 897  0000 89            	pushw	x
 898       00000002      OFST:	set	2
 901                     ; 289   uint16_t temp = 0;
 903                     ; 291   temp = ((uint16_t)(((uint16_t)((uint16_t)USART->CR1 & (uint16_t)USART_CR1_R8)) << 1));
 905  0001 c65234        	ld	a,21044
 906  0004 a480          	and	a,#128
 907  0006 5f            	clrw	x
 908  0007 02            	rlwa	x,a
 909  0008 58            	sllw	x
 910  0009 1f01          	ldw	(OFST-1,sp),x
 911                     ; 292   return (uint16_t)( ((uint16_t)((uint16_t)USART->DR) | temp) & ((uint16_t)0x01FF));
 913  000b c65231        	ld	a,21041
 914  000e 5f            	clrw	x
 915  000f 97            	ld	xl,a
 916  0010 01            	rrwa	x,a
 917  0011 1a02          	or	a,(OFST+0,sp)
 918  0013 01            	rrwa	x,a
 919  0014 1a01          	or	a,(OFST-1,sp)
 920  0016 a401          	and	a,#1
 921  0018 01            	rrwa	x,a
 924  0019 5b02          	addw	sp,#2
 925  001b 81            	ret	
 961                     ; 301 void USART_ReceiverWakeUpCmd(FunctionalState NewState)
 961                     ; 302 {
 962                     .text:	section	.text,new
 963  0000               _USART_ReceiverWakeUpCmd:
 967                     ; 303   assert_param(IS_FUNCTIONAL_STATE(NewState));
 969                     ; 305   if (NewState != DISABLE)
 971  0000 4d            	tnz	a
 972  0001 2705          	jreq	L704
 973                     ; 308     USART->CR2 |= USART_CR2_RWU;
 975  0003 72125235      	bset	21045,#1
 978  0007 81            	ret	
 979  0008               L704:
 980                     ; 313     USART->CR2 &= ((uint8_t)~USART_CR2_RWU);
 982  0008 72135235      	bres	21045,#1
 983                     ; 315 }
 986  000c 81            	ret	
1009                     ; 322 void USART_SendBreak(void)
1009                     ; 323 {
1010                     .text:	section	.text,new
1011  0000               _USART_SendBreak:
1015                     ; 324   USART->CR2 |= USART_CR2_SBK;
1017  0000 72105235      	bset	21045,#0
1018                     ; 325 }
1021  0004 81            	ret	
1055                     ; 332 void USART_SendData8(uint8_t Data)
1055                     ; 333 {
1056                     .text:	section	.text,new
1057  0000               _USART_SendData8:
1061                     ; 335   USART->DR = Data;
1063  0000 c75231        	ld	21041,a
1064                     ; 336 }
1067  0003 81            	ret	
1101                     ; 344 void USART_SendData9(uint16_t Data)
1101                     ; 345 {
1102                     .text:	section	.text,new
1103  0000               _USART_SendData9:
1105  0000 89            	pushw	x
1106       00000000      OFST:	set	0
1109                     ; 346   assert_param(IS_USART_DATA_9BITS(Data));
1111                     ; 348   USART->CR1 &= ((uint8_t)~USART_CR1_T8);                    /* Clear the transmit data bit 8     */
1113  0001 721d5234      	bres	21044,#6
1114                     ; 349   USART->CR1 |= (uint8_t)(((uint8_t)(Data >> 2)) & USART_CR1_T8); /* Write the transmit data bit [8]   */
1116  0005 54            	srlw	x
1117  0006 54            	srlw	x
1118  0007 9f            	ld	a,xl
1119  0008 a440          	and	a,#64
1120  000a ca5234        	or	a,21044
1121  000d c75234        	ld	21044,a
1122                     ; 350   USART->DR   = (uint8_t)(Data);                             /* Write the transmit data bit [0:7] */
1124  0010 7b02          	ld	a,(OFST+2,sp)
1125  0012 c75231        	ld	21041,a
1126                     ; 352 }
1129  0015 85            	popw	x
1130  0016 81            	ret	
1164                     ; 360 void USART_SetAddress(uint8_t Address)
1164                     ; 361 {
1165                     .text:	section	.text,new
1166  0000               _USART_SetAddress:
1168  0000 88            	push	a
1169       00000000      OFST:	set	0
1172                     ; 363   assert_param(IS_USART_ADDRESS(Address));
1174                     ; 366   USART->CR4 &= ((uint8_t)~USART_CR4_ADD);
1176  0001 c65237        	ld	a,21047
1177  0004 a4f0          	and	a,#240
1178  0006 c75237        	ld	21047,a
1179                     ; 368   USART->CR4 |= Address;
1181  0009 c65237        	ld	a,21047
1182  000c 1a01          	or	a,(OFST+1,sp)
1183  000e c75237        	ld	21047,a
1184                     ; 369 }
1187  0011 84            	pop	a
1188  0012 81            	ret	
1245                     ; 379 void USART_WakeUpConfig(USART_WakeUp_TypeDef USART_WakeUp)
1245                     ; 380 {
1246                     .text:	section	.text,new
1247  0000               _USART_WakeUpConfig:
1251                     ; 381   assert_param(IS_USART_WAKEUP(USART_WakeUp));
1253                     ; 383   USART->CR1 &= ((uint8_t)~USART_CR1_WAKE);
1255  0000 72175234      	bres	21044,#3
1256                     ; 384   USART->CR1 |= (uint8_t)USART_WakeUp;
1258  0004 ca5234        	or	a,21044
1259  0007 c75234        	ld	21044,a
1260                     ; 385 }
1263  000a 81            	ret	
1399                     ; 400 FlagStatus USART_GetFlagStatus(USART_FLAG_TypeDef USART_FLAG)
1399                     ; 401 {
1400                     .text:	section	.text,new
1401  0000               _USART_GetFlagStatus:
1403  0000 89            	pushw	x
1404  0001 88            	push	a
1405       00000001      OFST:	set	1
1408                     ; 402   FlagStatus status = RESET;
1410                     ; 405   assert_param(IS_USART_FLAG(USART_FLAG));
1412                     ; 407   if (USART_FLAG == USART_FLAG_SBK)
1414  0002 a30101        	cpw	x,#257
1415  0005 2608          	jrne	L306
1416                     ; 409     if ((USART->CR2 & (uint8_t)USART_FLAG) != (uint8_t)0x00)
1418  0007 9f            	ld	a,xl
1419  0008 c45235        	and	a,21045
1420  000b 270e          	jreq	L116
1421                     ; 412       status = SET;
1423  000d 2007          	jp	LC004
1424                     ; 417       status = RESET;
1425  000f               L306:
1426                     ; 422     if ((USART->SR & (uint8_t)USART_FLAG) != (uint8_t)0x00)
1428  000f c65230        	ld	a,21040
1429  0012 1503          	bcp	a,(OFST+2,sp)
1430  0014 2704          	jreq	L316
1431                     ; 425       status = SET;
1433  0016               LC004:
1435  0016 a601          	ld	a,#1
1438  0018 2001          	jra	L116
1439  001a               L316:
1440                     ; 430       status = RESET;
1442  001a 4f            	clr	a
1443  001b               L116:
1444                     ; 434   return status;
1448  001b 5b03          	addw	sp,#3
1449  001d 81            	ret	
1472                     ; 454 void USART_ClearFlag(void)
1472                     ; 455 {
1473                     .text:	section	.text,new
1474  0000               _USART_ClearFlag:
1478                     ; 457   USART->SR = (uint8_t)~(USART_SR_RXNE);
1480  0000 35df5230      	mov	21040,#223
1481                     ; 458 }
1484  0004 81            	ret	
1566                     ; 472 ITStatus USART_GetITStatus(USART_IT_TypeDef USART_IT)
1566                     ; 473 {
1567                     .text:	section	.text,new
1568  0000               _USART_GetITStatus:
1570  0000 89            	pushw	x
1571  0001 89            	pushw	x
1572       00000002      OFST:	set	2
1575                     ; 474   ITStatus pendingbitstatus = RESET;
1577                     ; 475   uint8_t itpos = 0;
1579                     ; 476   uint8_t itmask1 = 0;
1581                     ; 477   uint8_t itmask2 = 0;
1583                     ; 478   uint8_t enablestatus = 0;
1585                     ; 481   assert_param(IS_USART_GET_IT(USART_IT));
1587                     ; 484   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)USART_IT & (uint8_t)0x0F));
1589  0002 9f            	ld	a,xl
1590  0003 a40f          	and	a,#15
1591  0005 5f            	clrw	x
1592  0006 97            	ld	xl,a
1593  0007 a601          	ld	a,#1
1594  0009 5d            	tnzw	x
1595  000a 2704          	jreq	L25
1596  000c               L45:
1597  000c 48            	sll	a
1598  000d 5a            	decw	x
1599  000e 26fc          	jrne	L45
1600  0010               L25:
1601  0010 6b01          	ld	(OFST-1,sp),a
1602                     ; 486   itmask1 = (uint8_t)((uint8_t)USART_IT >> (uint8_t)4);
1604  0012 7b04          	ld	a,(OFST+2,sp)
1605  0014 4e            	swap	a
1606  0015 a40f          	and	a,#15
1607  0017 6b02          	ld	(OFST+0,sp),a
1608                     ; 488   itmask2 = (uint8_t)((uint8_t)1 << itmask1);
1610  0019 5f            	clrw	x
1611  001a 97            	ld	xl,a
1612  001b a601          	ld	a,#1
1613  001d 5d            	tnzw	x
1614  001e 2704          	jreq	L65
1615  0020               L06:
1616  0020 48            	sll	a
1617  0021 5a            	decw	x
1618  0022 26fc          	jrne	L06
1619  0024               L65:
1620  0024 6b02          	ld	(OFST+0,sp),a
1621                     ; 492   if (USART_IT == USART_IT_PE)
1623  0026 1e03          	ldw	x,(OFST+1,sp)
1624  0028 a30100        	cpw	x,#256
1625  002b 2614          	jrne	L176
1626                     ; 495     enablestatus = (uint8_t)((uint8_t)USART->CR1 & itmask2);
1628  002d c65234        	ld	a,21044
1629  0030 1402          	and	a,(OFST+0,sp)
1630  0032 6b02          	ld	(OFST+0,sp),a
1631                     ; 498     if (((USART->SR & itpos) != (uint8_t)0x00) && enablestatus)
1633  0034 c65230        	ld	a,21040
1634  0037 1501          	bcp	a,(OFST-1,sp)
1635  0039 271c          	jreq	L107
1637  003b 7b02          	ld	a,(OFST+0,sp)
1638  003d 2718          	jreq	L107
1639                     ; 501       pendingbitstatus = SET;
1641  003f 2012          	jp	LC006
1642                     ; 506       pendingbitstatus = RESET;
1643  0041               L176:
1644                     ; 512     enablestatus = (uint8_t)((uint8_t)USART->CR2 & itmask2);
1646  0041 c65235        	ld	a,21045
1647  0044 1402          	and	a,(OFST+0,sp)
1648  0046 6b02          	ld	(OFST+0,sp),a
1649                     ; 514     if (((USART->SR & itpos) != (uint8_t)0x00) && enablestatus)
1651  0048 c65230        	ld	a,21040
1652  004b 1501          	bcp	a,(OFST-1,sp)
1653  004d 2708          	jreq	L107
1655  004f 7b02          	ld	a,(OFST+0,sp)
1656  0051 2704          	jreq	L107
1657                     ; 517       pendingbitstatus = SET;
1659  0053               LC006:
1661  0053 a601          	ld	a,#1
1663  0055 2001          	jra	L776
1664  0057               L107:
1665                     ; 522       pendingbitstatus = RESET;
1668  0057 4f            	clr	a
1669  0058               L776:
1670                     ; 527   return  pendingbitstatus;
1674  0058 5b04          	addw	sp,#4
1675  005a 81            	ret	
1699                     ; 546 void USART_ClearITPendingBit(void)
1699                     ; 547 {
1700                     .text:	section	.text,new
1701  0000               _USART_ClearITPendingBit:
1705                     ; 549   USART->SR = (uint8_t)~(USART_SR_RXNE);
1707  0000 35df5230      	mov	21040,#223
1708                     ; 550 }
1711  0004 81            	ret	
1724                     	xdef	_USART_ClearITPendingBit
1725                     	xdef	_USART_GetITStatus
1726                     	xdef	_USART_ClearFlag
1727                     	xdef	_USART_GetFlagStatus
1728                     	xdef	_USART_WakeUpConfig
1729                     	xdef	_USART_SetAddress
1730                     	xdef	_USART_SendData9
1731                     	xdef	_USART_SendData8
1732                     	xdef	_USART_SendBreak
1733                     	xdef	_USART_ReceiverWakeUpCmd
1734                     	xdef	_USART_ReceiveData9
1735                     	xdef	_USART_ReceiveData8
1736                     	xdef	_USART_ITConfig
1737                     	xdef	_USART_Cmd
1738                     	xdef	_USART_ClockInit
1739                     	xdef	_USART_Init
1740                     	xdef	_USART_DeInit
1741                     	xref	_CLK_GetClockFreq
1742                     	xref.b	c_lreg
1743                     	xref.b	c_x
1762                     	xref	c_lursh
1763                     	xref	c_ltor
1764                     	xref	c_rtol
1765                     	xref	c_ludv
1766                     	end
