
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _Tcount=R4
	.DEF _adc_data=R7
	.DEF _Fled=R6
	.DEF _Foldled=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0xA:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  _0xA*2
<<<<<<< HEAD

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2
=======
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;����� ������������ ��� ������������ Arduino �� �������
;����������� � ������������ 16 ���
;
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 02.01.2019
;Author  : PerTic@n
;Company : If You Like This Software,Buy It
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// Alphanumeric LCD functions
<<<<<<< HEAD
;#include <alcd.h>
;#define Tstep 1000          //�� ���������  (int Tcountint Tcount=Tstep) * ����� ������ [TIM0_OVF] = ����� 1 ���
;#define Testled PORTB.5
=======
;//#include <alcd.h>   // ��� LCD �� CWision
;#define Tstep 1000          //�� ���������  (int Tcountint Tcount=Tstep) * ����� ������ [TIM0_OVF] = ����� 1 ���
;#define Testled PORTB.5     // �������� ��-���� �� ����� arduino
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52
;
;#define RS  PORTB.0
;#define E   PORTB.1
;#define D4  PORTD.4
;#define D5  PORTD.5
;#define D6  PORTD.6
;#define D7  PORTD.7 //9877654321
;int Tcount = 0;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)  //���������� �� ������������ �� 1 ��
<<<<<<< HEAD
; 0000 0025 {
=======
; 0000 002E {
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
<<<<<<< HEAD
; 0000 0026 // Reinitialize Timer 0 value
; 0000 0027 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0028 // Place your code here
; 0000 0029 Tcount+=1;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 002A if (Tcount == Tstep) {
=======
; 0000 002F //----------- Reinitialize Timer 0x06 value for the interrapt 1 ms
; 0000 0030 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0031 // Place your code here
; 0000 0032 Tcount+=1;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0033 if (Tcount == Tstep) {
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x3
<<<<<<< HEAD
; 0000 002B Tcount = 0;                // ��������� ��� 1 ������� ����
	CLR  R4
	CLR  R5
; 0000 002C  Testled^=1;               //������������� ���������
=======
; 0000 0034 Tcount = 0;                // ��������� ��� 1 ������� ����
	CLR  R4
	CLR  R5
; 0000 0035  Testled^=1;               //������������� ���������
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52
	LDI  R26,0
	SBIC 0x18,5
	LDI  R26,1
	LDI  R30,LOW(1)
	EOR  R30,R26
	BRNE _0x4
	CBI  0x18,5
	RJMP _0x5
_0x4:
	SBI  0x18,5
_0x5:
<<<<<<< HEAD
; 0000 002D };
_0x3:
; 0000 002E 
; 0000 002F }
=======
; 0000 0036 };
_0x3:
; 0000 0037 //-----------------------------------------------------------------
; 0000 0038 }
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;unsigned char adc_data;
;#define ADC_VREF_TYPE 0x60
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
<<<<<<< HEAD
; 0000 0036 {
_adc_isr:
; 0000 0037 // Read the 8 most significant bits
; 0000 0038 // of the AD conversion result
; 0000 0039 adc_data=ADCH;
	IN   R7,5
; 0000 003A }
=======
; 0000 003F {
_adc_isr:
; 0000 0040 // Read the 8 most significant bits
; 0000 0041 // of the AD conversion result
; 0000 0042 adc_data=ADCH;
	IN   R7,5
; 0000 0043 }
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52
	RETI
