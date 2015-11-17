   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
   4                     ; Optimizer V4.3.6 - 29 Nov 2011
  52                     ; 23 void nrf24_init() 
  52                     ; 24 {
  54                     .text:	section	.text,new
  55  0000               _nrf24_init:
  59                     ; 25   nrf24_setupPins();
  61  0000 cd0000        	call	_nrf24_setupPins
  63                     ; 26   nrf24_ce_digitalWrite(LOW);
  65  0003 4f            	clr	a
  66  0004 cd0000        	call	_nrf24_ce_digitalWrite
  68                     ; 27   nrf24_csn_digitalWrite(HIGH);    
  70  0007 a601          	ld	a,#1
  72                     ; 28 }
  75  0009 cc0000        	jp	_nrf24_csn_digitalWrite
 142                     ; 31 void nrf24_config(uint8_t channel, uint8_t pay_length)
 142                     ; 32 {
 143                     .text:	section	.text,new
 144  0000               _nrf24_config:
 146  0000 89            	pushw	x
 147  0001 89            	pushw	x
 148       00000002      OFST:	set	2
 151                     ; 35   payload_len = pay_length;
 153  0002 9f            	ld	a,xl
 154  0003 b700          	ld	_payload_len,a
 155                     ; 37   Errors_ResetError(ERROR_NRF24_INIT);
 157  0005 a601          	ld	a,#1
 158  0007 cd0000        	call	_Errors_ResetError
 160                     ; 40   nrf24_configRegister(RF_CH,channel);
 162  000a 7b03          	ld	a,(OFST+1,sp)
 163  000c 97            	ld	xl,a
 164  000d a605          	ld	a,#5
 165  000f 95            	ld	xh,a
 166  0010 cd0000        	call	_nrf24_configRegister
 168                     ; 41   nrf24_readRegister(RF_CH, &rcv, 1);
 170  0013 4b01          	push	#1
 171  0015 96            	ldw	x,sp
 172  0016 1c0003        	addw	x,#OFST+1
 173  0019 89            	pushw	x
 174  001a a605          	ld	a,#5
 175  001c cd0000        	call	_nrf24_readRegister
 177  001f 5b03          	addw	sp,#3
 178                     ; 42   if(rcv != channel)
 180  0021 7b02          	ld	a,(OFST+0,sp)
 181  0023 1103          	cp	a,(OFST+1,sp)
 182  0025 2705          	jreq	L35
 183                     ; 44     Errors_SetError(ERROR_NRF24_INIT);
 185  0027 a601          	ld	a,#1
 186  0029 cd0000        	call	_Errors_SetError
 188  002c               L35:
 189                     ; 48   nrf24_configRegister(RX_PW_P0, 0x00); // Auto-ACK pipe ...
 191  002c ae1100        	ldw	x,#4352
 192  002f cd0000        	call	_nrf24_configRegister
 194                     ; 49   nrf24_readRegister(RX_PW_P0, &rcv, 1);
 196  0032 4b01          	push	#1
 197  0034 96            	ldw	x,sp
 198  0035 1c0003        	addw	x,#OFST+1
 199  0038 89            	pushw	x
 200  0039 a611          	ld	a,#17
 201  003b cd0000        	call	_nrf24_readRegister
 203  003e 5b03          	addw	sp,#3
 204                     ; 50   if(rcv != 0x00)
 206  0040 7b02          	ld	a,(OFST+0,sp)
 207  0042 2705          	jreq	L55
 208                     ; 52     Errors_SetError(ERROR_NRF24_INIT);
 210  0044 a601          	ld	a,#1
 211  0046 cd0000        	call	_Errors_SetError
 213  0049               L55:
 214                     ; 55   nrf24_configRegister(RX_PW_P1, payload_len); // Data payload pipe
 216  0049 b600          	ld	a,_payload_len
 217  004b 97            	ld	xl,a
 218  004c a612          	ld	a,#18
 219  004e 95            	ld	xh,a
 220  004f cd0000        	call	_nrf24_configRegister
 222                     ; 56   nrf24_readRegister(RX_PW_P1, &rcv, 1);
 224  0052 4b01          	push	#1
 225  0054 96            	ldw	x,sp
 226  0055 1c0003        	addw	x,#OFST+1
 227  0058 89            	pushw	x
 228  0059 a612          	ld	a,#18
 229  005b cd0000        	call	_nrf24_readRegister
 231  005e 5b03          	addw	sp,#3
 232                     ; 57   if(rcv != payload_len)
 234  0060 7b02          	ld	a,(OFST+0,sp)
 235  0062 b100          	cp	a,_payload_len
 236  0064 2705          	jreq	L75
 237                     ; 59     Errors_SetError(ERROR_NRF24_INIT);
 239  0066 a601          	ld	a,#1
 240  0068 cd0000        	call	_Errors_SetError
 242  006b               L75:
 243                     ; 62   nrf24_configRegister(RX_PW_P2, 0x00); // Pipe not used 
 245  006b ae1300        	ldw	x,#4864
 246  006e cd0000        	call	_nrf24_configRegister
 248                     ; 63   nrf24_readRegister(RX_PW_P2, &rcv, 1);
 250  0071 4b01          	push	#1
 251  0073 96            	ldw	x,sp
 252  0074 1c0003        	addw	x,#OFST+1
 253  0077 89            	pushw	x
 254  0078 a613          	ld	a,#19
 255  007a cd0000        	call	_nrf24_readRegister
 257  007d 5b03          	addw	sp,#3
 258                     ; 64   if(rcv != 0x00)
 260  007f 7b02          	ld	a,(OFST+0,sp)
 261  0081 2705          	jreq	L16
 262                     ; 66     Errors_SetError(ERROR_NRF24_INIT);
 264  0083 a601          	ld	a,#1
 265  0085 cd0000        	call	_Errors_SetError
 267  0088               L16:
 268                     ; 69   nrf24_configRegister(RX_PW_P3, 0x00); // Pipe not used 
 270  0088 ae1400        	ldw	x,#5120
 271  008b cd0000        	call	_nrf24_configRegister
 273                     ; 70   nrf24_readRegister(RX_PW_P3, &rcv, 1);
 275  008e 4b01          	push	#1
 276  0090 96            	ldw	x,sp
 277  0091 1c0003        	addw	x,#OFST+1
 278  0094 89            	pushw	x
 279  0095 a614          	ld	a,#20
 280  0097 cd0000        	call	_nrf24_readRegister
 282  009a 5b03          	addw	sp,#3
 283                     ; 71   if(rcv != 0x00)
 285  009c 7b02          	ld	a,(OFST+0,sp)
 286  009e 2705          	jreq	L36
 287                     ; 73     Errors_SetError(ERROR_NRF24_INIT);
 289  00a0 a601          	ld	a,#1
 290  00a2 cd0000        	call	_Errors_SetError
 292  00a5               L36:
 293                     ; 76   nrf24_configRegister(RX_PW_P4, 0x00); // Pipe not used 
 295  00a5 ae1500        	ldw	x,#5376
 296  00a8 cd0000        	call	_nrf24_configRegister
 298                     ; 77   nrf24_readRegister(RX_PW_P4, &rcv, 1);
 300  00ab 4b01          	push	#1
 301  00ad 96            	ldw	x,sp
 302  00ae 1c0003        	addw	x,#OFST+1
 303  00b1 89            	pushw	x
 304  00b2 a615          	ld	a,#21
 305  00b4 cd0000        	call	_nrf24_readRegister
 307  00b7 5b03          	addw	sp,#3
 308                     ; 78   if(rcv != 0x00)
 310  00b9 7b02          	ld	a,(OFST+0,sp)
 311  00bb 2705          	jreq	L56
 312                     ; 80     Errors_SetError(ERROR_NRF24_INIT);
 314  00bd a601          	ld	a,#1
 315  00bf cd0000        	call	_Errors_SetError
 317  00c2               L56:
 318                     ; 83   nrf24_configRegister(RX_PW_P5, 0x00); // Pipe not used 
 320  00c2 ae1600        	ldw	x,#5632
 321  00c5 cd0000        	call	_nrf24_configRegister
 323                     ; 84   nrf24_readRegister(RX_PW_P5, &rcv, 1);
 325  00c8 4b01          	push	#1
 326  00ca 96            	ldw	x,sp
 327  00cb 1c0003        	addw	x,#OFST+1
 328  00ce 89            	pushw	x
 329  00cf a616          	ld	a,#22
 330  00d1 cd0000        	call	_nrf24_readRegister
 332  00d4 5b03          	addw	sp,#3
 333                     ; 85   if(rcv != 0x00)
 335  00d6 7b02          	ld	a,(OFST+0,sp)
 336  00d8 2705          	jreq	L76
 337                     ; 87     Errors_SetError(ERROR_NRF24_INIT);
 339  00da a601          	ld	a,#1
 340  00dc cd0000        	call	_Errors_SetError
 342  00df               L76:
 343                     ; 92   send = (1<<RF_DR_LOW)|((3)<<RF_PWR);
 345  00df a626          	ld	a,#38
 346  00e1 6b01          	ld	(OFST-1,sp),a
 347                     ; 93   nrf24_configRegister(RF_SETUP, send);
 349  00e3 ae0626        	ldw	x,#1574
 350  00e6 cd0000        	call	_nrf24_configRegister
 352                     ; 94   nrf24_readRegister(RF_SETUP, &rcv, 1);
 354  00e9 4b01          	push	#1
 355  00eb 96            	ldw	x,sp
 356  00ec 1c0003        	addw	x,#OFST+1
 357  00ef 89            	pushw	x
 358  00f0 a606          	ld	a,#6
 359  00f2 cd0000        	call	_nrf24_readRegister
 361  00f5 5b03          	addw	sp,#3
 362                     ; 95   if(rcv != send)
 364  00f7 7b02          	ld	a,(OFST+0,sp)
 365  00f9 1101          	cp	a,(OFST-1,sp)
 366  00fb 2705          	jreq	L17
 367                     ; 97     Errors_SetError(ERROR_NRF24_INIT);
 369  00fd a601          	ld	a,#1
 370  00ff cd0000        	call	_Errors_SetError
 372  0102               L17:
 373                     ; 101   send = nrf24_CONFIG;
 375  0102 a638          	ld	a,#56
 376  0104 6b01          	ld	(OFST-1,sp),a
 377                     ; 102   nrf24_configRegister(CONFIG, send);
 379  0106 ae0038        	ldw	x,#56
 380  0109 cd0000        	call	_nrf24_configRegister
 382                     ; 103   nrf24_readRegister(CONFIG, &rcv, 1);
 384  010c 4b01          	push	#1
 385  010e 96            	ldw	x,sp
 386  010f 1c0003        	addw	x,#OFST+1
 387  0112 89            	pushw	x
 388  0113 4f            	clr	a
 389  0114 cd0000        	call	_nrf24_readRegister
 391  0117 5b03          	addw	sp,#3
 392                     ; 104   if(rcv != send)
 394  0119 7b02          	ld	a,(OFST+0,sp)
 395  011b 1101          	cp	a,(OFST-1,sp)
 396  011d 2705          	jreq	L37
 397                     ; 106     Errors_SetError(ERROR_NRF24_INIT);
 399  011f a601          	ld	a,#1
 400  0121 cd0000        	call	_Errors_SetError
 402  0124               L37:
 403                     ; 110   send = (1<<ENAA_P0)|(1<<ENAA_P1)|(0<<ENAA_P2)|(0<<ENAA_P3)|(0<<ENAA_P4)|(0<<ENAA_P5);
 405  0124 a603          	ld	a,#3
 406  0126 6b01          	ld	(OFST-1,sp),a
 407                     ; 111   nrf24_configRegister(EN_AA, send);
 409  0128 ae0103        	ldw	x,#259
 410  012b cd0000        	call	_nrf24_configRegister
 412                     ; 112   nrf24_readRegister(EN_AA, &rcv, 1);
 414  012e 4b01          	push	#1
 415  0130 96            	ldw	x,sp
 416  0131 1c0003        	addw	x,#OFST+1
 417  0134 89            	pushw	x
 418  0135 a601          	ld	a,#1
 419  0137 cd0000        	call	_nrf24_readRegister
 421  013a 5b03          	addw	sp,#3
 422                     ; 113   if(rcv != send)
 424  013c 7b02          	ld	a,(OFST+0,sp)
 425  013e 1101          	cp	a,(OFST-1,sp)
 426  0140 2705          	jreq	L57
 427                     ; 115     Errors_SetError(ERROR_NRF24_INIT);
 429  0142 a601          	ld	a,#1
 430  0144 cd0000        	call	_Errors_SetError
 432  0147               L57:
 433                     ; 119   send = (1<<ERX_P0)|(1<<ERX_P1)|(0<<ERX_P2)|(0<<ERX_P3)|(0<<ERX_P4)|(0<<ERX_P5);
 435  0147 a603          	ld	a,#3
 436  0149 6b01          	ld	(OFST-1,sp),a
 437                     ; 120   nrf24_configRegister(EN_RXADDR, send);
 439  014b ae0203        	ldw	x,#515
 440  014e cd0000        	call	_nrf24_configRegister
 442                     ; 121   nrf24_readRegister(EN_RXADDR, &rcv, 1);
 444  0151 4b01          	push	#1
 445  0153 96            	ldw	x,sp
 446  0154 1c0003        	addw	x,#OFST+1
 447  0157 89            	pushw	x
 448  0158 a602          	ld	a,#2
 449  015a cd0000        	call	_nrf24_readRegister
 451  015d 5b03          	addw	sp,#3
 452                     ; 122   if(rcv != send)
 454  015f 7b02          	ld	a,(OFST+0,sp)
 455  0161 1101          	cp	a,(OFST-1,sp)
 456  0163 2705          	jreq	L77
 457                     ; 124     Errors_SetError(ERROR_NRF24_INIT);
 459  0165 a601          	ld	a,#1
 460  0167 cd0000        	call	_Errors_SetError
 462  016a               L77:
 463                     ; 128   send = (0x04<<ARD)|(0x0F<<ARC);
 465  016a a64f          	ld	a,#79
 466  016c 6b01          	ld	(OFST-1,sp),a
 467                     ; 129   nrf24_configRegister(SETUP_RETR, send);
 469  016e ae044f        	ldw	x,#1103
 470  0171 cd0000        	call	_nrf24_configRegister
 472                     ; 130   nrf24_readRegister(SETUP_RETR, &rcv, 1);
 474  0174 4b01          	push	#1
 475  0176 96            	ldw	x,sp
 476  0177 1c0003        	addw	x,#OFST+1
 477  017a 89            	pushw	x
 478  017b a604          	ld	a,#4
 479  017d cd0000        	call	_nrf24_readRegister
 481  0180 5b03          	addw	sp,#3
 482                     ; 131   if(rcv != send)
 484  0182 7b02          	ld	a,(OFST+0,sp)
 485  0184 1101          	cp	a,(OFST-1,sp)
 486  0186 2705          	jreq	L101
 487                     ; 133     Errors_SetError(ERROR_NRF24_INIT);
 489  0188 a601          	ld	a,#1
 490  018a cd0000        	call	_Errors_SetError
 492  018d               L101:
 493                     ; 137   send = (0<<DPL_P0)|(0<<DPL_P1)|(0<<DPL_P2)|(0<<DPL_P3)|(0<<DPL_P4)|(0<<DPL_P5);
 495  018d 0f01          	clr	(OFST-1,sp)
 496                     ; 138   nrf24_configRegister(DYNPD, send);
 498  018f ae1c00        	ldw	x,#7168
 499  0192 cd0000        	call	_nrf24_configRegister
 501                     ; 139   nrf24_readRegister(DYNPD, &rcv, 1);
 503  0195 4b01          	push	#1
 504  0197 96            	ldw	x,sp
 505  0198 1c0003        	addw	x,#OFST+1
 506  019b 89            	pushw	x
 507  019c a61c          	ld	a,#28
 508  019e cd0000        	call	_nrf24_readRegister
 510  01a1 5b03          	addw	sp,#3
 511                     ; 140   if(rcv != send)
 513  01a3 7b02          	ld	a,(OFST+0,sp)
 514  01a5 1101          	cp	a,(OFST-1,sp)
 515  01a7 2705          	jreq	L301
 516                     ; 142     Errors_SetError(ERROR_NRF24_INIT);
 518  01a9 a601          	ld	a,#1
 519  01ab cd0000        	call	_Errors_SetError
 521  01ae               L301:
 522                     ; 146   nrf24_powerUpRx();
 524  01ae cd0000        	call	_nrf24_powerUpRx
 526                     ; 147 }
 529  01b1 5b04          	addw	sp,#4
 530  01b3 81            	ret	
 567                     ; 150 void nrf24_rx_address(uint8_t * adr) 
 567                     ; 151 {
 568                     .text:	section	.text,new
 569  0000               _nrf24_rx_address:
 571  0000 89            	pushw	x
 572       00000000      OFST:	set	0
 575                     ; 152     nrf24_ce_digitalWrite(LOW);
 577  0001 4f            	clr	a
 578  0002 cd0000        	call	_nrf24_ce_digitalWrite
 580                     ; 153     nrf24_writeRegister(RX_ADDR_P1,adr,nrf24_ADDR_LEN);
 582  0005 4b05          	push	#5
 583  0007 1e02          	ldw	x,(OFST+2,sp)
 584  0009 89            	pushw	x
 585  000a a60b          	ld	a,#11
 586  000c cd0000        	call	_nrf24_writeRegister
 588  000f 5b03          	addw	sp,#3
 589                     ; 154     nrf24_ce_digitalWrite(HIGH);
 591  0011 a601          	ld	a,#1
 592  0013 cd0000        	call	_nrf24_ce_digitalWrite
 594                     ; 155 }
 597  0016 85            	popw	x
 598  0017 81            	ret	
 623                     ; 158 uint8_t nrf24_payload_length()
 623                     ; 159 {
 624                     .text:	section	.text,new
 625  0000               _nrf24_payload_length:
 629                     ; 160     return payload_len;
 631  0000 b600          	ld	a,_payload_len
 634  0002 81            	ret	
 670                     ; 164 void nrf24_tx_address(uint8_t* adr)
 670                     ; 165 {
 671                     .text:	section	.text,new
 672  0000               _nrf24_tx_address:
 674  0000 89            	pushw	x
 675       00000000      OFST:	set	0
 678                     ; 167     nrf24_writeRegister(RX_ADDR_P0,adr,nrf24_ADDR_LEN);
 680  0001 4b05          	push	#5
 681  0003 89            	pushw	x
 682  0004 a60a          	ld	a,#10
 683  0006 cd0000        	call	_nrf24_writeRegister
 685  0009 5b03          	addw	sp,#3
 686                     ; 168     nrf24_writeRegister(TX_ADDR,adr,nrf24_ADDR_LEN);
 688  000b 4b05          	push	#5
 689  000d 1e02          	ldw	x,(OFST+2,sp)
 690  000f 89            	pushw	x
 691  0010 a610          	ld	a,#16
 692  0012 cd0000        	call	_nrf24_writeRegister
 694  0015 5b03          	addw	sp,#3
 695                     ; 169 }
 698  0017 85            	popw	x
 699  0018 81            	ret	
 735                     ; 173 uint8_t nrf24_dataReady() 
 735                     ; 174 {
 736                     .text:	section	.text,new
 737  0000               _nrf24_dataReady:
 739  0000 88            	push	a
 740       00000001      OFST:	set	1
 743                     ; 176     uint8_t status = nrf24_getStatus();
 745  0001 cd0000        	call	_nrf24_getStatus
 747  0004 6b01          	ld	(OFST+0,sp),a
 748                     ; 180     if ( status & (1 << RX_DR) ) 
 750  0006 a540          	bcp	a,#64
 751  0008 2705          	jreq	L761
 752                     ; 182         return 1;
 754  000a a601          	ld	a,#1
 757  000c 5b01          	addw	sp,#1
 758  000e 81            	ret	
 759  000f               L761:
 760                     ; 185     return !nrf24_rxFifoEmpty();;
 762  000f cd0000        	call	_nrf24_rxFifoEmpty
 764  0012 4d            	tnz	a
 765  0013 2603          	jrne	L461
 766  0015 4c            	inc	a
 767  0016 2001          	jra	L071
 768  0018               L461:
 769  0018 4f            	clr	a
 770  0019               L071:
 773  0019 5b01          	addw	sp,#1
 774  001b 81            	ret	
 809                     ; 189 uint8_t nrf24_rxFifoEmpty()
 809                     ; 190 {
 810                     .text:	section	.text,new
 811  0000               _nrf24_rxFifoEmpty:
 813  0000 88            	push	a
 814       00000001      OFST:	set	1
 817                     ; 193     nrf24_readRegister(FIFO_STATUS,&fifoStatus,1);
 819  0001 4b01          	push	#1
 820  0003 96            	ldw	x,sp
 821  0004 1c0002        	addw	x,#OFST+1
 822  0007 89            	pushw	x
 823  0008 a617          	ld	a,#23
 824  000a cd0000        	call	_nrf24_readRegister
 826  000d 5b03          	addw	sp,#3
 827                     ; 195     return (fifoStatus & (1 << RX_EMPTY));
 829  000f 7b01          	ld	a,(OFST+0,sp)
 830  0011 a401          	and	a,#1
 833  0013 5b01          	addw	sp,#1
 834  0015 81            	ret	
 871                     ; 199 uint8_t nrf24_payloadLength()
 871                     ; 200 {
 872                     .text:	section	.text,new
 873  0000               _nrf24_payloadLength:
 875  0000 88            	push	a
 876       00000001      OFST:	set	1
 879                     ; 202     nrf24_csn_digitalWrite(LOW);
 881  0001 4f            	clr	a
 882  0002 cd0000        	call	_nrf24_csn_digitalWrite
 884                     ; 203     spi_transfer(R_RX_PL_WID);
 886  0005 a660          	ld	a,#96
 887  0007 cd0000        	call	_spi_transfer
 889                     ; 204     status = spi_transfer(0x00);
 891  000a 4f            	clr	a
 892  000b cd0000        	call	_spi_transfer
 894  000e 6b01          	ld	(OFST+0,sp),a
 895                     ; 205     nrf24_csn_digitalWrite(HIGH);
 897  0010 a601          	ld	a,#1
 898  0012 cd0000        	call	_nrf24_csn_digitalWrite
 900                     ; 206     return status;
 902  0015 7b01          	ld	a,(OFST+0,sp)
 905  0017 5b01          	addw	sp,#1
 906  0019 81            	ret	
 966                     ; 210 void nrf24_getData(uint8_t* data) 
 966                     ; 211 {
 967                     .text:	section	.text,new
 968  0000               _nrf24_getData:
 970  0000 89            	pushw	x
 971  0001 89            	pushw	x
 972       00000002      OFST:	set	2
 975                     ; 214   nrf24_csn_digitalWrite(LOW);                               
 977  0002 4f            	clr	a
 978  0003 cd0000        	call	_nrf24_csn_digitalWrite
 980                     ; 217   spi_transfer( R_RX_PAYLOAD );
 982  0006 a661          	ld	a,#97
 983  0008 cd0000        	call	_spi_transfer
 985                     ; 220   nrf24_transferSync(data,data,payload_len);
 987  000b 3b0000        	push	_payload_len
 988  000e 1e04          	ldw	x,(OFST+2,sp)
 989  0010 89            	pushw	x
 990  0011 1e06          	ldw	x,(OFST+4,sp)
 991  0013 cd0000        	call	_nrf24_transferSync
 993  0016 5b03          	addw	sp,#3
 994                     ; 223   nrf24_csn_digitalWrite(HIGH);
 996  0018 a601          	ld	a,#1
 997  001a cd0000        	call	_nrf24_csn_digitalWrite
 999                     ; 226   nrf24_readRegister(STATUS, &send, 1);
1001  001d 4b01          	push	#1
1002  001f 96            	ldw	x,sp
1003  0020 1c0002        	addw	x,#OFST+0
1004  0023 89            	pushw	x
1005  0024 a607          	ld	a,#7
1006  0026 cd0000        	call	_nrf24_readRegister
1008  0029 5b03          	addw	sp,#3
1009                     ; 227   nrf24_configRegister(STATUS,(1<<RX_DR));
1011  002b ae0740        	ldw	x,#1856
1012  002e cd0000        	call	_nrf24_configRegister
1014                     ; 228   nrf24_readRegister(STATUS, &rcv, 1);
1016  0031 4b01          	push	#1
1017  0033 96            	ldw	x,sp
1018  0034 1c0003        	addw	x,#OFST+1
1019  0037 89            	pushw	x
1020  0038 a607          	ld	a,#7
1021  003a cd0000        	call	_nrf24_readRegister
1023  003d 5b03          	addw	sp,#3
1024                     ; 229   if(rcv & (1<<RX_DR))
1026  003f 7b02          	ld	a,(OFST+0,sp)
1027  0041 a540          	bcp	a,#64
1028  0043 2705          	jreq	L352
1029                     ; 231     Errors_SetError(ERROR_NRF24_COMM);
1031  0045 a602          	ld	a,#2
1032  0047 cd0000        	call	_Errors_SetError
1034  004a               L352:
1035                     ; 233 }
1038  004a 5b04          	addw	sp,#4
1039  004c 81            	ret	
1075                     ; 236 uint8_t nrf24_retransmissionCount()
1075                     ; 237 {
1076                     .text:	section	.text,new
1077  0000               _nrf24_retransmissionCount:
1079  0000 88            	push	a
1080       00000001      OFST:	set	1
1083                     ; 239     nrf24_readRegister(OBSERVE_TX,&rv,1);
1085  0001 4b01          	push	#1
1086  0003 96            	ldw	x,sp
1087  0004 1c0002        	addw	x,#OFST+1
1088  0007 89            	pushw	x
1089  0008 a608          	ld	a,#8
1090  000a cd0000        	call	_nrf24_readRegister
1092  000d 5b03          	addw	sp,#3
1093                     ; 240     rv = rv & 0x0F;
1095  000f 7b01          	ld	a,(OFST+0,sp)
1096  0011 a40f          	and	a,#15
1097                     ; 241     return rv;
1101  0013 5b01          	addw	sp,#1
1102  0015 81            	ret	
1143                     ; 246 void nrf24_send(uint8_t* value) 
1143                     ; 247 {    
1144                     .text:	section	.text,new
1145  0000               _nrf24_send:
1147  0000 89            	pushw	x
1148       00000000      OFST:	set	0
1151                     ; 249     nrf24_ce_digitalWrite(LOW);
1153  0001 4f            	clr	a
1154  0002 cd0000        	call	_nrf24_ce_digitalWrite
1156                     ; 252     nrf24_powerUpTx();
1158  0005 cd0000        	call	_nrf24_powerUpTx
1160                     ; 257         nrf24_csn_digitalWrite(LOW);           
1162  0008 4f            	clr	a
1163  0009 cd0000        	call	_nrf24_csn_digitalWrite
1165                     ; 260         spi_transfer(FLUSH_TX);     
1167  000c a6e1          	ld	a,#225
1168  000e cd0000        	call	_spi_transfer
1170                     ; 263         nrf24_csn_digitalWrite(HIGH);                    
1172  0011 a601          	ld	a,#1
1173  0013 cd0000        	call	_nrf24_csn_digitalWrite
1175                     ; 267     nrf24_csn_digitalWrite(LOW);
1177  0016 4f            	clr	a
1178  0017 cd0000        	call	_nrf24_csn_digitalWrite
1180                     ; 270     spi_transfer(W_TX_PAYLOAD);
1182  001a a6a0          	ld	a,#160
1183  001c cd0000        	call	_spi_transfer
1185                     ; 273     nrf24_transmitSync(value,payload_len);   
1187  001f 3b0000        	push	_payload_len
1188  0022 1e02          	ldw	x,(OFST+2,sp)
1189  0024 cd0000        	call	_nrf24_transmitSync
1191  0027 84            	pop	a
1192                     ; 276     nrf24_csn_digitalWrite(HIGH);
1194  0028 a601          	ld	a,#1
1195  002a cd0000        	call	_nrf24_csn_digitalWrite
1197                     ; 279     nrf24_ce_digitalWrite(HIGH);    
1199  002d a601          	ld	a,#1
1200  002f cd0000        	call	_nrf24_ce_digitalWrite
1202                     ; 280 }
1205  0032 85            	popw	x
1206  0033 81            	ret	
1241                     ; 282 uint8_t nrf24_isSending()
1241                     ; 283 {
1242                     .text:	section	.text,new
1243  0000               _nrf24_isSending:
1245  0000 88            	push	a
1246       00000001      OFST:	set	1
1249                     ; 287     status = nrf24_getStatus();
1251  0001 cd0000        	call	_nrf24_getStatus
1253  0004 6b01          	ld	(OFST+0,sp),a
1254                     ; 290     if((status & ((1 << TX_DS)  | (1 << MAX_RT))))
1256  0006 a530          	bcp	a,#48
1257  0008 2704          	jreq	L723
1258                     ; 292         return 0; /* false */
1260  000a 4f            	clr	a
1263  000b 5b01          	addw	sp,#1
1264  000d 81            	ret	
1265  000e               L723:
1266                     ; 295     return 1; /* true */
1268  000e a601          	ld	a,#1
1271  0010 5b01          	addw	sp,#1
1272  0012 81            	ret	
1308                     ; 299 uint8_t nrf24_getStatus()
1308                     ; 300 {
1309                     .text:	section	.text,new
1310  0000               _nrf24_getStatus:
1312  0000 88            	push	a
1313       00000001      OFST:	set	1
1316                     ; 302     nrf24_csn_digitalWrite(LOW);
1318  0001 4f            	clr	a
1319  0002 cd0000        	call	_nrf24_csn_digitalWrite
1321                     ; 303     rv = spi_transfer(NOP);
1323  0005 a6ff          	ld	a,#255
1324  0007 cd0000        	call	_spi_transfer
1326  000a 6b01          	ld	(OFST+0,sp),a
1327                     ; 304     nrf24_csn_digitalWrite(HIGH);
1329  000c a601          	ld	a,#1
1330  000e cd0000        	call	_nrf24_csn_digitalWrite
1332                     ; 305     return rv;
1334  0011 7b01          	ld	a,(OFST+0,sp)
1337  0013 5b01          	addw	sp,#1
1338  0015 81            	ret	
1374                     ; 308 uint8_t nrf24_lastMessageStatus()
1374                     ; 309 {
1375                     .text:	section	.text,new
1376  0000               _nrf24_lastMessageStatus:
1378  0000 88            	push	a
1379       00000001      OFST:	set	1
1382                     ; 312     rv = nrf24_getStatus();
1384  0001 cd0000        	call	_nrf24_getStatus
1386  0004 6b01          	ld	(OFST+0,sp),a
1387                     ; 315     if((rv & ((1 << TX_DS))))
1389  0006 a520          	bcp	a,#32
1390  0008 2704          	jreq	L563
1391                     ; 317         return NRF24_TRANSMISSON_OK;
1393  000a 4f            	clr	a
1396  000b 5b01          	addw	sp,#1
1397  000d 81            	ret	
1398  000e               L563:
1399                     ; 321     else if((rv & ((1 << MAX_RT))))
1401  000e a510          	bcp	a,#16
1402  0010 2705          	jreq	L173
1403                     ; 323         return NRF24_MESSAGE_LOST;
1405  0012 a601          	ld	a,#1
1408  0014 5b01          	addw	sp,#1
1409  0016 81            	ret	
1410  0017               L173:
1411                     ; 328         return 0xFF;
1413  0017 a6ff          	ld	a,#255
1416  0019 5b01          	addw	sp,#1
1417  001b 81            	ret	
1466                     ; 332 void nrf24_powerUpRx()
1466                     ; 333 {     
1467                     .text:	section	.text,new
1468  0000               _nrf24_powerUpRx:
1470  0000 89            	pushw	x
1471       00000002      OFST:	set	2
1474                     ; 335     nrf24_csn_digitalWrite(LOW);
1476  0001 4f            	clr	a
1477  0002 cd0000        	call	_nrf24_csn_digitalWrite
1479                     ; 336     spi_transfer(FLUSH_RX);
1481  0005 a6e2          	ld	a,#226
1482  0007 cd0000        	call	_spi_transfer
1484                     ; 337     nrf24_csn_digitalWrite(HIGH);
1486  000a a601          	ld	a,#1
1487  000c cd0000        	call	_nrf24_csn_digitalWrite
1489                     ; 339     send = (1<<RX_DR)|(1<<TX_DS)|(1<<MAX_RT);
1491  000f a670          	ld	a,#112
1492  0011 6b02          	ld	(OFST+0,sp),a
1493                     ; 340     nrf24_configRegister(STATUS, send);
1495  0013 ae0770        	ldw	x,#1904
1496  0016 cd0000        	call	_nrf24_configRegister
1498                     ; 341     nrf24_readRegister(STATUS, &rcv, 1);
1500  0019 4b01          	push	#1
1501  001b 96            	ldw	x,sp
1502  001c 1c0002        	addw	x,#OFST+0
1503  001f 89            	pushw	x
1504  0020 a607          	ld	a,#7
1505  0022 cd0000        	call	_nrf24_readRegister
1507  0025 5b03          	addw	sp,#3
1508                     ; 342     if(rcv & send)  // RX_DR, TX_DS, MAX_RT should be reset
1510  0027 7b01          	ld	a,(OFST-1,sp)
1511  0029 1502          	bcp	a,(OFST+0,sp)
1512  002b 2705          	jreq	L714
1513                     ; 344       Errors_SetError(ERROR_NRF24_INIT);
1515  002d a601          	ld	a,#1
1516  002f cd0000        	call	_Errors_SetError
1518  0032               L714:
1519                     ; 347     nrf24_ce_digitalWrite(LOW);    
1521  0032 4f            	clr	a
1522  0033 cd0000        	call	_nrf24_ce_digitalWrite
1524                     ; 348     send = nrf24_CONFIG|((1<<PWR_UP)|(1<<PRIM_RX));
1526  0036 a63b          	ld	a,#59
1527  0038 6b02          	ld	(OFST+0,sp),a
1528                     ; 349     nrf24_configRegister(CONFIG, send);
1530  003a ae003b        	ldw	x,#59
1531  003d cd0000        	call	_nrf24_configRegister
1533                     ; 350     nrf24_readRegister(CONFIG, &rcv, 1);
1535  0040 4b01          	push	#1
1536  0042 96            	ldw	x,sp
1537  0043 1c0002        	addw	x,#OFST+0
1538  0046 89            	pushw	x
1539  0047 4f            	clr	a
1540  0048 cd0000        	call	_nrf24_readRegister
1542  004b 5b03          	addw	sp,#3
1543                     ; 351     if(rcv != send)
1545  004d 7b01          	ld	a,(OFST-1,sp)
1546  004f 1102          	cp	a,(OFST+0,sp)
1547  0051 2705          	jreq	L124
1548                     ; 353       Errors_SetError(ERROR_NRF24_INIT);
1550  0053 a601          	ld	a,#1
1551  0055 cd0000        	call	_Errors_SetError
1553  0058               L124:
1554                     ; 355     nrf24_ce_digitalWrite(HIGH);
1556  0058 a601          	ld	a,#1
1557  005a cd0000        	call	_nrf24_ce_digitalWrite
1559                     ; 356 }
1562  005d 85            	popw	x
1563  005e 81            	ret	
1587                     ; 358 void nrf24_powerUpTx()
1587                     ; 359 {
1588                     .text:	section	.text,new
1589  0000               _nrf24_powerUpTx:
1593                     ; 360     nrf24_configRegister(STATUS,(1<<RX_DR)|(1<<TX_DS)|(1<<MAX_RT)); 
1595  0000 ae0770        	ldw	x,#1904
1596  0003 cd0000        	call	_nrf24_configRegister
1598                     ; 362     nrf24_configRegister(CONFIG,nrf24_CONFIG|((1<<PWR_UP)|(0<<PRIM_RX)));
1600  0006 ae003a        	ldw	x,#58
1602                     ; 363 }
1605  0009 cc0000        	jp	_nrf24_configRegister
1630                     ; 365 void nrf24_powerDown()
1630                     ; 366 {
1631                     .text:	section	.text,new
1632  0000               _nrf24_powerDown:
1636                     ; 367     nrf24_ce_digitalWrite(LOW);
1638  0000 4f            	clr	a
1639  0001 cd0000        	call	_nrf24_ce_digitalWrite
1641                     ; 368     nrf24_configRegister(CONFIG,nrf24_CONFIG);
1643  0004 ae0038        	ldw	x,#56
1645                     ; 369 }
1648  0007 cc0000        	jp	_nrf24_configRegister
1712                     ; 408 void nrf24_transferSync(uint8_t* dataout,uint8_t* datain,uint8_t len)
1712                     ; 409 {
1713                     .text:	section	.text,new
1714  0000               _nrf24_transferSync:
1716  0000 89            	pushw	x
1717  0001 88            	push	a
1718       00000001      OFST:	set	1
1721                     ; 412     for(i=0;i<len;i++)
1723  0002 0f01          	clr	(OFST+0,sp)
1725  0004 201f          	jra	L105
1726  0006               L574:
1727                     ; 414         datain[i] = spi_transfer(dataout[i]);
1729  0006 7b06          	ld	a,(OFST+5,sp)
1730  0008 97            	ld	xl,a
1731  0009 7b07          	ld	a,(OFST+6,sp)
1732  000b 1b01          	add	a,(OFST+0,sp)
1733  000d 2401          	jrnc	L253
1734  000f 5c            	incw	x
1735  0010               L253:
1736  0010 02            	rlwa	x,a
1737  0011 89            	pushw	x
1738  0012 7b04          	ld	a,(OFST+3,sp)
1739  0014 97            	ld	xl,a
1740  0015 7b05          	ld	a,(OFST+4,sp)
1741  0017 1b03          	add	a,(OFST+2,sp)
1742  0019 2401          	jrnc	L653
1743  001b 5c            	incw	x
1744  001c               L653:
1745  001c 02            	rlwa	x,a
1746  001d f6            	ld	a,(x)
1747  001e cd0000        	call	_spi_transfer
1749  0021 85            	popw	x
1750  0022 f7            	ld	(x),a
1751                     ; 412     for(i=0;i<len;i++)
1753  0023 0c01          	inc	(OFST+0,sp)
1754  0025               L105:
1757  0025 7b01          	ld	a,(OFST+0,sp)
1758  0027 1108          	cp	a,(OFST+7,sp)
1759  0029 25db          	jrult	L574
1760                     ; 417 }
1763  002b 5b03          	addw	sp,#3
1764  002d 81            	ret	
1818                     ; 420 void nrf24_transmitSync(uint8_t* dataout,uint8_t len)
1818                     ; 421 {
1819                     .text:	section	.text,new
1820  0000               _nrf24_transmitSync:
1822  0000 89            	pushw	x
1823  0001 88            	push	a
1824       00000001      OFST:	set	1
1827                     ; 424     for(i=0;i<len;i++)
1829  0002 0f01          	clr	(OFST+0,sp)
1831  0004 2011          	jra	L735
1832  0006               L335:
1833                     ; 426         spi_transfer(dataout[i]);
1835  0006 7b02          	ld	a,(OFST+1,sp)
1836  0008 97            	ld	xl,a
1837  0009 7b03          	ld	a,(OFST+2,sp)
1838  000b 1b01          	add	a,(OFST+0,sp)
1839  000d 2401          	jrnc	L463
1840  000f 5c            	incw	x
1841  0010               L463:
1842  0010 02            	rlwa	x,a
1843  0011 f6            	ld	a,(x)
1844  0012 cd0000        	call	_spi_transfer
1846                     ; 424     for(i=0;i<len;i++)
1848  0015 0c01          	inc	(OFST+0,sp)
1849  0017               L735:
1852  0017 7b01          	ld	a,(OFST+0,sp)
1853  0019 1106          	cp	a,(OFST+5,sp)
1854  001b 25e9          	jrult	L335
1855                     ; 429 }
1858  001d 5b03          	addw	sp,#3
1859  001f 81            	ret	
1905                     ; 432 void nrf24_configRegister(uint8_t reg, uint8_t value)
1905                     ; 433 {
1906                     .text:	section	.text,new
1907  0000               _nrf24_configRegister:
1909  0000 89            	pushw	x
1910       00000000      OFST:	set	0
1913                     ; 434     nrf24_csn_digitalWrite(LOW);
1915  0001 4f            	clr	a
1916  0002 cd0000        	call	_nrf24_csn_digitalWrite
1918                     ; 435     spi_transfer(W_REGISTER | (REGISTER_MASK & reg));
1920  0005 7b01          	ld	a,(OFST+1,sp)
1921  0007 a41f          	and	a,#31
1922  0009 aa20          	or	a,#32
1923  000b cd0000        	call	_spi_transfer
1925                     ; 436     spi_transfer(value);
1927  000e 7b02          	ld	a,(OFST+2,sp)
1928  0010 cd0000        	call	_spi_transfer
1930                     ; 437     nrf24_csn_digitalWrite(HIGH);
1932  0013 a601          	ld	a,#1
1933  0015 cd0000        	call	_nrf24_csn_digitalWrite
1935                     ; 438 }
1938  0018 85            	popw	x
1939  0019 81            	ret	
1995                     ; 441 void nrf24_readRegister(uint8_t reg, uint8_t* value, uint8_t len)
1995                     ; 442 {
1996                     .text:	section	.text,new
1997  0000               _nrf24_readRegister:
1999  0000 88            	push	a
2000       00000000      OFST:	set	0
2003                     ; 443     nrf24_csn_digitalWrite(LOW);
2005  0001 4f            	clr	a
2006  0002 cd0000        	call	_nrf24_csn_digitalWrite
2008                     ; 444     spi_transfer(R_REGISTER | (REGISTER_MASK & reg));
2010  0005 7b01          	ld	a,(OFST+1,sp)
2011  0007 a41f          	and	a,#31
2012  0009 cd0000        	call	_spi_transfer
2014                     ; 445     nrf24_transferSync(value,value,len);
2016  000c 7b06          	ld	a,(OFST+6,sp)
2017  000e 88            	push	a
2018  000f 1e05          	ldw	x,(OFST+5,sp)
2019  0011 89            	pushw	x
2020  0012 1e07          	ldw	x,(OFST+7,sp)
2021  0014 cd0000        	call	_nrf24_transferSync
2023  0017 5b03          	addw	sp,#3
2024                     ; 446     nrf24_csn_digitalWrite(HIGH);
2026  0019 a601          	ld	a,#1
2027  001b cd0000        	call	_nrf24_csn_digitalWrite
2029                     ; 447 }
2032  001e 84            	pop	a
2033  001f 81            	ret	
2090                     ; 450 void nrf24_writeRegister(uint8_t reg, uint8_t* value, uint8_t len) 
2090                     ; 451 {
2091                     .text:	section	.text,new
2092  0000               _nrf24_writeRegister:
2094  0000 88            	push	a
2095       00000000      OFST:	set	0
2098                     ; 452     nrf24_csn_digitalWrite(LOW);
2100  0001 4f            	clr	a
2101  0002 cd0000        	call	_nrf24_csn_digitalWrite
2103                     ; 453     spi_transfer(W_REGISTER | (REGISTER_MASK & reg));
2105  0005 7b01          	ld	a,(OFST+1,sp)
2106  0007 a41f          	and	a,#31
2107  0009 aa20          	or	a,#32
2108  000b cd0000        	call	_spi_transfer
2110                     ; 454     nrf24_transmitSync(value,len);
2112  000e 7b06          	ld	a,(OFST+6,sp)
2113  0010 88            	push	a
2114  0011 1e05          	ldw	x,(OFST+5,sp)
2115  0013 cd0000        	call	_nrf24_transmitSync
2117  0016 84            	pop	a
2118                     ; 455     nrf24_csn_digitalWrite(HIGH);
2120  0017 a601          	ld	a,#1
2121  0019 cd0000        	call	_nrf24_csn_digitalWrite
2123                     ; 456 }
2126  001c 84            	pop	a
2127  001d 81            	ret	
2151                     	switch	.ubsct
2152  0000               _payload_len:
2153  0000 00            	ds.b	1
2154                     	xdef	_payload_len
2155                     	xref	_Errors_ResetError
2156                     	xref	_Errors_SetError
2157                     	xref	_nrf24_csn_digitalWrite
2158                     	xref	_nrf24_ce_digitalWrite
2159                     	xref	_nrf24_setupPins
2160                     	xdef	_nrf24_writeRegister
2161                     	xdef	_nrf24_readRegister
2162                     	xdef	_nrf24_configRegister
2163                     	xdef	_nrf24_transferSync
2164                     	xdef	_nrf24_transmitSync
2165                     	xref	_spi_transfer
2166                     	xdef	_nrf24_powerDown
2167                     	xdef	_nrf24_powerUpTx
2168                     	xdef	_nrf24_powerUpRx
2169                     	xdef	_nrf24_payload_length
2170                     	xdef	_nrf24_retransmissionCount
2171                     	xdef	_nrf24_lastMessageStatus
2172                     	xdef	_nrf24_payloadLength
2173                     	xdef	_nrf24_getData
2174                     	xdef	_nrf24_send
2175                     	xdef	_nrf24_rxFifoEmpty
2176                     	xdef	_nrf24_getStatus
2177                     	xdef	_nrf24_isSending
2178                     	xdef	_nrf24_dataReady
2179                     	xdef	_nrf24_config
2180                     	xdef	_nrf24_tx_address
2181                     	xdef	_nrf24_rx_address
2182                     	xdef	_nrf24_init
2202                     	end
