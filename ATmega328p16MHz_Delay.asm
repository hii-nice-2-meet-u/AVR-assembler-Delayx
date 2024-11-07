
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;$ [ MEGA328P ]
;*
;*		File	:	ATmega328p16MHz_Delay.asm
;*		Release		:	v1.0
;*		Date		:	Tue 07 Nov 2024
;*
;*		Write, Improve, Edit  by hii
;*
;*		[ Contact Information ]
;*		G-mail		:	0x0.whitecat@gmail.com
;*		Discord		:	@hii_nice.2.meet.u
;*		Github		:	https:github.com/hii-nice-2-meet-u
;*

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;- link Clock Cycle Calculation : https://docs.google.com/spreadsheets/d/1Gf-PrrAeJ54bnab67ngiJQ6b6_vJOCGqP-2Q-5yNoVo/edit?usp=sharing

;^ --------------------------------------------------------------------------------------------------------------------------------

.def	i_r		=	r23				;' [ i loop ] register 8b			{ r23 }
.def	j_rL	=	r24				;" [ j loop ] register 16b-LOW		{ r24 }
.def	j_rH	=	r25				;" [ j loop ] register 16b-HIGH		{ r25 }

;^ --------------------------------------------------------------------------------------------------------------------------------

.equ	iVal_10ms	=	14				;' [ i loop ] loop value	{ 0b 0000 1110				} | { $0E		} | { 14	}	for 0.01	sec	|	10		ms
.equ	jVal_10ms	=	2856			;" [ j loop ] loop value	{ 0b 0000 1011 0010 1000	} | { $0B 28	} | { 2856	}	for 0.01	sec	|	10		ms

;!	[ !ERROR 0.0250% | -4 cycle ]
.equ	iVal_100ms	=	29				;' [ i loop ] cycle loop value	{ 0b 0001 1101				} | { $1D		} | { 29	}	for 0.1		sec	|	100		ms	[ !ERROR 0.0250% | -4 cycle ]
.equ	jVal_100ms	=	13792			;" [ j loop ] cycle loop value	{ 0b 0011 0101 1110 0000	} | { $35 E0	} | { 13792	}	for 0.1		sec	|	100		ms	[ !ERROR 0.0250% | -4 cycle ]

.equ	iVal_1s	=	142					;' [ i loop ] loop value	{ 0b 1000 1110				} | { $8E		} | { 142	}	for 1.0		sec	|	1000	ms
.equ	jVal_1s	=	28168				;" [ j loop ] loop value	{ 0b 0110 1110 0000 1000	} | { $6E 08	} | { 28168 }	for 1.0		sec	|	1000	ms

;^ --------------------------------------------------------------------------------------------------------------------------------

;$		delay_10ms			:	delay 0.01 sec

delay_10ms:
	ldi	i_r, iVal_10ms						;' LOAD		|	Set i_value						|	i_r		<- i_value

	iLoop_10ms:								;- iloop    [ i ]
		ldi	j_rL,	LOW(jVal_10ms)			;" LOAD		|	Set j_value[ low byte ]			|	j_rL	<- LOW(  j_value )	
		ldi	j_rH,	HIGH(jVal_10ms)			;" LOAD		|	Set j_value[ high byte ]		|	j_rH	<- HIGH( j_value )

			jLoop_10ms:						;- jloop    [ j ]
				sbiw	j_rL,	1			;" [ - ]	|	Decress j_value		[ -1 ]		|	j_r - 1
				brne	jLoop_10ms			;" JUMP		|	Jump to jloop		[ j ]		|	JUMP if ( j_r != 0 )

			dec		i_r						;' [ - ]	|	Decress i_value		[ -1 ]		|	i_r - 1
			brne	iLoop_10ms				;' JUMP		|	Jump to iLoop		[ i ]		|	JUMP if ( i_r != 0 )
ret		

;$		delay_100ms			:	delay 0.1 sec

delay_100ms:
	ldi	i_r, iVal_100ms						;' LOAD		|	Set i_value						|	i_r		<- i_value

	iLoop_100ms:							;- iloop    [ i ]
		ldi	j_rL,	LOW(jVal_100ms)			;" LOAD		|	Set j_value[ low byte ]			|	j_rL	<- LOW(  j_value )	
		ldi	j_rH,	HIGH(jVal_100ms)		;" LOAD		|	Set j_value[ high byte ]		|	j_rH	<- HIGH( j_value )

			jLoop_100ms:						;- jloop    [ j ]
				sbiw	j_rL,	1			;" [ - ]	|	Decress j_value		[ -1 ]		|	j_r - 1
				brne	jLoop_100ms			;" JUMP		|	Jump to jloop		[ j ]		|	JUMP if ( j_r != 0 )

			dec		i_r						;' [ - ]	|	Decress i_value		[ -1 ]		|	i_r - 1
			brne	iLoop_100ms				;' JUMP		|	Jump to iLoop		[ i ]		|	JUMP if ( i_r != 0 )
ret		

;$		delay_1s			:	delay 1 sec

delay_1s:
	ldi	i_r, iVal_1s						;' LOAD		|	Set i_value						|	i_r		<- i_value

	iLoop_1s:								;- iloop    [ i ]
		ldi	j_rL,	LOW(jVal_1s)			;" LOAD		|	Set j_value[ low byte ]			|	j_rL	<- LOW(  j_value )	
		ldi	j_rH,	HIGH(jVal_1s)			;" LOAD		|	Set j_value[ high byte ]		|	j_rH	<- HIGH( j_value )

			jLoop_1s:						;- jloop    [ j ]
				sbiw	j_rL,	1			;" [ - ]	|	Decress j_value		[ -1 ]		|	j_r - 1
				brne	jLoop_1s			;" JUMP		|	Jump to jloop		[ j ]		|	JUMP if ( j_r != 0 )

			dec		i_r						;' [ - ]	|	Decress i_value		[ -1 ]		|	i_r - 1
			brne	iLoop_1s				;' JUMP		|	Jump to iLoop		[ i ]		|	JUMP if ( i_r != 0 )
ret		

;$ -----------------------------------------------------------------

.undef	i_r
.undef	j_rL
.undef	j_rH

;^ --------------------------------------------------------------------------------------------------------------------------------
;& delayx		[ __MACRO__ ]


;$		delay		:	delay : parameter[ @0 ] * delay_100ms[ 0.1 ]
;@		__delayx__
;@			{ r22 } - [ delay ] register 8b
;@			{ @0  } - [ delay ] parameter
;!	[ !ERROR ~ 2-3 cycle ]	[ 0.1 sec ]

.macro	delayx

	ldi		r22,	@0						;' set parameter	[ @0 ]

	delayxLoop:								;- delayxLoop		[ delayx ]
		call 	delay_100ms					;" CALL		|	Jump to nap			[ nap ]
		dec 	r22							;' [ - ]	|	Decress value on delayx_r		[ -1 ]		|	delayx_r - 1
		brne 	delayxLoop					;' JUMP		|	Jump to delayxLoop		[ delayx ]			|	JUMP if ( snz_r != 0 )

.endmacro

;-	Example
;/	delayx		500			; delay 50 sec
;/	delayx		5			; delay 0.5 sec

;$ ----------------------------------------------------------------
;^ --------------------------------------------------------------------------------------------------------------------------------
