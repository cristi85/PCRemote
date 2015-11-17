   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.23 - 17 Sep 2014
   3                     ; Generator (Limited) V4.3.13 - 22 Oct 2014
   4                     ; Optimizer V4.3.11 - 22 Oct 2014
  21                     	bsct
  22  0000               L3_FLAG_Battery_Low:
  23  0000 00            	dc.b	0
  59                     .const:	section	.text
  60  0000               L26:
  61  0000 007f          	dc.w	L34
  62  0002 007b          	dc.w	L14
  63  0004 0043          	dc.w	L5
  64  0006 008b          	dc.w	L15
  65  0008 0073          	dc.w	L53
  66  000a 004f          	dc.w	L31
  67  000c 0057          	dc.w	L71
  68  000e 005b          	dc.w	L12
  69  0010 005f          	dc.w	L32
  70  0012 0063          	dc.w	L52
  71  0014 008f          	dc.w	L35
  72  0016 008f          	dc.w	L35
  73  0018 008f          	dc.w	L35
  74  001a 008f          	dc.w	L35
  75  001c 008f          	dc.w	L35
  76  001e 0053          	dc.w	L51
  77  0020 008f          	dc.w	L35
  78  0022 008f          	dc.w	L35
  79  0024 006b          	dc.w	L13
  80  0026 0067          	dc.w	L72
  81                     ; 48 void main(void)
  81                     ; 49 {
  82                     	scross	off
  83                     .text:	section	.text,new
  84  0000               _main:
  88                     ; 50   disableInterrupts();
  91  0000 9b            	sim	
  93                     ; 51   Config();
  96  0001 cd0000        	call	_Config
  98                     ; 52   enableInterrupts();
 101  0004 9a            	rim	
 103                     ; 53   LED_OFF;
 106  0005 72165005      	bset	20485,#3
 107  0009               L37:
 108                     ; 59     if(FLAG_new_rc5_frame)
 110  0009 b600          	ld	a,_FLAG_new_rc5_frame
 111  000b 27fc          	jreq	L37
 112                     ; 61       LED_ON;
 114  000d 72175005      	bres	20485,#3
 115                     ; 62       FLAG_LEDtimeout = TRUE;
 117  0011 35010000      	mov	_FLAG_LEDtimeout,#1
 118                     ; 63       if(RC5_frame.address == 0x0)
 120  0015 b600          	ld	a,_RC5_frame
 121  0017 a57c          	bcp	a,#124
 122  0019 2679          	jrne	L101
 123                     ; 65         switch(RC5_frame.command)
 125  001b b601          	ld	a,_RC5_frame+1
 126  001d a43f          	and	a,#63
 128                     ; 170             break;
 129  001f a00a          	sub	a,#10
 130  0021 a114          	cp	a,#20
 131  0023 2407          	jruge	L06
 132  0025 5f            	clrw	x
 133  0026 97            	ld	xl,a
 134  0027 58            	sllw	x
 135  0028 de0000        	ldw	x,(L26,x)
 136  002b fc            	jp	(x)
 137  002c               L06:
 138  002c a01f          	sub	a,#31
 139  002e 2747          	jreq	L73
 140  0030 4a            	dec	a
 141  0031 2750          	jreq	L54
 142  0033 4a            	dec	a
 143  0034 2739          	jreq	L33
 144  0036 a003          	sub	a,#3
 145  0038 274d          	jreq	L74
 146  003a a00a          	sub	a,#10
 147  003c 270d          	jreq	L11
 148  003e 4a            	dec	a
 149  003f 2706          	jreq	L7
 150  0041 204c          	jra	L35
 151  0043               L5:
 152                     ; 69             USART_SendData8('A');
 154  0043 a641          	ld	a,#65
 156                     ; 70             break;
 158  0045 204a          	jp	LC001
 159  0047               L7:
 160                     ; 75             USART_SendData8('B');
 162  0047 a642          	ld	a,#66
 164                     ; 76             break;
 166  0049 2046          	jp	LC001
 167  004b               L11:
 168                     ; 80             USART_SendData8('b');
 170  004b a662          	ld	a,#98
 172                     ; 81             break;
 174  004d 2042          	jp	LC001
 175  004f               L31:
 176                     ; 85             USART_SendData8('C');
 178  004f a643          	ld	a,#67
 180                     ; 86             break;
 182  0051 203e          	jp	LC001
 183  0053               L51:
 184                     ; 90             USART_SendData8('D');
 186  0053 a644          	ld	a,#68
 188                     ; 91             break;
 190  0055 203a          	jp	LC001
 191  0057               L71:
 192                     ; 95             USART_SendData8('E');
 194  0057 a645          	ld	a,#69
 196                     ; 96             break;
 198  0059 2036          	jp	LC001
 199  005b               L12:
 200                     ; 100             USART_SendData8('e');
 202  005b a665          	ld	a,#101
 204                     ; 101             break;
 206  005d 2032          	jp	LC001
 207  005f               L32:
 208                     ; 105             USART_SendData8('F');
 210  005f a646          	ld	a,#70
 212                     ; 106             break;
 214  0061 202e          	jp	LC001
 215  0063               L52:
 216                     ; 110             USART_SendData8('f');
 218  0063 a666          	ld	a,#102
 220                     ; 111             break;
 222  0065 202a          	jp	LC001
 223  0067               L72:
 224                     ; 115             USART_SendData8('G');
 226  0067 a647          	ld	a,#71
 228                     ; 116             break;
 230  0069 2026          	jp	LC001
 231  006b               L13:
 232                     ; 120             USART_SendData8('g');
 234  006b a667          	ld	a,#103
 236                     ; 121             break;
 238  006d 2022          	jp	LC001
 239  006f               L33:
 240                     ; 128             USART_SendData8('H');
 242  006f a648          	ld	a,#72
 244                     ; 129             break;
 246  0071 201e          	jp	LC001
 247  0073               L53:
 248                     ; 133             USART_SendData8('h');
 250  0073 a668          	ld	a,#104
 252                     ; 134             break;
 254  0075 201a          	jp	LC001
 255  0077               L73:
 256                     ; 138             USART_SendData8('I');
 258  0077 a649          	ld	a,#73
 260                     ; 139             break;
 262  0079 2016          	jp	LC001
 263  007b               L14:
 264                     ; 143             USART_SendData8('j');
 266  007b a66a          	ld	a,#106
 268                     ; 144             break;
 270  007d 2012          	jp	LC001
 271  007f               L34:
 272                     ; 148             USART_SendData8('J');
 274  007f a64a          	ld	a,#74
 276                     ; 149             break;
 278  0081 200e          	jp	LC001
 279  0083               L54:
 280                     ; 153             USART_SendData8('K');
 282  0083 a64b          	ld	a,#75
 284                     ; 154             break;
 286  0085 200a          	jp	LC001
 287  0087               L74:
 288                     ; 158             USART_SendData8('k');
 290  0087 a66b          	ld	a,#107
 292                     ; 159             break;
 294  0089 2006          	jp	LC001
 295  008b               L15:
 296                     ; 163             USART_SendData8('L');
 298  008b a64c          	ld	a,#76
 300                     ; 164             break;
 302  008d 2002          	jp	LC001
 303  008f               L35:
 304                     ; 169             USART_SendData8('X');  // unassigned command
 306  008f a658          	ld	a,#88
 307  0091               LC001:
 308  0091 cd0000        	call	_USART_SendData8
 310                     ; 170             break;
 312  0094               L101:
 313                     ; 174       FLAG_new_rc5_frame = FALSE;
 315  0094 3f00          	clr	_FLAG_new_rc5_frame
 316  0096 cc0009        	jra	L37
 361                     	xdef	_main
 362                     	xref.b	_FLAG_LEDtimeout
 363                     	xref.b	_FLAG_new_rc5_frame
 364                     	xref.b	_RC5_frame
 365                     	xref	_Config
 366                     	xref	_USART_SendData8
 385                     	end
