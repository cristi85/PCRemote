   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.23 - 17 Sep 2014
   3                     ; Generator (Limited) V4.3.13 - 22 Oct 2014
   4                     ; Optimizer V4.3.11 - 22 Oct 2014
  21                     	bsct
  22  0000               L3_RC5_rcvstate:
  23  0000 00            	dc.b	0
  24  0001               L5_RC5_rcvsubstate:
  25  0001 00            	dc.b	0
  26  0002               _FLAG_new_rc5_frame:
  27  0002 00            	dc.b	0
  28  0003               L31_FLAG_rise_edge:
  29  0003 00            	dc.b	0
  30  0004               L51_FLAG_fall_edge:
  31  0004 00            	dc.b	0
  32  0005               L71_FLAG_CC_Error:
  33  0005 00            	dc.b	0
  34  0006               L12_rc5_bittime:
  35  0006 0000          	dc.w	0
  36  0008               L32_rc5_halfbittime:
  37  0008 0000          	dc.w	0
  38  000a               L52_test_cnt:
  39  000a 00            	dc.b	0
  40  000b               L72_rc5_offset:
  41  000b 0000          	dc.w	0
  42  000d               L13_IRtimeoutcnt:
  43  000d 00            	dc.b	0
  44  000e               L33_LEDtimeoutcnt:
  45  000e 00            	dc.b	0
  46  000f               _FLAG_LEDtimeout:
  47  000f 00            	dc.b	0
  48  0010               L53_rc5_currentbit:
  49  0010 00            	dc.b	0
  50  0011               L73_rc5_cap_offset:
  51  0011 0000          	dc.w	0
  52  0013               L34_idx:
  53  0013 0000          	dc.w	0
  54  0015               L54_FLAG_markfirst:
  55  0015 00            	dc.b	0
  56  0016               L74_first:
  57  0016 00            	dc.b	0
  58  0017               L15_test:
  59  0017 0000          	dc.w	0
  60  0019               _Btn_pressed:
  61  0019 00            	dc.b	0
  91                     ; 83 INTERRUPT_HANDLER(NonHandledInterrupt,0)
  91                     ; 84 {
  92                     .text:	section	.text,new
  93  0000               f_NonHandledInterrupt:
  97                     ; 88 }
 100  0000 80            	iret	
 141                     ; 96 INTERRUPT_HANDLER(TIM2_CAP_IRQHandler, 20)
 141                     ; 97 {
 142                     .text:	section	.text,new
 143  0000               f_TIM2_CAP_IRQHandler:
 145  0000 8a            	push	cc
 146  0001 84            	pop	a
 147  0002 a4bf          	and	a,#191
 148  0004 88            	push	a
 149  0005 86            	pop	cc
 150       00000001      OFST:	set	1
 151  0006 3b0002        	push	c_x+2
 152  0009 be00          	ldw	x,c_x
 153  000b 89            	pushw	x
 154  000c 3b0002        	push	c_y+2
 155  000f be00          	ldw	x,c_y
 156  0011 89            	pushw	x
 157  0012 88            	push	a
 160                     ; 101   if(TIM2_GetITStatus(TIM2_IT_CC1) == SET)
 162  0013 a602          	ld	a,#2
 163  0015 cd0000        	call	_TIM2_GetITStatus
 165  0018 4a            	dec	a
 166  0019 260b          	jrne	L511
 167                     ; 103     cap_rise = TIM2_GetCapture1();
 169  001b cd0000        	call	_TIM2_GetCapture1
 171  001e bf02          	ldw	L7_cap_rise,x
 172                     ; 104     FLAG_rise_edge = TRUE;
 174  0020 35010003      	mov	L31_FLAG_rise_edge,#1
 176  0024 2002          	jra	L711
 177  0026               L511:
 178                     ; 106   else FLAG_rise_edge = FALSE;
 180  0026 3f03          	clr	L31_FLAG_rise_edge
 181  0028               L711:
 182                     ; 107   if(TIM2_GetITStatus(TIM2_IT_CC2) == SET)
 184  0028 a604          	ld	a,#4
 185  002a cd0000        	call	_TIM2_GetITStatus
 187  002d 4a            	dec	a
 188  002e 260b          	jrne	L121
 189                     ; 109     cap_fall = TIM2_GetCapture2();
 191  0030 cd0000        	call	_TIM2_GetCapture2
 193  0033 bf00          	ldw	L11_cap_fall,x
 194                     ; 110     FLAG_fall_edge = TRUE;
 196  0035 35010004      	mov	L51_FLAG_fall_edge,#1
 198  0039 2002          	jra	L321
 199  003b               L121:
 200                     ; 112   else FLAG_fall_edge = FALSE;
 202  003b 3f04          	clr	L51_FLAG_fall_edge
 203  003d               L321:
 204                     ; 113   if(FLAG_rise_edge && FLAG_fall_edge)
 206  003d b603          	ld	a,L31_FLAG_rise_edge
 207  003f 2708          	jreq	L521
 209  0041 b604          	ld	a,L51_FLAG_fall_edge
 210  0043 2704          	jreq	L521
 211                     ; 115     FLAG_CC_Error = TRUE;
 213  0045 35010005      	mov	L71_FLAG_CC_Error,#1
 214  0049               L521:
 215                     ; 127   IRtimeoutcnt = 0;
 217  0049 3f0d          	clr	L13_IRtimeoutcnt
 218                     ; 128   switch(RC5_rcvstate)
 220  004b b600          	ld	a,L3_RC5_rcvstate
 222                     ; 200     default: break;
 223  004d 2707          	jreq	L17
 224  004f 4a            	dec	a
 225  0050 273b          	jreq	L101
 226  0052 ac880188      	jra	L131
 227  0056               L17:
 228                     ; 132       switch(RC5_rcvsubstate)
 230  0056 b601          	ld	a,L5_RC5_rcvsubstate
 232                     ; 158         default: break;
 233  0058 2707          	jreq	L37
 234  005a 4a            	dec	a
 235  005b 271a          	jreq	L57
 236  005d ac880188      	jra	L131
 237  0061               L37:
 238                     ; 136           RC5_frame.valid = 1;
 240                     ; 137           RC5_frame.togglebit = 0;
 242                     ; 138           RC5_frame.address = 0;
 244  0061 b604          	ld	a,_RC5_frame
 245  0063 a481          	and	a,#129
 246  0065 aa01          	or	a,#1
 247  0067 b704          	ld	_RC5_frame,a
 248                     ; 139           RC5_frame.command = 0;
 250  0069 b605          	ld	a,_RC5_frame+1
 251  006b a4c0          	and	a,#192
 252  006d b705          	ld	_RC5_frame+1,a
 253                     ; 140           rc5_currentbit = 0;
 255  006f 3f10          	clr	L53_rc5_currentbit
 256                     ; 141           RC5_rcvsubstate = 1;
 258  0071 35010001      	mov	L5_RC5_rcvsubstate,#1
 259                     ; 142           rc5_offset = 0;
 260                     ; 143           break;
 262  0075 2042          	jpf	LC003
 263  0077               L57:
 264                     ; 147           if(FLAG_fall_edge)
 266  0077 3d04          	tnz	L51_FLAG_fall_edge
 267  0079 27e2          	jreq	L131
 268                     ; 149             rc5_halfbittime = cap_rise;
 270  007b be02          	ldw	x,L7_cap_rise
 271  007d bf08          	ldw	L32_rc5_halfbittime,x
 272                     ; 150             rc5_bittime = cap_fall;
 274  007f be00          	ldw	x,L11_cap_fall
 275  0081 bf06          	ldw	L12_rc5_bittime,x
 276                     ; 153             RC5_rcvsubstate = 0;
 278  0083 b701          	ld	L5_RC5_rcvsubstate,a
 279                     ; 154             RC5_rcvstate = RC5_RCV_BITS;
 281  0085 35010000      	mov	L3_RC5_rcvstate,#1
 282  0089 ac880188      	jra	L131
 283                     ; 158         default: break;
 285                     ; 160       break;
 287  008d               L101:
 288                     ; 164       if(FLAG_rise_edge)
 290  008d b603          	ld	a,L31_FLAG_rise_edge
 291  008f 2749          	jreq	L141
 292                     ; 166         if(cap_rise+rc5_offset <= rc5_bittime+IR_EDGES_JITTER && cap_rise+rc5_offset >= rc5_bittime-IR_EDGES_JITTER)
 294  0091 be02          	ldw	x,L7_cap_rise
 295  0093 72bb000b      	addw	x,L72_rc5_offset
 296  0097 90be06        	ldw	y,L12_rc5_bittime
 297  009a 8da001a0      	callf	LC006
 298  009e 221c          	jrugt	L341
 300  00a0 90be06        	ldw	y,L12_rc5_bittime
 301  00a3 8daa01aa      	callf	LC007
 302  00a7 2513          	jrult	L341
 303                     ; 169           rc5_currentbit++;
 305  00a9 3c10          	inc	L53_rc5_currentbit
 306                     ; 170           if(rc5_currentbit > 11) FLAG_new_rc5_frame = TRUE;
 308  00ab b610          	ld	a,L53_rc5_currentbit
 309  00ad a10c          	cp	a,#12
 310  00af 2504          	jrult	L541
 313  00b1               LC005:
 315  00b1 35010002      	mov	_FLAG_new_rc5_frame,#1
 316  00b5               L541:
 317                     ; 171           if(rc5_offset > 0) rc5_offset = 0;
 320  00b5 be0b          	ldw	x,L72_rc5_offset
 321  00b7 27d0          	jreq	L131
 324  00b9               LC003:
 327  00b9 5f            	clrw	x
 328  00ba 2018          	jpf	LC002
 329  00bc               L341:
 330                     ; 173         else if(cap_rise <= rc5_halfbittime+IR_EDGES_JITTER && cap_rise >= rc5_halfbittime-IR_EDGES_JITTER)
 332  00bc be08          	ldw	x,L32_rc5_halfbittime
 333  00be 1c0064        	addw	x,#100
 334  00c1 b302          	cpw	x,L7_cap_rise
 335  00c3 2404ac840184  	jrult	L502
 337  00c9 be08          	ldw	x,L32_rc5_halfbittime
 338  00cb 1d0064        	subw	x,#100
 339  00ce b302          	cpw	x,L7_cap_rise
 340  00d0 22f3          	jrugt	L502
 341                     ; 175           rc5_offset = cap_rise;
 343  00d2 be02          	ldw	x,L7_cap_rise
 344  00d4               LC002:
 345  00d4 bf0b          	ldw	L72_rc5_offset,x
 347  00d6 ac880188      	jra	L131
 348                     ; 177         else RC5_frame.valid = 0;
 349  00da               L141:
 350                     ; 179       else if(FLAG_fall_edge)
 352  00da b604          	ld	a,L51_FLAG_fall_edge
 353  00dc 27f8          	jreq	L131
 354                     ; 181         if(cap_fall-cap_rise+rc5_offset <= rc5_bittime+IR_EDGES_JITTER && cap_fall-cap_rise+rc5_offset >= rc5_bittime-IR_EDGES_JITTER)
 356  00de be00          	ldw	x,L11_cap_fall
 357  00e0 72b00002      	subw	x,L7_cap_rise
 358  00e4 72bb000b      	addw	x,L72_rc5_offset
 359  00e8 90be06        	ldw	y,L12_rc5_bittime
 360  00eb 8da001a0      	callf	LC006
 361  00ef 226b          	jrugt	L361
 363  00f1 90be06        	ldw	y,L12_rc5_bittime
 364  00f4 8daa01aa      	callf	LC007
 365  00f8 2562          	jrult	L361
 366                     ; 184           if     (rc5_currentbit == 0) RC5_frame.togglebit = 1;
 368  00fa b610          	ld	a,L53_rc5_currentbit
 369  00fc 2606          	jrne	L561
 372  00fe 72120004      	bset	_RC5_frame,#1
 374  0102 2048          	jra	L761
 375  0104               L561:
 376                     ; 185           else if(rc5_currentbit <= 5) RC5_frame.address |= (u8)(1<<(5-rc5_currentbit));
 378  0104 a106          	cp	a,#6
 379  0106 2425          	jruge	L171
 382  0108 a605          	ld	a,#5
 383  010a b010          	sub	a,L53_rc5_currentbit
 384  010c 5f            	clrw	x
 385  010d 97            	ld	xl,a
 386  010e a601          	ld	a,#1
 387  0110 5d            	tnzw	x
 388  0111 2704          	jreq	L02
 389  0113               L22:
 390  0113 48            	sll	a
 391  0114 5a            	decw	x
 392  0115 26fc          	jrne	L22
 393  0117               L02:
 394  0117 6b01          	ld	(OFST+0,sp),a
 395  0119 b604          	ld	a,_RC5_frame
 396  011b a47c          	and	a,#124
 397  011d 44            	srl	a
 398  011e 44            	srl	a
 399  011f 1a01          	or	a,(OFST+0,sp)
 400  0121 48            	sll	a
 401  0122 48            	sll	a
 402  0123 b804          	xor	a,_RC5_frame
 403  0125 a47c          	and	a,#124
 404  0127 b804          	xor	a,_RC5_frame
 405  0129 b704          	ld	_RC5_frame,a
 407  012b 201f          	jra	L761
 408  012d               L171:
 409                     ; 186           else RC5_frame.command |= (u8)(1<<(11-rc5_currentbit));
 411  012d a60b          	ld	a,#11
 412  012f b010          	sub	a,L53_rc5_currentbit
 413  0131 5f            	clrw	x
 414  0132 97            	ld	xl,a
 415  0133 a601          	ld	a,#1
 416  0135 5d            	tnzw	x
 417  0136 2704          	jreq	L42
 418  0138               L62:
 419  0138 48            	sll	a
 420  0139 5a            	decw	x
 421  013a 26fc          	jrne	L62
 422  013c               L42:
 423  013c 6b01          	ld	(OFST+0,sp),a
 424  013e b605          	ld	a,_RC5_frame+1
 425  0140 a43f          	and	a,#63
 426  0142 1a01          	or	a,(OFST+0,sp)
 427  0144 b805          	xor	a,_RC5_frame+1
 428  0146 a43f          	and	a,#63
 429  0148 b805          	xor	a,_RC5_frame+1
 430  014a b705          	ld	_RC5_frame+1,a
 431  014c               L761:
 432                     ; 187           rc5_currentbit++;
 434  014c 3c10          	inc	L53_rc5_currentbit
 435                     ; 188           if(rc5_currentbit > 11) FLAG_new_rc5_frame = TRUE;
 437  014e b610          	ld	a,L53_rc5_currentbit
 438  0150 a10c          	cp	a,#12
 439  0152 2404acb500b5  	jrult	L541
 442                     ; 190           if(rc5_offset > 0) rc5_offset = 0;
 444  0158 acb100b1      	jpf	LC005
 445  015c               L361:
 446                     ; 192         else if(cap_fall-cap_rise <= rc5_halfbittime+IR_EDGES_JITTER && cap_fall-cap_rise >= rc5_halfbittime-IR_EDGES_JITTER)
 448  015c be00          	ldw	x,L11_cap_fall
 449  015e 72b00002      	subw	x,L7_cap_rise
 450  0162 90be08        	ldw	y,L32_rc5_halfbittime
 451  0165 8da001a0      	callf	LC006
 452  0169 2219          	jrugt	L502
 454  016b be00          	ldw	x,L11_cap_fall
 455  016d 72b00002      	subw	x,L7_cap_rise
 456  0171 90be08        	ldw	y,L32_rc5_halfbittime
 457  0174 8daa01aa      	callf	LC007
 458  0178 250a          	jrult	L502
 459                     ; 194           rc5_offset = cap_fall-cap_rise;
 461  017a be00          	ldw	x,L11_cap_fall
 462  017c 72b00002      	subw	x,L7_cap_rise
 464  0180 acd400d4      	jpf	LC002
 465  0184               L502:
 466                     ; 196         else RC5_frame.valid = 0;
 469  0184 72110004      	bres	_RC5_frame,#0
 470                     ; 200     default: break;
 472  0188               L131:
 473                     ; 203   TIM2_ClearITPendingBit(TIM2_IT_CC1);
 475  0188 a602          	ld	a,#2
 476  018a cd0000        	call	_TIM2_ClearITPendingBit
 478                     ; 204   TIM2_ClearITPendingBit(TIM2_IT_CC2);
 480  018d a604          	ld	a,#4
 481  018f cd0000        	call	_TIM2_ClearITPendingBit
 483                     ; 205 }
 486  0192 84            	pop	a
 487  0193 85            	popw	x
 488  0194 bf00          	ldw	c_y,x
 489  0196 320002        	pop	c_y+2
 490  0199 85            	popw	x
 491  019a bf00          	ldw	c_x,x
 492  019c 320002        	pop	c_x+2
 493  019f 80            	iret	
 494  01a0               LC006:
 495  01a0 72a90064      	addw	y,#100
 496  01a4 90bf00        	ldw	c_y,y
 497  01a7 b300          	cpw	x,c_y
 498  01a9 87            	retf	
 499  01aa               LC007:
 500  01aa 72a20064      	subw	y,#100
 501  01ae 90bf00        	ldw	c_y,y
 502  01b1 b300          	cpw	x,c_y
 503  01b3 87            	retf	
 533                     ; 212 INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 25)  /* every 2.048ms */
 533                     ; 213 {
 534                     .text:	section	.text,new
 535  0000               f_TIM4_UPD_OVF_IRQHandler:
 537  0000 8a            	push	cc
 538  0001 84            	pop	a
 539  0002 a4bf          	and	a,#191
 540  0004 88            	push	a
 541  0005 86            	pop	cc
 542  0006 3b0002        	push	c_x+2
 543  0009 be00          	ldw	x,c_x
 544  000b 89            	pushw	x
 545  000c 3b0002        	push	c_y+2
 546  000f be00          	ldw	x,c_y
 547  0011 89            	pushw	x
 550                     ; 214   if(TIM4_GetITStatus(TIM4_IT_Update) == SET)
 552  0012 a601          	ld	a,#1
 553  0014 cd0000        	call	_TIM4_GetITStatus
 555  0017 4a            	dec	a
 556  0018 2631          	jrne	L122
 557                     ; 217     if(IRtimeoutcnt < 255) IRtimeoutcnt++;
 559  001a b60d          	ld	a,L13_IRtimeoutcnt
 560  001c a1ff          	cp	a,#255
 561  001e 2404          	jruge	L322
 564  0020 3c0d          	inc	L13_IRtimeoutcnt
 565  0022 b60d          	ld	a,L13_IRtimeoutcnt
 566  0024               L322:
 567                     ; 218     if(IRtimeoutcnt >= IR_TIMEOUT)
 569  0024 a119          	cp	a,#25
 570  0026 2504          	jrult	L522
 571                     ; 220       RC5_rcvstate = RC5_RCV_START;
 573  0028 3f00          	clr	L3_RC5_rcvstate
 574                     ; 221       RC5_rcvsubstate = 0;
 576  002a 3f01          	clr	L5_RC5_rcvsubstate
 577  002c               L522:
 578                     ; 223     if(FLAG_LEDtimeout)
 580  002c b60f          	ld	a,_FLAG_LEDtimeout
 581  002e 2716          	jreq	L722
 582                     ; 225       if(LEDtimeoutcnt < 255) LEDtimeoutcnt++;
 584  0030 b60e          	ld	a,L33_LEDtimeoutcnt
 585  0032 a1ff          	cp	a,#255
 586  0034 2404          	jruge	L132
 589  0036 3c0e          	inc	L33_LEDtimeoutcnt
 590  0038 b60e          	ld	a,L33_LEDtimeoutcnt
 591  003a               L132:
 592                     ; 226       if(LEDtimeoutcnt >= LED_TIMEOUT)
 594  003a a114          	cp	a,#20
 595  003c 2508          	jrult	L722
 596                     ; 228         LED_OFF;
 598  003e 72165005      	bset	20485,#3
 599                     ; 229         LEDtimeoutcnt = 0;
 601  0042 3f0e          	clr	L33_LEDtimeoutcnt
 602                     ; 230         FLAG_LEDtimeout = FALSE;
 604  0044 3f0f          	clr	_FLAG_LEDtimeout
 605  0046               L722:
 606                     ; 233     TIM4_ClearITPendingBit(TIM4_IT_Update);
 608  0046 a601          	ld	a,#1
 609  0048 cd0000        	call	_TIM4_ClearITPendingBit
 611  004b               L122:
 612                     ; 235 }
 615  004b 85            	popw	x
 616  004c bf00          	ldw	c_y,x
 617  004e 320002        	pop	c_y+2
 618  0051 85            	popw	x
 619  0052 bf00          	ldw	c_x,x
 620  0054 320002        	pop	c_x+2
 621  0057 80            	iret	
 643                     ; 242 INTERRUPT_HANDLER_TRAP(TRAP_IRQHandler)
 643                     ; 243 {
 644                     .text:	section	.text,new
 645  0000               f_TRAP_IRQHandler:
 649                     ; 247 }
 652  0000 80            	iret	
 674                     ; 254 INTERRUPT_HANDLER(FLASH_IRQHandler,1)
 674                     ; 255 {
 675                     .text:	section	.text,new
 676  0000               f_FLASH_IRQHandler:
 680                     ; 259 }
 683  0000 80            	iret	
 705                     ; 266 INTERRUPT_HANDLER(AWU_IRQHandler,4)
 705                     ; 267 {
 706                     .text:	section	.text,new
 707  0000               f_AWU_IRQHandler:
 711                     ; 271 }
 714  0000 80            	iret	
 736                     ; 278 INTERRUPT_HANDLER(EXTIB_IRQHandler, 6)
 736                     ; 279 {
 737                     .text:	section	.text,new
 738  0000               f_EXTIB_IRQHandler:
 742                     ; 283 }
 745  0000 80            	iret	
 767                     ; 290 INTERRUPT_HANDLER(EXTID_IRQHandler, 7)
 767                     ; 291 {
 768                     .text:	section	.text,new
 769  0000               f_EXTID_IRQHandler:
 773                     ; 295 }
 776  0000 80            	iret	
 798                     ; 302 INTERRUPT_HANDLER(EXTI0_IRQHandler, 8)
 798                     ; 303 {
 799                     .text:	section	.text,new
 800  0000               f_EXTI0_IRQHandler:
 804                     ; 307 }
 807  0000 80            	iret	
 829                     ; 314 INTERRUPT_HANDLER(EXTI1_IRQHandler, 9)
 829                     ; 315 {
 830                     .text:	section	.text,new
 831  0000               f_EXTI1_IRQHandler:
 835                     ; 319 }
 838  0000 80            	iret	
 860                     ; 326 INTERRUPT_HANDLER(EXTI2_IRQHandler, 10)
 860                     ; 327 {
 861                     .text:	section	.text,new
 862  0000               f_EXTI2_IRQHandler:
 866                     ; 331 }
 869  0000 80            	iret	
 891                     ; 338 INTERRUPT_HANDLER(EXTI3_IRQHandler, 11)
 891                     ; 339 {
 892                     .text:	section	.text,new
 893  0000               f_EXTI3_IRQHandler:
 897                     ; 343 }
 900  0000 80            	iret	
 922                     ; 350 INTERRUPT_HANDLER(EXTI4_IRQHandler, 12)
 922                     ; 351 {
 923                     .text:	section	.text,new
 924  0000               f_EXTI4_IRQHandler:
 928                     ; 355 }
 931  0000 80            	iret	
 953                     ; 362 INTERRUPT_HANDLER(EXTI5_IRQHandler, 13)
 953                     ; 363 {
 954                     .text:	section	.text,new
 955  0000               f_EXTI5_IRQHandler:
 959                     ; 367 }
 962  0000 80            	iret	
 984                     ; 374 INTERRUPT_HANDLER(EXTI6_IRQHandler, 14)
 984                     ; 375 
 984                     ; 376 {
 985                     .text:	section	.text,new
 986  0000               f_EXTI6_IRQHandler:
 990                     ; 380 }
 993  0000 80            	iret	
