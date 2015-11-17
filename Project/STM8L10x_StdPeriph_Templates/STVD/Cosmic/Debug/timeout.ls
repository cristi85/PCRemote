   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
   4                     ; Optimizer V4.3.6 - 29 Nov 2011
  21                     .bit:	section	.data,bit
  22  0000               _Timeout_istout1:
  23  0000 01            	dc.b	1
  24  0001               _Timeout_istout2:
  25  0001 01            	dc.b	1
  26                     	bsct
  27  0000               _Timeout_toutcnt1:
  28  0000 0000          	dc.w	0
  29  0002               _Timeout_toutcnt2:
  30  0002 0000          	dc.w	0
  31  0004               _Timeout_tout1:
  32  0004 0064          	dc.w	100
  33  0006               _Timeout_tout2:
  34  0006 0064          	dc.w	100
  78                     ; 14 void Timeout_SetTimeout1(u16 time)
  78                     ; 15 {
  80                     .text:	section	.text,new
  81  0000               _Timeout_SetTimeout1:
  85                     ; 16   Timeout_tout1 = time / TMR_REC;
  87  0000 bf04          	ldw	_Timeout_tout1,x
  88                     ; 17   Timeout_toutcnt1 = 0;
  90  0002 5f            	clrw	x
  91  0003 bf00          	ldw	_Timeout_toutcnt1,x
  92                     ; 18   Timeout_istout1 = FALSE;
  94  0005 72110000      	bres	_Timeout_istout1
  95                     ; 19 }
  98  0009 81            	ret	
 123                     ; 21 u16 Timeout_GetTimeout1()
 123                     ; 22 {
 124                     .text:	section	.text,new
 125  0000               _Timeout_GetTimeout1:
 129                     ; 23   return (2*Timeout_toutcnt1);
 131  0000 be00          	ldw	x,_Timeout_toutcnt1
 132  0002 58            	sllw	x
 135  0003 81            	ret	
 160                     ; 26 u16 Timeout_GetTimeout2()
 160                     ; 27 {
 161                     .text:	section	.text,new
 162  0000               _Timeout_GetTimeout2:
 166                     ; 28   return (2*Timeout_toutcnt2);
 168  0000 be02          	ldw	x,_Timeout_toutcnt2
 169  0002 58            	sllw	x
 172  0003 81            	ret	
 197                     ; 31 _Bool Timeout_IsTimeout1()
 197                     ; 32 {
 198                     .text:	section	.text,new
 199  0000               _Timeout_IsTimeout1:
 203                     ; 33   return Timeout_istout1;
 205  0000 7201000003    	btjf	_Timeout_istout1,L41
 206  0005 a601          	ld	a,#1
 208  0007 81            	ret	
 209  0008               L41:
 210  0008 4f            	clr	a
 213  0009 81            	ret	
 251                     ; 36 void Timeout_SetTimeout2(u16 time)
 251                     ; 37 {
 252                     .text:	section	.text,new
 253  0000               _Timeout_SetTimeout2:
 257                     ; 38   Timeout_tout2 = time / TMR_REC;
 259  0000 bf06          	ldw	_Timeout_tout2,x
 260                     ; 39   Timeout_toutcnt2 = 0;
 262  0002 5f            	clrw	x
 263  0003 bf02          	ldw	_Timeout_toutcnt2,x
 264                     ; 40   Timeout_istout2 = FALSE;
 266  0005 72110001      	bres	_Timeout_istout2
 267                     ; 41 }
 270  0009 81            	ret	
 295                     ; 43 _Bool Timeout_IsTimeout2()
 295                     ; 44 {
 296                     .text:	section	.text,new
 297  0000               _Timeout_IsTimeout2:
 301                     ; 45   return Timeout_istout2;
 303  0000 7201000103    	btjf	_Timeout_istout2,L42
 304  0005 a601          	ld	a,#1
 306  0007 81            	ret	
 307  0008               L42:
 308  0008 4f            	clr	a
 311  0009 81            	ret	
 382                     	xdef	_Timeout_IsTimeout2
 383                     	xdef	_Timeout_SetTimeout2
 384                     	xdef	_Timeout_IsTimeout1
 385                     	xdef	_Timeout_GetTimeout2
 386                     	xdef	_Timeout_GetTimeout1
 387                     	xdef	_Timeout_SetTimeout1
 388                     	xdef	_Timeout_tout2
 389                     	xdef	_Timeout_tout1
 390                     	xdef	_Timeout_toutcnt2
 391                     	xdef	_Timeout_toutcnt1
 392                     	xdef	_Timeout_istout2
 393                     	xdef	_Timeout_istout1
 412                     	end
