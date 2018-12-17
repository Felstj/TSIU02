/*
 * stegvis.asm
 *
 *  Created: 12/17/2018 8:19:22 AM
 *   Author: felst140
 */ 

 jmp INIT
 jmp MUX



 INIT:
	ldi ZL,LOW(RAMEND)
	out SPL,r16
	ldi ZH,HIGH(RAMEND)
	out SPH,r16

	ldi r16,$FF
	out DDRB,r16

	ldi r16,$FC
	out DDRA,r16

	;----INTERRUPTS----;
	ldi r16, $0F;(1<<ISC00) | (1<<ISC01)
	out MCUCR,r16
	ldi r16, (1<<INT0)
	out GICR,r16 
	sei ; display on

	ldi r23,$00

	ldi r17,$8
	clr r19
	ldi r20,$FF

	

	
LOOP:
	ldi r16,(1<<adlar)
	out admux,r16
	ldi r16,(3<<ADPS0)|(1<<ADEN)|(1<<ADSC)
	out adcsra,r16
WAIT:
	sbic adcsra,adsc
	rjmp WAIT
	in r16,ADCH

	out PORTB,r17
	

	cp r16,r19
	breq LEFT
	cp r16,r20
	breq RIGHT
	jmp LOOP
	


RIGHT:
	lsr r17
	call DELAY
	out PORTB,r17
	call DELAY
	rjmp LOOP

LEFT:
	lsl r17
	call DELAY
	out PORTB,r17
	call DELAY
	rjmp LOOP	
	
	
DELAY:
	ldi r21,$F0
delayYttreLoop:
	ldi r22,$F0
delayInreLoop:
	dec r22
	brne delayInreLoop
	dec r21
	brne delayYttreLoop
	ret

MUX:
	push r16
	in r16,SREG
	push r16
    push ZL
	push ZH
	
	

	inc r24
	ldi ZL,LOW(TABBE*2)
	ldi ZH,HIGH(TABBE*2)

	add ZL,r24


	LPM r23,Z
	
	cpi r24,$05
	brne FORTS
	clr r24
FORTS:
	out PORTA,r23

	
	
	pop ZH
	pop ZL
	pop r16
	out SREG,r16
	pop r16

	reti
	

TABBE:
	.db $00,$10,$20,$30,$40;,$40

