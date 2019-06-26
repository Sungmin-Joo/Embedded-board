
;CodeVisionAVR C Compiler V2.05.0 Evaluation
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 14.745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _m1=R4
	.DEF _m2=R6
	.DEF _m3=R8
	.DEF _m4=R10
	.DEF _d1=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0xC:
	.DB  0xE9,0x3,0xEA,0x3,0xEB,0x3,0xEC,0x3
	.DB  0xED,0x3,0xEE,0x3,0xEF,0x3,0xF0,0x3
	.DB  0xF1,0x3,0xF2,0x3
_0xD:
	.DB  0xE8,0x3,0xD0,0x7,0xB8,0xB,0xA0,0xF
	.DB  0x88,0x13,0x70,0x17,0x58,0x1B,0x40,0x1F
	.DB  0x28,0x23,0xF2,0x3
_0xE:
	.DB  0x57,0x45,0x4C,0x43,0x4F,0x4D,0x45
_0xF:
	.DB  0x48,0x41,0x50,0x50,0x59,0x20,0x48,0x4F
	.DB  0x55,0x53,0x45
_0x10:
	.DB  0x57,0x52,0x4F,0x4E,0x47,0x20,0x50,0x57
_0x11:
	.DB  0x52,0x49,0x47,0x48,0x54,0x20,0x50,0x57
_0x12:
	.DB  0x31
_0x13:
	.DB  0x32
_0x14:
	.DB  0x33
_0x15:
	.DB  0x34
_0x16:
	.DB  0x35
_0x17:
	.DB  0x36
_0x18:
	.DB  0x37
_0x19:
	.DB  0x38
_0x1A:
	.DB  0x39
_0x1B:
	.DB  0x30
_0x1C:
	.DB  0x2A
_0x1D:
	.DB  0x50,0x57,0x3A,0x20,0x20,0x20,0x20
_0x5C:
	.DB  0x52,0x20,0x20,0x20,0x20,0x3A,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x28,0x55,0x29,0x0
	.DB  0x52,0x20,0x20,0x20,0x20,0x3A,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x28,0x43,0x29,0x0
_0x0:
	.DB  0x50,0x72,0x65,0x73,0x73,0x20,0x50,0x57
	.DB  0x21,0x0

__GLOBAL_INI_TBL:
	.DW  0x14
	.DW  _homePassword
	.DW  _0xD*2

	.DW  0x07
	.DW  _str
	.DW  _0xE*2

	.DW  0x0B
	.DW  _str1
	.DW  _0xF*2

	.DW  0x08
	.DW  _rightPW
	.DW  _0x11*2

	.DW  0x01
	.DW  _one
	.DW  _0x12*2

	.DW  0x01
	.DW  _two
	.DW  _0x13*2

	.DW  0x01
	.DW  _three
	.DW  _0x14*2

	.DW  0x01
	.DW  _four
	.DW  _0x15*2

	.DW  0x01
	.DW  _five
	.DW  _0x16*2

	.DW  0x01
	.DW  _six
	.DW  _0x17*2

	.DW  0x01
	.DW  _seven
	.DW  _0x18*2

	.DW  0x01
	.DW  _eight
	.DW  _0x19*2

	.DW  0x01
	.DW  _nine
	.DW  _0x1A*2

	.DW  0x01
	.DW  _zero
	.DW  _0x1B*2

	.DW  0x01
	.DW  _star
	.DW  _0x1C*2

	.DW  0x07
	.DW  _PressPW
	.DW  _0x1D*2

	.DW  0x0A
	.DW  _0xA8
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0xA8+10
	.DW  _0x0*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "lcd.h"

	.CSEG
_PortInit:
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LDI  R30,LOW(15)
	RJMP _0x2000003
_LCD_Data:
;	ch -> Y+0
	LDS  R30,101
	ORI  R30,4
	RCALL SUBOPT_0x0
	ANDI R30,0xFD
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RJMP _0x2000007
_LCD_Comm:
;	ch -> Y+0
	LDS  R30,101
	ANDI R30,0xFB
	RCALL SUBOPT_0x0
	ANDI R30,0xFD
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RJMP _0x2000007
_LCD_delay:
;	ms -> Y+0
	LD   R30,Y
	LDI  R31,0
	RCALL SUBOPT_0x2
	RJMP _0x2000007
_LCD_CHAR:
;	c -> Y+0
	LD   R30,Y
	ST   -Y,R30
	RCALL _LCD_Data
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x2
	RJMP _0x2000007
_LCD_STR:
;	*str -> Y+0
_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
	ST   -Y,R30
	RCALL _LCD_CHAR
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x3
_0x5:
	RJMP _0x2000005
_LCD_pos:
;	col -> Y+1
;	row -> Y+0
	LDD  R30,Y+1
	LDI  R26,LOW(64)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	ADD  R30,R26
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _LCD_Comm
	RJMP _0x2000005
_LCD_Clear:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
	RET
;	p -> Y+0
_Cursor_shift:
;	p -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x9
	LDI  R30,LOW(20)
	RJMP _0xB1
_0x9:
	LD   R30,Y
	CPI  R30,0
	BRNE _0xB
	LDI  R30,LOW(16)
_0xB1:
	ST   -Y,R30
	RCALL SUBOPT_0x4
	RCALL _LCD_delay
_0xB:
_0x2000007:
	ADIW R28,1
	RET
_LCD_Init:
	LDI  R30,LOW(56)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(56)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(56)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3
	RCALL _LCD_Clear
	RET
;#define Do  477
;#define Re  424
;#define Mi  378
;#define Fa  357
;#define Sol 318
;#define La  283
;#define Si  238
;//처음에는 우리가 쓸 변수 및 상수들을 정리해 논거임.
;int m1,m2,m3,m4;  //m1,2,3,4 버튼 눌렀을때 사용하는 변수.
;int d1,d2,d3,d4;   //m1,2,3,4# 눌렀을때 기능을 가능하게 하는 변수 .
;int inToLCD;
;int comp=0;     //비교할때 사용하는 변수.
;int shap=0;     //# 버튼 눌렀을때 사용하는 함수.
;unsigned int home[10]= {1001,1002,1003,1004,1005,1006,1007,1008,1009,1010};         // 10개의 호수 설정

	.DSEG