;
;// Read the 8 most significant bits
;// of the AD conversion result
;// with noise canceling
;unsigned char read_adc(unsigned char adc_input)
<<<<<<< HEAD
; 0000 0040 {
; 0000 0041 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 0042 // Delay needed for the stabilization of the ADC input voltage
; 0000 0043 delay_us(10);
; 0000 0044 #asm
; 0000 0045     in   r30,mcucr
; 0000 0046     cbr  r30,__sm_mask
; 0000 0047     sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0048     out  mcucr,r30
; 0000 0049     sleep
; 0000 004A     cbr  r30,__se_bit
; 0000 004B     out  mcucr,r30
; 0000 004C #endasm
; 0000 004D return adc_data;
; 0000 004E }
=======
; 0000 0049 {
; 0000 004A ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 004B // Delay needed for the stabilization of the ADC input voltage
; 0000 004C delay_us(10);
; 0000 004D #asm
; 0000 004E     in   r30,mcucr
; 0000 004F     cbr  r30,__sm_mask
; 0000 0050     sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0051     out  mcucr,r30
; 0000 0052     sleep
; 0000 0053     cbr  r30,__se_bit
; 0000 0054     out  mcucr,r30
; 0000 0055 #endasm
; 0000 0056 return adc_data;
; 0000 0057 }
;void send_LCD(char RS_value,char DB4_value,char DB5_value,char DB6_value,char DB7_value) {
; 0000 0058 void send_LCD(char RS_value,char DB4_value,char DB5_value,char DB6_value,char DB7_value) {
; 0000 0059 int t;
; 0000 005A }
;
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52
;
;// Declare your global variables here
;char Fled = 0; // ���� ��� �����
;char Foldled = 0; // ���� ��� �����
;
;void main(void)
<<<<<<< HEAD
; 0000 0055 {
_main:
; 0000 0056 // Declare your local variables here
; 0000 0057 
; 0000 0058 // Input/Output Ports initialization
; 0000 0059 // Port B initialization
; 0000 005A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 005B // State7=T State6=T State5=T State4=T State3=T State2=P State1=0 State0=0
; 0000 005C // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 005D // State7=T State6=T State5=0 State4=T State3=T State2=P State1=0 State0=0
; 0000 005E PORTB=0x04;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 005F DDRB=0x23;//DDRB=0x03;
	LDI  R30,LOW(35)
	OUT  0x17,R30
; 0000 0060 
; 0000 0061 // Port C initialization
; 0000 0062 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0063 // State6=P State5=P State4=P State3=P State2=P State1=P State0=T
; 0000 0064 PORTC=0x7E;
	LDI  R30,LOW(126)
	OUT  0x15,R30
; 0000 0065 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0066 
; 0000 0067 // Port D initialization
; 0000 0068 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0069 // State7=0 State6=0 State5=0 State4=0 State3=P State2=P State1=P State0=P
; 0000 006A PORTD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 006B DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 006C 
; 0000 006D // Timer/Counter 0 initialization
; 0000 006E // Clock source: System Clock
; 0000 006F // Clock value: 250,000 kHz
; 0000 0070 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0071 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0072 
; 0000 0073 // Timer/Counter 1 initialization
; 0000 0074 // Clock source: System Clock
; 0000 0075 // Clock value: Timer1 Stopped
; 0000 0076 // Mode: Normal top=0xFFFF
; 0000 0077 // OC1A output: Discon.
; 0000 0078 // OC1B output: Discon.
; 0000 0079 // Noise Canceler: Off
; 0000 007A // Input Capture on Falling Edge
; 0000 007B // Timer1 Overflow Interrupt: Off
; 0000 007C // Input Capture Interrupt: Off
; 0000 007D // Compare A Match Interrupt: Off
; 0000 007E // Compare B Match Interrupt: Off
; 0000 007F TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0080 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0081 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0082 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0083 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0084 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0085 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0086 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0087 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0088 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0089 
; 0000 008A // Timer/Counter 2 initialization
; 0000 008B // Clock source: System Clock
; 0000 008C // Clock value: Timer2 Stopped
; 0000 008D // Mode: Normal top=0xFF
; 0000 008E // OC2 output: Disconnected
; 0000 008F ASSR=0x00;
	OUT  0x22,R30
; 0000 0090 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0091 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0092 OCR2=0x00;
	OUT  0x23,R30
; 0000 0093 
; 0000 0094 // External Interrupt(s) initialization
; 0000 0095 // INT0: Off
; 0000 0096 // INT1: Off
; 0000 0097 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0098 
; 0000 0099 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 009A TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 009B 
; 0000 009C // USART initialization
; 0000 009D // USART disabled
; 0000 009E UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 009F 
; 0000 00A0 // Analog Comparator initialization
; 0000 00A1 // Analog Comparator: Off
; 0000 00A2 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00A3 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A4 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00A5 
; 0000 00A6 // ADC initialization
; 0000 00A7 // ADC Clock frequency: 125,000 kHz
; 0000 00A8 // ADC Voltage Reference: AVCC pin
; 0000 00A9 // Only the 8 most significant bits of
; 0000 00AA // the AD conversion result are used
; 0000 00AB ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 00AC ADCSRA=0x8F;
	LDI  R30,LOW(143)
	OUT  0x6,R30
; 0000 00AD 
; 0000 00AE // SPI initialization
; 0000 00AF // SPI disabled
; 0000 00B0 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00B1 
; 0000 00B2 // TWI initialization
; 0000 00B3 // TWI disabled
; 0000 00B4 TWCR=0x00;
	OUT  0x36,R30
; 0000 00B5 
; 0000 00B6 // Alphanumeric LCD initialization
; 0000 00B7 // Connections are specified in the
; 0000 00B8 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00B9 // RS - PORTB Bit 0
; 0000 00BA // RD - PORTB Bit 3
; 0000 00BB // EN - PORTB Bit 1
; 0000 00BC // D4 - PORTD Bit 4
; 0000 00BD // D5 - PORTD Bit 5
; 0000 00BE // D6 - PORTD Bit 6
; 0000 00BF // D7 - PORTD Bit 7
; 0000 00C0 // Characters/line: 16
; 0000 00C1 //lcd_init(16);      //���� ���� � � ����������� �������������� ����� (�5)?
; 0000 00C2 
; 0000 00C3 // Global enable interrupts
; 0000 00C4 #asm("sei")
	sei
; 0000 00C5 
; 0000 00C6 while (1)
_0x6:
; 0000 00C7       {
; 0000 00C8       // Place your code here
; 0000 00C9 
; 0000 00CA 
; 0000 00CB 
; 0000 00CC       }
	RJMP _0x6
; 0000 00CD }
_0x9:
	RJMP _0x9
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG

	.DSEG
__base_y_G100:
	.BYTE 0x4
=======
; 0000 0062 {
_main:
; 0000 0063 // Declare your local variables here
; 0000 0064 
; 0000 0065 // Input/Output Ports initialization
; 0000 0066 // Port B initialization
; 0000 0067 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 0068 // State7=T State6=T State5=T State4=T State3=T State2=P State1=0 State0=0
; 0000 0069 // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 006A // State7=T State6=T State5=0 State4=T State3=T State2=P State1=0 State0=0
; 0000 006B PORTB=0x04;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 006C DDRB=0x23;//DDRB=0x03;
	LDI  R30,LOW(35)
	OUT  0x17,R30
; 0000 006D 
; 0000 006E // Port C initialization
; 0000 006F // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0070 // State6=P State5=P State4=P State3=P State2=P State1=P State0=T
; 0000 0071 PORTC=0x7E;
	LDI  R30,LOW(126)
	OUT  0x15,R30
; 0000 0072 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0073 
; 0000 0074 // Port D initialization
; 0000 0075 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0076 // State7=0 State6=0 State5=0 State4=0 State3=P State2=P State1=P State0=P
; 0000 0077 PORTD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0078 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0079 
; 0000 007A // Timer/Counter 0 initialization
; 0000 007B // Clock source: System Clock
; 0000 007C // Clock value: 250,000 kHz
; 0000 007D TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 007E TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 007F 
; 0000 0080 // Timer/Counter 1 initialization
; 0000 0081 // Clock source: System Clock
; 0000 0082 // Clock value: Timer1 Stopped
; 0000 0083 // Mode: Normal top=0xFFFF
; 0000 0084 // OC1A output: Discon.
; 0000 0085 // OC1B output: Discon.
; 0000 0086 // Noise Canceler: Off
; 0000 0087 // Input Capture on Falling Edge
; 0000 0088 // Timer1 Overflow Interrupt: Off
; 0000 0089 // Input Capture Interrupt: Off
; 0000 008A // Compare A Match Interrupt: Off
; 0000 008B // Compare B Match Interrupt: Off
; 0000 008C TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 008D TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 008E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 008F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0090 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0091 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0092 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0093 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0094 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0095 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0096 
; 0000 0097 // Timer/Counter 2 initialization
; 0000 0098 // Clock source: System Clock
; 0000 0099 // Clock value: Timer2 Stopped
; 0000 009A // Mode: Normal top=0xFF
; 0000 009B // OC2 output: Disconnected
; 0000 009C ASSR=0x00;
	OUT  0x22,R30
; 0000 009D TCCR2=0x00;
	OUT  0x25,R30
; 0000 009E TCNT2=0x00;
	OUT  0x24,R30
; 0000 009F OCR2=0x00;
	OUT  0x23,R30
; 0000 00A0 
; 0000 00A1 // External Interrupt(s) initialization
; 0000 00A2 // INT0: Off
; 0000 00A3 // INT1: Off
; 0000 00A4 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00A5 
; 0000 00A6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A7 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00A8 
; 0000 00A9 // USART initialization
; 0000 00AA // USART disabled
; 0000 00AB UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00AC 
; 0000 00AD // Analog Comparator initialization
; 0000 00AE // Analog Comparator: Off
; 0000 00AF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00B0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B2 
; 0000 00B3 // ADC initialization
; 0000 00B4 // ADC Clock frequency: 125,000 kHz
; 0000 00B5 // ADC Voltage Reference: AVCC pin
; 0000 00B6 // Only the 8 most significant bits of
; 0000 00B7 // the AD conversion result are used
; 0000 00B8 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 00B9 ADCSRA=0x8F;
	LDI  R30,LOW(143)
	OUT  0x6,R30
; 0000 00BA 
; 0000 00BB // SPI initialization
; 0000 00BC // SPI disabled
; 0000 00BD SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00BE 
; 0000 00BF // TWI initialization
; 0000 00C0 // TWI disabled
; 0000 00C1 TWCR=0x00;
	OUT  0x36,R30
; 0000 00C2 
; 0000 00C3 // Alphanumeric LCD initialization
; 0000 00C4 // Connections are specified in the
; 0000 00C5 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00C6 // RS - PORTB Bit 0
; 0000 00C7 // RD - PORTB Bit 3
; 0000 00C8 // EN - PORTB Bit 1
; 0000 00C9 // D4 - PORTD Bit 4
; 0000 00CA // D5 - PORTD Bit 5
; 0000 00CB // D6 - PORTD Bit 6
; 0000 00CC // D7 - PORTD Bit 7
; 0000 00CD // Characters/line: 16
; 0000 00CE //lcd_init(16);      //���� ���� � � ����������� �������������� ����� (�5)?
; 0000 00CF 
; 0000 00D0 // Global enable interrupts
; 0000 00D1 #asm("sei")
	sei
; 0000 00D2 
; 0000 00D3 while (1)
_0x6:
; 0000 00D4       {
; 0000 00D5       // Place your code here
; 0000 00D6       #asm("cli")		// �������� ����������
	cli
; 0000 00D7 		delay_us(150); 	// ����������� �������� 150 ���
	__DELAY_USW 600
; 0000 00D8 		//...
; 0000 00D9 		delay_ms(15); 	// ����������� �������� 15 ��
	LDI  R26,LOW(15)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00DA 		#asm("sei")		// �������� ����������
	sei
; 0000 00DB 
; 0000 00DC 
; 0000 00DD 
; 0000 00DE       }
	RJMP _0x6
; 0000 00DF }
_0x9:
	RJMP _0x9
>>>>>>> 26f834e02d95aff3293ec1887c93d6317de84a52

	.CSEG

	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