1015                     ; 387 INTERRUPT_HANDLER(EXTI7_IRQHandler, 15)
1015                     ; 388 {
1016                     .text:	section	.text,new
1017  0000               f_EXTI7_IRQHandler:
1021                     ; 392 }
1024  0000 80            	iret	
1046                     ; 399 INTERRUPT_HANDLER(COMP_IRQHandler, 18)
1046                     ; 400 {
1047                     .text:	section	.text,new
1048  0000               f_COMP_IRQHandler:
1052                     ; 404 }
1055  0000 80            	iret	
1078                     ; 411 INTERRUPT_HANDLER(TIM2_UPD_OVF_TRG_BRK_IRQHandler, 19)
1078                     ; 412 {
1079                     .text:	section	.text,new
1080  0000               f_TIM2_UPD_OVF_TRG_BRK_IRQHandler:
1084                     ; 417 }
1087  0000 80            	iret	
1110                     ; 425 INTERRUPT_HANDLER(TIM3_UPD_OVF_TRG_BRK_IRQHandler, 21)
1110                     ; 426 {
1111                     .text:	section	.text,new
1112  0000               f_TIM3_UPD_OVF_TRG_BRK_IRQHandler:
1116                     ; 430 }
1119  0000 80            	iret	
1142                     ; 436 INTERRUPT_HANDLER(TIM3_CAP_IRQHandler, 22)
1142                     ; 437 {
1143                     .text:	section	.text,new
1144  0000               f_TIM3_CAP_IRQHandler:
1148                     ; 441 }
1151  0000 80            	iret	
1173                     ; 448 INTERRUPT_HANDLER(SPI_IRQHandler, 26)
1173                     ; 449 {
1174                     .text:	section	.text,new
1175  0000               f_SPI_IRQHandler:
1179                     ; 453 }
1182  0000 80            	iret	
1205                     ; 459 INTERRUPT_HANDLER(USART_TX_IRQHandler, 27)
1205                     ; 460 {
1206                     .text:	section	.text,new
1207  0000               f_USART_TX_IRQHandler:
1211                     ; 464 }
1214  0000 80            	iret	
1237                     ; 471 INTERRUPT_HANDLER(USART_RX_IRQHandler, 28)
1237                     ; 472 {
1238                     .text:	section	.text,new
1239  0000               f_USART_RX_IRQHandler:
1243                     ; 476 }
1246  0000 80            	iret	
1268                     ; 484 INTERRUPT_HANDLER(I2C_IRQHandler, 29)
1268                     ; 485 {
1269                     .text:	section	.text,new
1270  0000               f_I2C_IRQHandler:
1274                     ; 489 }
1277  0000 80            	iret	
1567                     	xdef	_Btn_pressed
1568                     	switch	.ubsct
1569  0000               L11_cap_fall:
1570  0000 0000          	ds.b	2
1571  0002               L7_cap_rise:
1572  0002 0000          	ds.b	2
1573                     	xdef	f_I2C_IRQHandler
1574                     	xdef	f_USART_RX_IRQHandler
1575                     	xdef	f_USART_TX_IRQHandler
1576                     	xdef	f_SPI_IRQHandler
1577                     	xdef	f_TIM4_UPD_OVF_IRQHandler
1578                     	xdef	f_TIM3_CAP_IRQHandler
1579                     	xdef	f_TIM3_UPD_OVF_TRG_BRK_IRQHandler
1580                     	xdef	f_TIM2_CAP_IRQHandler
1581                     	xdef	f_TIM2_UPD_OVF_TRG_BRK_IRQHandler
1582                     	xdef	f_COMP_IRQHandler
1583                     	xdef	f_EXTI7_IRQHandler
1584                     	xdef	f_EXTI6_IRQHandler
1585                     	xdef	f_EXTI5_IRQHandler
1586                     	xdef	f_EXTI4_IRQHandler
1587                     	xdef	f_EXTI3_IRQHandler
1588                     	xdef	f_EXTI2_IRQHandler
1589                     	xdef	f_EXTI1_IRQHandler
1590                     	xdef	f_EXTI0_IRQHandler
1591                     	xdef	f_EXTID_IRQHandler
1592                     	xdef	f_EXTIB_IRQHandler
1593                     	xdef	f_AWU_IRQHandler
1594                     	xdef	f_FLASH_IRQHandler
1595                     	xdef	f_TRAP_IRQHandler
1596                     	xdef	f_NonHandledInterrupt
1597                     	xdef	_FLAG_LEDtimeout
1598                     	xdef	_FLAG_new_rc5_frame
1599  0004               _RC5_frame:
1600  0004 0000          	ds.b	2
1601                     	xdef	_RC5_frame
1602                     	xref	_TIM4_ClearITPendingBit
1603                     	xref	_TIM4_GetITStatus
1604                     	xref	_TIM2_ClearITPendingBit
1605                     	xref	_TIM2_GetITStatus
1606                     	xref	_TIM2_GetCapture2
1607                     	xref	_TIM2_GetCapture1
1608                     	xref.b	c_x
1609                     	xref.b	c_y
1629                     	end