;unsigned int homePassword[10]= {1000,2000,3000,4000,5000,6000,7000,8000,9000,1010}; //호수 초기 비밀번호 설정.
;unsigned int num_in[5];
;unsigned int sum,comp_ho;
;    Byte str[] = "WELCOME";
;    Byte str1[] = "HAPPY HOUSE";
;    Byte wrongPW[] = "WRONG PW";
;    Byte rightPW[] = "RIGHT PW";
;    Byte one[] = "1";
;    Byte two[] = "2";
;    Byte three[] = "3";
;    Byte four[] = "4";
;    Byte five[] = "5";
;    Byte six[] = "6";
;    Byte seven[] = "7";
;    Byte eight[] = "8";
;    Byte nine[] = "9";
;    Byte zero[] = "0";
;    Byte star[] = "*";
;    Byte Emt[] = "";
;    Byte PressPW[] = "PW:    ";
;
;//LCD에 출련된 4자리 숫자 인티져로 옮겨주는 친구
;void Num_to_int(){
; 0000 0028 void Num_to_int(){

	.CSEG
_Num_to_int:
; 0000 0029     sum= num_in[3]*1000 + num_in[2]*100 + num_in[1]*10 + num_in[0];
	RCALL SUBOPT_0x5
	STS  _sum,R30
	STS  _sum+1,R31
; 0000 002A     num_in[4] =0;
	__POINTW1MN _num_in,8
	RCALL SUBOPT_0x6
; 0000 002B     num_in[3] =0;
	__POINTW1MN _num_in,6
	RCALL SUBOPT_0x6
; 0000 002C     num_in[2] =0;
	__POINTW1MN _num_in,4
	RCALL SUBOPT_0x6
; 0000 002D     num_in[1] =0;
	__POINTW1MN _num_in,2
	RCALL SUBOPT_0x6
; 0000 002E     num_in[0] =0;
	LDI  R30,LOW(0)
	STS  _num_in,R30
	STS  _num_in+1,R30
; 0000 002F }
	RET
;
;void Comp_Ho_To_int(){
; 0000 0031 void Comp_Ho_To_int(){
_Comp_Ho_To_int:
; 0000 0032     comp_ho= num_in[3]*1000 + num_in[2]*100 + num_in[1]*10 + num_in[0];
	RCALL SUBOPT_0x5
	STS  _comp_ho,R30
	STS  _comp_ho+1,R31
; 0000 0033 }
	RET
;
;//내가 입력한 호수의 비밀번호를 보여주는 함수.
;void Show_Home_Password(){
; 0000 0036 void Show_Home_Password(){
_Show_Home_Password:
; 0000 0037     int ch_Num[4];
; 0000 0038     int press_Password;
; 0000 0039     int namuaje;
; 0000 003A     int showPs;
; 0000 003B     ch_Num[3] = num_in[3];
	SBIW R28,8
	CALL __SAVELOCR6
;	ch_Num -> Y+6
;	press_Password -> R16,R17
;	namuaje -> R18,R19
;	showPs -> R20,R21
	RCALL SUBOPT_0x7
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 003C     ch_Num[2] = num_in[2];
	RCALL SUBOPT_0x8
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 003D     ch_Num[1] = num_in[1];
	RCALL SUBOPT_0x9
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 003E     ch_Num[0] = num_in[0];
	RCALL SUBOPT_0xA
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 003F     press_Password = ch_Num[3]*1000 + ch_Num[2]*100 + ch_Num[1]*10 +ch_Num[0];
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL SUBOPT_0xB
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0xC
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0xD
	ADD  R30,R22
	ADC  R31,R23
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
; 0000 0040     namuaje=press_Password%1000;
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	RCALL SUBOPT_0xE
; 0000 0041     switch(namuaje-1){
; 0000 0042         case 0 : {showPs=homePassword[namuaje-1];break;}
	BRNE _0x21
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 0043         case 1 : {showPs=homePassword[namuaje-1];break;}
_0x21:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x22
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 0044         case 2 : {showPs=homePassword[namuaje-1];break;}
_0x22:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x23
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 0045         case 3 : {showPs=homePassword[namuaje-1];break;}
_0x23:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x24
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 0046         case 4 : {showPs=homePassword[namuaje-1];break;}
_0x24:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x25
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 0047         case 5 : {showPs=homePassword[namuaje-1];break;}
_0x25:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x26
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 0048         case 6 : {showPs=homePassword[namuaje-1];break;}
_0x26:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x27
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 0049         case 7 : {showPs=homePassword[namuaje-1];break;}
_0x27:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x28
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 004A         case 8 : {showPs=homePassword[namuaje-1];break;}
_0x28:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x29
	RCALL SUBOPT_0xF
	RJMP _0x20
; 0000 004B         case 9 : {showPs=homePassword[namuaje-1];break;}
_0x29:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x2B
	RCALL SUBOPT_0xF
; 0000 004C         default : break;}
_0x2B:
_0x20:
; 0000 004D     ch_Num[3] = showPs/1000;
	MOVW R26,R20
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 004E     ch_Num[2] = showPs/100 - (showPs/1000)*10;
	MOVW R26,R20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R22,R30
	MOVW R26,R20
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x10
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+10,R26
	STD  Y+10+1,R27
; 0000 004F     ch_Num[1] = showPs/10 -(showPs/100)*10;
	MOVW R26,R20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R22,R30
	MOVW R26,R20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x10
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+8,R26
	STD  Y+8+1,R27
; 0000 0050     ch_Num[0] = showPs-(showPs/10)*10;
	MOVW R26,R20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x10
	MOVW R26,R30
	MOVW R30,R20
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0051     LCD_pos(0,7);
	RCALL SUBOPT_0x11
; 0000 0052     LCD_CHAR(48+ch_Num[3]);
	LDD  R30,Y+12
	RCALL SUBOPT_0x12
; 0000 0053     LCD_CHAR(48+ch_Num[2]);
	LDD  R30,Y+10
	RCALL SUBOPT_0x12
; 0000 0054     LCD_CHAR(48+ch_Num[1]);
	LDD  R30,Y+8
	RCALL SUBOPT_0x12
; 0000 0055     LCD_CHAR(48+ch_Num[0]);
	LDD  R30,Y+6
	RCALL SUBOPT_0x12
; 0000 0056 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
;
;//호수에 해당하는 비밀번호가 맞는지 알아봐 주는 친구
;void Home_password_compare(){
; 0000 0059 void Home_password_compare(){
_Home_password_compare:
; 0000 005A     int ch_Num[4];
; 0000 005B     int press_Password;
; 0000 005C     int namuaje;
; 0000 005D     ch_Num[3] = num_in[3];
	SBIW R28,8
	CALL __SAVELOCR4
;	ch_Num -> Y+4
;	press_Password -> R16,R17
;	namuaje -> R18,R19
	RCALL SUBOPT_0x7
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 005E     ch_Num[2] = num_in[2];
	RCALL SUBOPT_0x8
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 005F     ch_Num[1] = num_in[1];
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
; 0000 0060     ch_Num[0] = num_in[0];
; 0000 0061     press_Password = ch_Num[3]*1000 + ch_Num[2]*100 + ch_Num[1]*10 +ch_Num[0];
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0xC
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x14
; 0000 0062     namuaje=sum%1000;
; 0000 0063     switch(namuaje-1){
; 0000 0064         case 0 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
	BRNE _0x2F
	RCALL SUBOPT_0x15
	BRNE _0x30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB2
_0x30:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB2:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 0065         case 1 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x2F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x32
	RCALL SUBOPT_0x15
	BRNE _0x33
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB3
_0x33:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB3:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 0066         case 2 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x32:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x35
	RCALL SUBOPT_0x15
	BRNE _0x36
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB4
_0x36:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB4:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 0067         case 3 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x35:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x38
	RCALL SUBOPT_0x15
	BRNE _0x39
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB5
_0x39:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB5:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 0068         case 4 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x38:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3B
	RCALL SUBOPT_0x15
	BRNE _0x3C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB6
_0x3C:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB6:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 0069         case 5 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x3B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3E
	RCALL SUBOPT_0x15
	BRNE _0x3F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB7
_0x3F:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB7:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 006A         case 6 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x3E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x41
	RCALL SUBOPT_0x15
	BRNE _0x42
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB8
_0x42:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB8:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 006B         case 7 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x41:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x44
	RCALL SUBOPT_0x15
	BRNE _0x45
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xB9
_0x45:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xB9:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 006C         case 8 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x44:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x47
	RCALL SUBOPT_0x15
	BRNE _0x48
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xBA
_0x48:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xBA:
	STS  _comp,R30
	STS  _comp+1,R31
	RJMP _0x2E
; 0000 006D         case 9 : {if(press_Password == homePassword[namuaje-1]){comp=1;}else comp =2;break;}
_0x47:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x4D
	RCALL SUBOPT_0x15
	BRNE _0x4B
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xBB
_0x4B:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xBB:
	STS  _comp,R30
	STS  _comp+1,R31
; 0000 006E         default : break;
_0x4D:
; 0000 006F     }
_0x2E:
; 0000 0070 }
	RJMP _0x2000006
;
;//내가 입력한 호수를 다시 LCD에 출력하는 함수.
;void Show_Home_Ho(){
; 0000 0073 void Show_Home_Ho(){
_Show_Home_Ho:
; 0000 0074   int ch_Num[4];
; 0000 0075     ch_Num[3] = sum/1000;
	SBIW R28,8
;	ch_Num -> Y+0
	RCALL SUBOPT_0x16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0076     ch_Num[2] = sum/100 - (sum/1000)*10;
	RCALL SUBOPT_0x17
	MOVW R22,R30
	RCALL SUBOPT_0x16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x18
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+4,R26
	STD  Y+4+1,R27
; 0000 0077     ch_Num[1] = sum/10 -(sum/100)*10;
	RCALL SUBOPT_0x16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R22,R30
	RCALL SUBOPT_0x17
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+2,R26
	STD  Y+2+1,R27
; 0000 0078     ch_Num[0] = sum-(sum/10)*10;
	RCALL SUBOPT_0x16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x16
	SUB  R26,R30
	SBC  R27,R31
	ST   Y,R26
	STD  Y+1,R27
; 0000 0079     LCD_CHAR(48+ch_Num[3]);
	LDD  R30,Y+6
	RCALL SUBOPT_0x12
; 0000 007A     LCD_CHAR(48+ch_Num[2]);
	LDD  R30,Y+4
	RCALL SUBOPT_0x12
; 0000 007B     LCD_CHAR(48+ch_Num[1]);
	LDD  R30,Y+2
	RCALL SUBOPT_0x12
; 0000 007C     LCD_CHAR(48+ch_Num[0]);
	LD   R30,Y
	RCALL SUBOPT_0x12
; 0000 007D }
	ADIW R28,8
	RET
;
;//비밀번호 새로 설정해주는 친구.
;void change_Password(){
; 0000 0080 void change_Password(){
_change_Password:
; 0000 0081     int ch_Num[4];
; 0000 0082     int new_Password;
; 0000 0083     int namuaje;
; 0000 0084     ch_Num[3] = num_in[3];
	SBIW R28,8
	CALL __SAVELOCR4
;	ch_Num -> Y+4
;	new_Password -> R16,R17
;	namuaje -> R18,R19
	RCALL SUBOPT_0x7
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0085     ch_Num[2] = num_in[2];
	RCALL SUBOPT_0x8
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0086     ch_Num[1] = num_in[1];
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
; 0000 0087     ch_Num[0] = num_in[0];
; 0000 0088     new_Password = ch_Num[3]*1000 + ch_Num[2]*100 + ch_Num[1]*10 +ch_Num[0];
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0xC
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x14
; 0000 0089 
; 0000 008A     namuaje=sum%1000;
; 0000 008B     switch(namuaje-1){
; 0000 008C         case 0 : {homePassword[namuaje-1]=new_Password;break;}
	BRNE _0x51
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 008D         case 1 : {homePassword[namuaje-1]=new_Password;break;}
_0x51:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x52
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 008E         case 2 : {homePassword[namuaje-1]=new_Password;break;}
_0x52:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x53
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 008F         case 3 : {homePassword[namuaje-1]=new_Password;break;}
_0x53:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x54
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 0090         case 4 : {homePassword[namuaje-1]=new_Password;break;}
_0x54:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x55
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 0091         case 5 : {homePassword[namuaje-1]=new_Password;break;}
_0x55:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x56
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 0092         case 6 : {homePassword[namuaje-1]=new_Password;break;}
_0x56:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x57
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 0093         case 7 : {homePassword[namuaje-1]=new_Password;break;}
_0x57:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x58
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 0094         case 8 : {homePassword[namuaje-1]=new_Password;break;}
_0x58:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x59
	RCALL SUBOPT_0x19
	RJMP _0x50
; 0000 0095         case 9 : {homePassword[namuaje-1]=new_Password;break;}
_0x59:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x5B
	RCALL SUBOPT_0x19
; 0000 0096         default : break;}
_0x5B:
_0x50:
; 0000 0097 }
_0x2000006:
	CALL __LOADLOCR4
	ADIW R28,12
	RET
;
;//비밀번호 설정하는 화면 보여주는 친구.
;void Set_password_Display(){
; 0000 009A void Set_password_Display(){
_Set_password_Display:
; 0000 009B    Byte checkPass[] = "R    :      (C)";
; 0000 009C    Byte checkPass2[] = "R    :      (U)";
; 0000 009D    LCD_pos(0,1);
	SBIW R28,32
	LDI  R24,32
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x5C*2)
	LDI  R31,HIGH(_0x5C*2)
	CALL __INITLOCB
;	checkPass -> Y+16
;	checkPass2 -> Y+0
	RCALL SUBOPT_0x1A
; 0000 009E    LCD_STR(checkPass);
	MOVW R30,R28
	ADIW R30,16
	RCALL SUBOPT_0x1B
; 0000 009F    LCD_pos(1,1);
	RCALL SUBOPT_0x1C
; 0000 00A0    LCD_STR(checkPass2);
	MOVW R30,R28
	RCALL SUBOPT_0x1B
; 0000 00A1    m1=0;
	CLR  R4
	CLR  R5
; 0000 00A2    d1=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 00A3    LCD_Comm(0x0e); // Display ON/OFF
	RCALL SUBOPT_0x1D
; 0000 00A4    LCD_pos(0,2);
; 0000 00A5 }
	ADIW R28,32
	RET
;
;//집으로 들어가기 위해 시작되는 첫단계인 친구.
;void Go_To_Home(){
; 0000 00A8 void Go_To_Home(){
_Go_To_Home:
; 0000 00A9    Byte PressHo[] = "R";
; 0000 00AA    LCD_pos(0,1);
	SBIW R28,2
	LDI  R30,LOW(82)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
;	PressHo -> Y+0
	RCALL SUBOPT_0x1A
; 0000 00AB    LCD_STR(PressHo);
	MOVW R30,R28
	RCALL SUBOPT_0x1B
; 0000 00AC    LCD_Comm(0x0e); // Display ON/OFF
	RCALL SUBOPT_0x1D
; 0000 00AD    LCD_pos(0,2);
; 0000 00AE    shap=0;
	RCALL SUBOPT_0x1E
; 0000 00AF    d4=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _d4,R30
	STS  _d4+1,R31
; 0000 00B0 }
_0x2000005:
	ADIW R28,2
	RET
;
;//m1,m2,m3,m4,# 값 읽어오는 친구
;void Switch_Verify(void)
; 0000 00B4 {
_Switch_Verify:
; 0000 00B5     switch(inToLCD){
	RCALL SUBOPT_0x1F
; 0000 00B6     case 12 : {m1=1;break;}
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x60
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
	RJMP _0x5F
; 0000 00B7     case 13 : {m2=1;break;}
_0x60:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x61
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
	RJMP _0x5F
; 0000 00B8     case 14 : {m3=1;break;}
_0x61:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x62
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
	RJMP _0x5F
; 0000 00B9     case 15 : {m4=1;break;}
_0x62:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x63
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP _0x5F
; 0000 00BA     case 11 : {shap=1;break;}
_0x63:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x65
	RCALL SUBOPT_0x20
; 0000 00BB     default :break;
_0x65:
; 0000 00BC     }
_0x5F:
; 0000 00BD     delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP _0x2000004
; 0000 00BE }
;
;//키패드를 통해 받아온 숫자를 LCD에 출력해 주는 친구.
;void SelectNum(){
; 0000 00C1 void SelectNum(){
_SelectNum:
; 0000 00C2     switch(inToLCD){
	RCALL SUBOPT_0x1F
; 0000 00C3         case 1 : {LCD_STR(one);break;}
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x69
	LDI  R30,LOW(_one)
	LDI  R31,HIGH(_one)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00C4         case 2 : {LCD_STR(two);break;}
_0x69:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6A
	LDI  R30,LOW(_two)
	LDI  R31,HIGH(_two)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00C5         case 3 : {LCD_STR(three);break;}
_0x6A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6B
	LDI  R30,LOW(_three)
	LDI  R31,HIGH(_three)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00C6         case 4 : {LCD_STR(four);break;}
_0x6B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6C
	LDI  R30,LOW(_four)
	LDI  R31,HIGH(_four)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00C7         case 5 : {LCD_STR(five);break;}
_0x6C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x6D
	LDI  R30,LOW(_five)
	LDI  R31,HIGH(_five)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00C8         case 6 : {LCD_STR(six);break;}
_0x6D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x6E
	LDI  R30,LOW(_six)
	LDI  R31,HIGH(_six)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00C9         case 7 : {LCD_STR(seven);break;}
_0x6E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x6F
	LDI  R30,LOW(_seven)
	LDI  R31,HIGH(_seven)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00CA         case 8 : {LCD_STR(eight);break;}
_0x6F:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x70
	LDI  R30,LOW(_eight)
	LDI  R31,HIGH(_eight)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00CB         case 9 : {LCD_STR(nine);break;}
_0x70:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x71
	LDI  R30,LOW(_nine)
	LDI  R31,HIGH(_nine)
	RCALL SUBOPT_0x1B
	RJMP _0x68
; 0000 00CC         case 0 : {LCD_STR(zero);break;}
_0x71:
	SBIW R30,0
	BRNE _0x73
	LDI  R30,LOW(_zero)
	LDI  R31,HIGH(_zero)
	RCALL SUBOPT_0x1B
; 0000 00CD         default : break;
_0x73:
; 0000 00CE     }
_0x68:
; 0000 00CF     num_in[4]=num_in[3];
	RCALL SUBOPT_0x7
	__PUTW1MN _num_in,8
; 0000 00D0     num_in[3]=num_in[2];
	RCALL SUBOPT_0x8
	__PUTW1MN _num_in,6
; 0000 00D1     num_in[2]=num_in[1];
	RCALL SUBOPT_0x9
	__PUTW1MN _num_in,4
; 0000 00D2     num_in[1]=num_in[0];
	RCALL SUBOPT_0xA
	__PUTW1MN _num_in,2
; 0000 00D3     num_in[0]=inToLCD;
	RCALL SUBOPT_0x1F
	STS  _num_in,R30
	STS  _num_in+1,R31
; 0000 00D4     delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
_0x2000004:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00D5 }
	RET
;
;void Port_set()       //내가 사용할 포트들 정라
; 0000 00D8 {
_Port_set:
; 0000 00D9     DDRC = 0x0f; //상위 4bit 입력, 하위 4bit 출력 키패드
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 00DA     DDRD= 0xf0; // sw 상위 4개 입력으로 설정
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 00DB     PORTC = 0xf0;//PORTC의 상위 4bit 내부 풀업 설정 키패드
	OUT  0x15,R30
; 0000 00DC     DDRG|=(1<<4); // 부저음 관
	LDS  R30,100
	ORI  R30,0x10
_0x2000003:
	STS  100,R30
; 0000 00DD }
	RET
;
;int Scan_Col(int row)  //Row 값(row = 0이면 첫번째 행, row = 3이면 네번째 행 선택)에 따라 Column 스캔 함수, 출력 Col1(1열) = 0x01, Col2(2열) = 0x02, Col3(3열) = 0x04
; 0000 00E0 {
_Scan_Col:
; 0000 00E1     int col_temp=0 , col_num =0;    //col_temp : column값 임시 저장 변수, col_num : column 값
; 0000 00E2     PORTC =~(1<<row);          //row 값에 따라 포트 C의 하위 비트 출력 선택  ex)3번째 줄(row = 2) 선택, PORTC = 0b11111011
	CALL __SAVELOCR4
;	row -> Y+4
;	col_temp -> R16,R17
;	col_num -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDD  R30,Y+4
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	OUT  0x15,R30
; 0000 00E3     delay_us(1);                //인식하기까지 시간이 걸리기 때문에 딜레이
	__DELAY_USB 5
; 0000 00E4     col_temp = PINC>>4;         //포트 C의 입력값 스캔(포트 C의 상위 4비트 입력값만 필요, 오른쪽으로 4비트 이동) ex)col_temp = 0b0000???? = 0x0?
	IN   R30,0x13
	LDI  R31,0
	CALL __ASRW4
	MOVW R16,R30
; 0000 00E5     col_num =  col_temp & 0x0f; //column 값은 하위 비트만 필요하므로 0x0f AND 연산 ex)col_num = 0b0000???? = 0x0?, 버튼이 눌렸다면  0x01, 0x02, 0x04로 출력
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R18,R30
; 0000 00E6     return col_num; //Column 값 반환
	MOVW R30,R18
	RJMP _0x2000002
; 0000 00E7 }
;int KeyNumScan(int row, int col_data) //row와 column 값에 따른 숫자 변환
; 0000 00E9 {
_KeyNumScan:
; 0000 00EA     int sel_num = -1; //select number선택, 버튼에 따른 숫자 저장 변수, 초기값 -1 : 아무것도 누르지 않은 상태
; 0000 00EB 
; 0000 00EC     switch(3-row)
	ST   -Y,R17
	ST   -Y,R16
;	row -> Y+4
;	col_data -> Y+2
;	sel_num -> R16,R17
	__GETWRN 16,17,-1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	SUB  R30,R26
	SBC  R31,R27
; 0000 00ED     {
; 0000 00EE         case 0:
	SBIW R30,0
	BRNE _0x77
; 0000 00EF             if(col_data == 0x01) sel_num = 1;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x78
	__GETWRN 16,17,1
; 0000 00F0             if(col_data == 0x02) sel_num = 2;
_0x78:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,2
	BRNE _0x79
	__GETWRN 16,17,2
; 0000 00F1             if(col_data == 0x04) sel_num = 3;
_0x79:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,4
	BRNE _0x7A
	__GETWRN 16,17,3
; 0000 00F2             if(col_data == 0x08) sel_num=12;  //m1
_0x7A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0x7B
	__GETWRN 16,17,12
; 0000 00F3             break;
_0x7B:
	RJMP _0x76
; 0000 00F4         case 1:
_0x77:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7C
; 0000 00F5             if(col_data == 0x01) sel_num = 4;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x7D
	__GETWRN 16,17,4
; 0000 00F6             if(col_data == 0x02) sel_num = 5;
_0x7D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,2
	BRNE _0x7E
	__GETWRN 16,17,5
; 0000 00F7             if(col_data == 0x04) sel_num = 6;
_0x7E:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,4
	BRNE _0x7F
	__GETWRN 16,17,6
; 0000 00F8             if(col_data == 0x08) sel_num=13;  //m2
_0x7F:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0x80
	__GETWRN 16,17,13
; 0000 00F9             break;
_0x80:
	RJMP _0x76
; 0000 00FA         case 2:
_0x7C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x81
; 0000 00FB             if(col_data == 0x01) sel_num = 7;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x82
	__GETWRN 16,17,7
; 0000 00FC             if(col_data == 0x02) sel_num = 8;
_0x82:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,2
	BRNE _0x83
	__GETWRN 16,17,8
; 0000 00FD             if(col_data == 0x04) sel_num = 9;
_0x83:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,4
	BRNE _0x84
	__GETWRN 16,17,9
; 0000 00FE             if(col_data == 0x08) sel_num=14;   //m3
_0x84:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0x85
	__GETWRN 16,17,14
; 0000 00FF             break;
_0x85:
	RJMP _0x76
; 0000 0100         case 3:
_0x81:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8B
; 0000 0101             if(col_data == 0x01) sel_num = 10;  // *에 해당하는 값 10
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x87
	__GETWRN 16,17,10
; 0000 0102             if(col_data == 0x02) sel_num = 0;   // 0에 해당하는 값 0
_0x87:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,2
	BRNE _0x88
	__GETWRN 16,17,0
; 0000 0103             if(col_data == 0x04) sel_num = 11;  // #에 해당하는 값 11
_0x88:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,4
	BRNE _0x89
	__GETWRN 16,17,11
; 0000 0104             if(col_data == 0x08) sel_num=15;  //m4
_0x89:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0x8A
	__GETWRN 16,17,15
; 0000 0105             break;
_0x8A:
; 0000 0106         default:break;
_0x8B:
; 0000 0107     }
_0x76:
; 0000 0108     return sel_num;     //선택된 숫자값 변환
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2000001
; 0000 0109 }
;
;
;void myDelay_us(unsigned int delay)
; 0000 010D {
_myDelay_us:
; 0000 010E   int i;
; 0000 010F   for(i=0; i<delay; i++)
	ST   -Y,R17
	ST   -Y,R16
;	delay -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x8D:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x8E
; 0000 0110   {
; 0000 0111     delay_us(1);
	__DELAY_USB 5
; 0000 0112   }
	__ADDWRN 16,17,1
	RJMP _0x8D
_0x8E:
; 0000 0113 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
;void SSound(int time)
; 0000 0116 {
_SSound:
; 0000 0117     int i, tim;
; 0000 0118     tim = 50000/time;
	CALL __SAVELOCR4
;	time -> Y+4
;	i -> R16,R17
;	tim -> R18,R19
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDI  R26,LOW(50000)
	LDI  R27,HIGH(50000)
	CALL __DIVW21U
	MOVW R18,R30
; 0000 0119     for (i=0; i<tim; i++)
	__GETWRN 16,17,0
_0x90:
	__CPWRR 16,17,18,19
	BRGE _0x91
; 0000 011A     {
; 0000 011B       PORTG|= 1<<4;
	LDS  R30,101
	ORI  R30,0x10
	RCALL SUBOPT_0x21
; 0000 011C       myDelay_us(time);
; 0000 011D       PORTG &= ~(1<<4);
	LDS  R30,101
	ANDI R30,0xEF
	RCALL SUBOPT_0x21
; 0000 011E       myDelay_us(time);
; 0000 011F     }
	__ADDWRN 16,17,1
	RJMP _0x90
_0x91:
; 0000 0120 }
_0x2000002:
	CALL __LOADLOCR4
_0x2000001:
	ADIW R28,6
	RET
;
;void main(void)
; 0000 0123 {
_main:
; 0000 0124     int row_count ;
; 0000 0125     int col_count ;
; 0000 0126     int countNum=9;
; 0000 0127     int Num;
; 0000 0128     PortInit();//LCD포트 초기화
	SBIW R28,2
;	row_count -> R16,R17
;	col_count -> R18,R19
;	countNum -> R20,R21
;	Num -> Y+0
	__GETWRN 20,21,9
	RCALL _PortInit
; 0000 0129     Port_set(); //내가 사용하는 포트 사용 설정
	RCALL _Port_set
; 0000 012A     LCD_Init();//LCD 화면 초기화
	RCALL _LCD_Init
; 0000 012B     LCD_pos(0,2);
	RCALL SUBOPT_0x22
; 0000 012C     LCD_STR(str);
; 0000 012D     LCD_pos(1,2);
	RCALL SUBOPT_0x23
; 0000 012E     LCD_STR(str1);
; 0000 012F     LCD_Comm(0x0c); // Display ON/OFF
	RCALL SUBOPT_0x24
; 0000 0130     //LCD에 초기 화면 설정
; 0000 0131 
; 0000 0132     while(1){
_0x92:
; 0000 0133 
; 0000 0134     Switch_Verify();//m1,m2,m3,m4의 기능을 수행하기 위해서 일단 읽어본다.
	RCALL _Switch_Verify
; 0000 0135     if(m1==1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x95
; 0000 0136         m2=0; d2=0;
	RCALL SUBOPT_0x25
; 0000 0137         m1=0; d1=0;
; 0000 0138         m3=0;
; 0000 0139         shap=0;  d4=0;
	RCALL SUBOPT_0x26
; 0000 013A         countNum=0;
	__GETWRN 20,21,0
; 0000 013B         LCD_Clear();
	RCALL _LCD_Clear
; 0000 013C         Set_password_Display();//m1의 버튼을 눌렀을때에 비밀번호 설정 화면을 표시하게 된다.
	RCALL _Set_password_Display
; 0000 013D         }
; 0000 013E     //m2는 LCD의 화면을 초기의 화면으로 설정해 주는 친구임.
; 0000 013F     if(m2==1){
_0x95:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x96
; 0000 0140     LCD_Clear();
	RCALL _LCD_Clear
; 0000 0141     LCD_pos(0,2);
	RCALL SUBOPT_0x22
; 0000 0142     LCD_STR(str);
; 0000 0143     LCD_pos(1,2);
	RCALL SUBOPT_0x23
; 0000 0144     LCD_STR(str1);
; 0000 0145     m2=0; d2=0;
	RCALL SUBOPT_0x25
; 0000 0146     m1=0; d1=0;
; 0000 0147     m3=0;
; 0000 0148     shap=0;  d4=0;
	RCALL SUBOPT_0x26
; 0000 0149     countNum=9;
	__GETWRN 20,21,9
; 0000 014A     LCD_Comm(0x0c); // Display ON/OFF
	RCALL SUBOPT_0x24
; 0000 014B     //모든 변수값 초기화 진행 하였음.
; 0000 014C     }
; 0000 014D     //shap 친구는 집으로 들어가기 위해 처음 화면을 보여주는 친구임.
; 0000 014E     if(shap==1){
_0x96:
	LDS  R26,_shap
	LDS  R27,_shap+1
	SBIW R26,1
	BRNE _0x97
; 0000 014F     LCD_Clear();
	RCALL _LCD_Clear
; 0000 0150     Go_To_Home();
	RCALL _Go_To_Home
; 0000 0151     countNum=0;
	__GETWRN 20,21,0
; 0000 0152     m2=0; d2=0;
	CLR  R6
	CLR  R7
	LDI  R30,LOW(0)
	STS  _d2,R30
	STS  _d2+1,R30
; 0000 0153     m1=0; d1=0;
	CLR  R4
	CLR  R5
	CLR  R12
	CLR  R13
; 0000 0154     m3=0;
	CLR  R8
	CLR  R9
; 0000 0155     comp=0;
	STS  _comp,R30
	STS  _comp+1,R30
; 0000 0156     }
; 0000 0157 
; 0000 0158         for(row_count = 0; row_count < 4; row_count++)//키패드 관련 일거오는 포문임.
_0x97:
	__GETWRN 16,17,0
_0x99:
	__CPWRN 16,17,4
	BRLT PC+3
	JMP _0x9A
; 0000 0159         {
; 0000 015A             col_count = Scan_Col(row_count);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _Scan_Col
	MOVW R18,R30
; 0000 015B             Num = KeyNumScan(row_count, col_count);
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	RCALL _KeyNumScan
	ST   Y,R30
	STD  Y+1,R31
; 0000 015C             delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x2
; 0000 015D             if(Num !=-1)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BRNE PC+3
	JMP _0x9B
; 0000 015E             {
; 0000 015F                 inToLCD = Num;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _inToLCD,R30
	STS  _inToLCD+1,R31
; 0000 0160                 //기능 외에는 아무리 버튼을 눌러도 더 눌리지 않음 ex) 홈화면에서 0~9키 눌러도 소용없음 m1,m2,#키만 작동함.
; 0000 0161                 if(countNum <9){
	__CPWRN 20,21,9
	BRGE _0x9C
; 0000 0162                 SelectNum();
	RCALL _SelectNum
; 0000 0163                 }
; 0000 0164 
; 0000 0165                 //d1은 비밀번호 설정 화면에서 기능을 온 시켜주는 친구임 1이면 작동 0이면 미작동.
; 0000 0166                 if(d1==1){
_0x9C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BREQ PC+3
	JMP _0x9D
; 0000 0167                     if(inToLCD <10){countNum++;}//숫자 0~9가 눌러지게 되면 카운트를 세는거임.
	LDS  R26,_inToLCD
	LDS  R27,_inToLCD+1
	SBIW R26,10
	BRGE _0x9E
	__ADDWRN 20,21,1
; 0000 0168                     if(countNum == 4)   //카운트가 4일때 즉 4자리 숫자가 입력되면 이일을 진행하게됨.
_0x9E:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x9F
; 0000 0169                     {
; 0000 016A                         Comp_Ho_To_int(); //내가 받은 4개의 값을 comp_ho에  int 값으로 넣는 것!.
	RCALL _Comp_Ho_To_int
; 0000 016B 
; 0000 016C                         if(comp_ho>1000 & comp_ho<1011)     //1001~1010 사이의 값이 있으면 기존의 비밀번호 보여줌 + 내가 입력한 호수 표시.
	LDS  R26,_comp_ho
	LDS  R27,_comp_ho+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __GTW12U
	MOV  R0,R30
	LDI  R30,LOW(1011)
	LDI  R31,HIGH(1011)
	CALL __LTW12U
	AND  R30,R0
	BREQ _0xA0
; 0000 016D                         {
; 0000 016E                             Cursor_shift(RIGHT);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _Cursor_shift
; 0000 016F                             Show_Home_Password();
	RCALL _Show_Home_Password
; 0000 0170                             LCD_pos(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LCD_pos
; 0000 0171                             LCD_CHAR(48+num_in[3]); //내가 입력한 호수 복붙복붙 아스키 코드 사용해서 48더해준거임.
	__GETB1MN _num_in,6
	RCALL SUBOPT_0x12
; 0000 0172                             LCD_CHAR(48+num_in[2]);
	__GETB1MN _num_in,4
	RCALL SUBOPT_0x12
; 0000 0173                             LCD_CHAR(48+num_in[1]);
	__GETB1MN _num_in,2
	RCALL SUBOPT_0x12
; 0000 0174                             LCD_CHAR(48+num_in[0]);
	LDS  R30,_num_in
	RCALL SUBOPT_0x12
; 0000 0175                             Num_to_int();
	RCALL _Num_to_int
; 0000 0176                             LCD_pos(1,7);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x27
; 0000 0177                             LCD_Comm(0x0f); // Display ON/OFF
; 0000 0178                             }
; 0000 0179                         else{m1=1; countNum=0;} //만약 1001~1010 이외의 값이면 다시 호 입력화면으로 돌아감.
	RJMP _0xA1
_0xA0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
	__GETWRN 20,21,0
_0xA1:
; 0000 017A                       }
; 0000 017B                             if((countNum==5)|(countNum==6)|(countNum==7)|(countNum==8)) //비밀번호 입력시에 *로 표시함.
_0x9F:
	RCALL SUBOPT_0x28
	BREQ _0xA2
; 0000 017C                             {
; 0000 017D                             LCD_Comm(0x0f); // Display ON/OFF
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL SUBOPT_0x4
; 0000 017E                             LCD_pos(1,countNum+2);
	MOV  R30,R20
	SUBI R30,-LOW(2)
	RCALL SUBOPT_0x29
; 0000 017F                             LCD_STR(star);
; 0000 0180                              }
; 0000 0181 
; 0000 0182                             if(countNum == 8)//호수 입력하고 비밀번호4자리 입력하면 해당 호수의 비밀번호를 변경 할 수 있도록 한거임.
_0xA2:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0xA3
; 0000 0183                             {change_Password();
	RCALL _change_Password
; 0000 0184                             countNum =0;
	__GETWRN 20,21,0
; 0000 0185                             d1=0;
	CLR  R12
	CLR  R13
; 0000 0186                             LCD_Comm(0x0c); // Display ON/OFF
	RCALL SUBOPT_0x24
; 0000 0187                             countNum =9;
	__GETWRN 20,21,9
; 0000 0188                             }
; 0000 0189 
; 0000 018A                 }
_0xA3:
; 0000 018B                 //d4는 집으로 들어가기위해 #을 누르면 일을 하는 친구임.
; 0000 018C                 if(d4==1){
_0x9D:
	LDS  R26,_d4
	LDS  R27,_d4+1
	SBIW R26,1
	BREQ PC+3
	JMP _0xA4
; 0000 018D                 LCD_Comm(0x0e); // Display ON/OFF
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _LCD_Comm
; 0000 018E                 if(inToLCD <10){countNum++;}
	LDS  R26,_inToLCD
	LDS  R27,_inToLCD+1
	SBIW R26,10
	BRGE _0xA5
	__ADDWRN 20,21,1
; 0000 018F                     if(countNum == 4){
_0xA5:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0xA6
; 0000 0190                     Num_to_int();
	RCALL _Num_to_int
; 0000 0191                         if(sum>1000 & sum <1011) // 위에와 마찬가지로 호수가 있는지 부터 확인하기 위한 작업임.
	RCALL SUBOPT_0x16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __GTW12U
	MOV  R0,R30
	RCALL SUBOPT_0x16
	LDI  R30,LOW(1011)
	LDI  R31,HIGH(1011)
	CALL __LTW12U
	AND  R30,R0
	BREQ _0xA7
; 0000 0192                         {
; 0000 0193                         LCD_pos(0,7);
	RCALL SUBOPT_0x11
; 0000 0194                         LCD_STR("Press PW!");
	__POINTW1MN _0xA8,0
	RCALL SUBOPT_0x1B
; 0000 0195                         LCD_pos(1,1);
	RCALL SUBOPT_0x1C
; 0000 0196                         LCD_STR(PressPW);
	LDI  R30,LOW(_PressPW)
	LDI  R31,HIGH(_PressPW)
	RCALL SUBOPT_0x1B
; 0000 0197                         LCD_pos(1,4);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x27
; 0000 0198                         LCD_Comm(0x0f); // Display ON/OFF
; 0000 0199                         }
; 0000 019A                         else {shap=1; countNum =0;}
	RJMP _0xA9
_0xA7:
	RCALL SUBOPT_0x20
	__GETWRN 20,21,0
_0xA9:
; 0000 019B                     }
; 0000 019C 
; 0000 019D                     // 별로 표시하는 작업 위와 동일함.
; 0000 019E                     if((countNum==5)|(countNum==6)|(countNum==7)|(countNum==8)){
_0xA6:
	RCALL SUBOPT_0x28
	BREQ _0xAA
; 0000 019F                     LCD_Comm(0x0f); // Display ON/OFF
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL SUBOPT_0x4
; 0000 01A0                     LCD_pos(1,countNum-1);
	MOVW R30,R20
	SBIW R30,1
	RCALL SUBOPT_0x29
; 0000 01A1                     LCD_STR(star);
; 0000 01A2                     }
; 0000 01A3                     if(countNum == 8){
_0xAA:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0xAB
; 0000 01A4                     LCD_Comm(0x0c ); // Display ON/OFF
	RCALL SUBOPT_0x24
; 0000 01A5                     countNum =9;
	__GETWRN 20,21,9
; 0000 01A6                     }
; 0000 01A7                     m3=0;
_0xAB:
	CLR  R8
	CLR  R9
; 0000 01A8                     Switch_Verify(); // m3의 값을 받기위해서 스위치값 받는 작업 다시 실행.
	RCALL _Switch_Verify
; 0000 01A9                     if(m3 == 1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0xAC
; 0000 01AA                     Home_password_compare(); // 함수명 그대로 비밀번호 비교하는 거임, 1이면 일치 2이면 불일치.
	RCALL _Home_password_compare
; 0000 01AB                         if(comp ==1){
	LDS  R26,_comp
	LDS  R27,_comp+1
	SBIW R26,1
	BRNE _0xAD
; 0000 01AC                         LCD_pos(1,1);
	RCALL SUBOPT_0x1C
; 0000 01AD                         LCD_STR(rightPW);
	LDI  R30,LOW(_rightPW)
	LDI  R31,HIGH(_rightPW)
	RCALL SUBOPT_0x1B
; 0000 01AE                         SSound(Do);
	RCALL SUBOPT_0x2A
; 0000 01AF                         SSound(Mi);
	RCALL SUBOPT_0x2B
; 0000 01B0                         SSound(Sol);
	RCALL SUBOPT_0x2C
; 0000 01B1                         d4=0;
	RCALL SUBOPT_0x26
; 0000 01B2                         m3=0;
	CLR  R8
	CLR  R9
; 0000 01B3                         countNum=9;
	__GETWRN 20,21,9
; 0000 01B4                         LCD_Comm(0x0c); // Display ON/OFF
	RCALL SUBOPT_0x24
; 0000 01B5                         }
; 0000 01B6 
; 0000 01B7                         if(comp ==2){
_0xAD:
	LDS  R26,_comp
	LDS  R27,_comp+1
	SBIW R26,2
	BRNE _0xAE
; 0000 01B8                         LCD_Clear();
	RCALL _LCD_Clear
; 0000 01B9                         Go_To_Home();
	RCALL _Go_To_Home
; 0000 01BA                         Show_Home_Ho();
	RCALL _Show_Home_Ho
; 0000 01BB                         LCD_pos(0,7);
	RCALL SUBOPT_0x11
; 0000 01BC                         LCD_STR("Press PW!");
	__POINTW1MN _0xA8,10
	RCALL SUBOPT_0x1B
; 0000 01BD                         LCD_pos(1,1);
	RCALL SUBOPT_0x1C
; 0000 01BE                         LCD_STR(PressPW);
	LDI  R30,LOW(_PressPW)
	LDI  R31,HIGH(_PressPW)
	RCALL SUBOPT_0x1B
; 0000 01BF                         LCD_pos(1,4);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x27
; 0000 01C0                         LCD_Comm(0x0f); // Display ON/OFF
; 0000 01C1                         comp=0;
	LDI  R30,LOW(0)
	STS  _comp,R30
	STS  _comp+1,R30
; 0000 01C2                         countNum=4;
	__GETWRN 20,21,4
; 0000 01C3                         SSound(Sol);
	RCALL SUBOPT_0x2C
; 0000 01C4                         SSound(Mi);
	RCALL SUBOPT_0x2B
; 0000 01C5                         SSound(Do);
	RCALL SUBOPT_0x2A
; 0000 01C6                         m3=0;
	CLR  R8
	CLR  R9
; 0000 01C7                         }
; 0000 01C8 
; 0000 01C9                     }
_0xAE:
; 0000 01CA                 }
_0xAC:
; 0000 01CB              }
_0xA4:
; 0000 01CC         }
_0x9B:
	__ADDWRN 16,17,1
	RJMP _0x99
_0x9A:
; 0000 01CD     }
	RJMP _0x92
; 0000 01CE  }
_0xAF:
	RJMP _0xAF

	.DSEG
_0xA8:
	.BYTE 0x14

	.DSEG
_d2:
	.BYTE 0x2
_d4:
	.BYTE 0x2
_inToLCD:
	.BYTE 0x2
_comp:
	.BYTE 0x2
_shap:
	.BYTE 0x2
_homePassword:
	.BYTE 0x14
_num_in:
	.BYTE 0xA
_sum:
	.BYTE 0x2
_comp_ho:
	.BYTE 0x2
_str:
	.BYTE 0x8
_str1:
	.BYTE 0xC
_rightPW:
	.BYTE 0x9
_one:
	.BYTE 0x2
_two:
	.BYTE 0x2
_three:
	.BYTE 0x2
_four:
	.BYTE 0x2
_five:
	.BYTE 0x2
_six:
	.BYTE 0x2
_seven:
	.BYTE 0x2
_eight:
	.BYTE 0x2
_nine:
	.BYTE 0x2
_zero:
	.BYTE 0x2
_star:
	.BYTE 0x2
_PressPW:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	STS  101,R30
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	ORI  R30,1
	STS  101,R30
	__DELAY_USB 246
	LD   R30,Y
	OUT  0x1B,R30
	__DELAY_USB 246
	LDS  R30,101
	ANDI R30,0xFE
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RCALL _LCD_Comm
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP _LCD_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL _LCD_Comm
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x5:
	__GETW1MN _num_in,6
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12U
	__PUTW1R 23,24
	__GETW2MN _num_in,4
	LDI  R30,LOW(100)
	CALL __MULB1W2U
	__ADDWRR 23,24,30,31
	__GETW2MN _num_in,2
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	ADD  R30,R23
	ADC  R31,R24
	LDS  R26,_num_in
	LDS  R27,_num_in+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	__GETW1MN _num_in,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	__GETW1MN _num_in,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__GETW1MN _num_in,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDS  R30,_num_in
	LDS  R31,_num_in+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOVW R18,R30
	MOVW R30,R18
	SBIW R30,1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xF:
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(_homePassword)
	LDI  R27,HIGH(_homePassword)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R20,X+
	LD   R21,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL __DIVW21
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RJMP _LCD_pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x12:
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RJMP _LCD_CHAR

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0xA
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x14:
	ADD  R30,R22
	ADC  R31,R23
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	LDS  R26,_sum
	LDS  R27,_sum+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21U
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x15:
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(_homePassword)
	LDI  R27,HIGH(_homePassword)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	LDS  R26,_sum
	LDS  R27,_sum+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0x16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL __DIVW21U
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x19:
	MOVW R30,R18
	SBIW R30,1
	LDI  R26,LOW(_homePassword)
	LDI  R27,HIGH(_homePassword)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
	STD  Z+1,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _LCD_pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _LCD_STR

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RJMP _LCD_pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _LCD_Comm
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP _LCD_pos

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	STS  _shap,R30
	STS  _shap+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R30,_inToLCD
	LDS  R31,_inToLCD+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _shap,R30
	STS  _shap+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	STS  101,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP _myDelay_us

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LCD_pos
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LCD_pos
	LDI  R30,LOW(_str1)
	LDI  R31,HIGH(_str1)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(12)
	ST   -Y,R30
	RJMP _LCD_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x25:
	CLR  R6
	CLR  R7
	LDI  R30,LOW(0)
	STS  _d2,R30
	STS  _d2+1,R30
	CLR  R4
	CLR  R5
	CLR  R12
	CLR  R13
	CLR  R8
	CLR  R9
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(0)
	STS  _d4,R30
	STS  _d4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	RCALL _LCD_pos
	LDI  R30,LOW(15)
	ST   -Y,R30
	RJMP _LCD_Comm

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x28:
	MOVW R26,R20
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	OR   R0,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	OR   R0,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	RCALL _LCD_pos
	LDI  R30,LOW(_star)
	LDI  R31,HIGH(_star)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(477)
	LDI  R31,HIGH(477)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _SSound

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(378)
	LDI  R31,HIGH(378)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _SSound

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(318)
	LDI  R31,HIGH(318)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _SSound


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__GTW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLO __GTW12UT
	CLR  R30
__GTW12UT:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
