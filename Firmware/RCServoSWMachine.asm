;====================================================================================================
;
;   Filename:	RCServoSWMachine.asm
;   Date:	9/18/2017
;   File Version:	1.0b1
;
;    Author:	David M. Flynn
;    Company:	Oxford V.U.E., Inc.
;    E-Mail:	dflynn@oxfordvue.com
;    Web Site:	http://www.oxfordvue.com/
;
;====================================================================================================
;    RC Servo Switch Machine for PIC12F1822
;
;    History:
;
; 1.0b1   9/18/2017    RC1, Looks like it works.
; 1.0d1   2/24/2016	Copied from RCServoTester1822
; 1.0a4   11/16/2015	Works as a servo tester w/ the PCB.  I2C is not tested/working.
; 1.0a3   1/15/2015	Added I2C slave
; 1.0a2   1/11/2015	Added Center button.
; 1.0a1   1/10/2015	First working tests.
; 1.0d1   9/4/2014	First Code.
;
;====================================================================================================
; Options
;====================================================================================================
; To Do's
;
; Move slowly. Compare dest w/ current adjust current to be dest.
; Adjust by 40counts / pulse = max move time 1 second
;
;====================================================================================================
;====================================================================================================
; What happens next:
;
;   The system LED blinks once per second
;   Once at power-up: 
;
;  Setup mode:
;   If SW1 is pressed Increment the set value for the control condition.
;   If SW2 is pressed Decrement the set value for the control condition.
;
;   If Control is High (active)
;      move to set point 1 turn on feedback, Aux and Relays
;   else if Control is Low (Normal, Inactive)
;      move to set point 2 turn off feedback, Aux and Relays
;
;   CCP1 outputs a 1100uS to 1900uS (2200..3600 counts) pulse every 16,000uS
;
;   Resolution is 0.5uS
;
;====================================================================================================
;
;  Pin 1 VDD (+5V)		+5V
;  Pin 2 RA5		CCP1
;  Pin 3 RA4		System LED Active Low/SW2 Dec switch Active Low
;  Pin 4 RA3/MCLR*/Vpp (Input only)	Command = Active High
;  Pin 5 RA2		LED 2 Active Low/SW1 Inc switch Active Low
;  Pin 6 RA1/ICSPCLK		Feedback Active High Output
;  Pin 7 RA0/ICSPDAT		Relay Control Active High Output
;  Pin 8 VSS (Ground)		Ground
;
;====================================================================================================
;
;
	list	p=12f1822,r=hex,w=1	; list directive to define processor
;
	nolist
	include	p12f1822.inc	; processor specific variable definitions
	list
;
	__CONFIG _CONFIG1,_FOSC_INTOSC & _WDTE_OFF & _MCLRE_OFF & _IESO_OFF
;
;
;
; INTOSC oscillator: I/O function on CLKIN pin
; WDT disabled
; PWRT disabled
; MCLR/VPP pin function is digital input
; Program memory code protection is disabled
; Data memory code protection is disabled
; Brown-out Reset enabled
; CLKOUT function is disabled. I/O or oscillator function on the CLKOUT pin
; Internal/External Switchover mode is disabled
; Fail-Safe Clock Monitor is enabled
;
	__CONFIG _CONFIG2,_WRT_OFF & _PLLEN_OFF & _LVP_OFF
;
; Write protection off
; 4x PLL disabled
; Stack Overflow or Underflow will cause a Reset
; Brown-out Reset Voltage (Vbor), low trip point selected.
; Low-voltage programming Disabled ( allow MCLR to be digital in )
;  *** must set apply Vdd before Vpp in ICD 3 settings ***
;
; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.
;
	constant	oldCode=0
	constant	useRS232=0
;
#Define	_C	STATUS,C
#Define	_Z	STATUS,Z
;
; 0.5uS res counter from 8MHz OSC
CCP1CON_Clr	EQU	b'00001001'	;Clear output on match
CCP1CON_Set	EQU	b'00001000'	;Set output on match
;
kOffsetCtrValue	EQU	d'2047'
kMinPulseWidth	EQU	d'1800'	;900uS
kMidPulseWidth	EQU	d'3000'	;1500uS
kMaxPulseWidth	EQU	d'4200'	;2100uS
kServoDwellTime	EQU	d'40000'	;20mS
;
;====================================================================================================
	nolist
	include	F1822_Macros.inc
	list
;
;    Port A bits
PortADDRBits	EQU	b'11011100'
#Define	RelayDrvrBit	LATA,0	;Active High Output
#Define	FeedbackBit	LATA,1	;Active High Output
#Define	LED2	LATA,2	;Output: 0=LED ON, Input: 0 = Switch Pressed
#Define	LED2TrisBit	TRISA,2
#Define	IncBtnBit	PORTA,2
#Define	CmdInputBit	PORTA,3
#Define	SystemLED	LATA,4	;Output: 0=LED ON, Input: 0 = Switch Pressed
#Define	SysLEDTrisBit	TRISA,4
#Define	DecBtnBit	PORTA,4
#Define	RA5_In	PORTA,5	;CCP1
;
PortAValue	EQU	b'00000000'
;
;====================================================================================================
;====================================================================================================
;
;Constants
All_In	EQU	0xFF
All_Out	EQU	0x00
;
LEDTIME	EQU	d'100'	;1.00 seconds
LEDErrorTime	EQU	d'10'
;
T1CON_Val	EQU	b'00000001'	;PreScale=1,Fosc/4,Timer ON
;T1CON_Val	EQU	b'00100001'	;PreScale=4,Fosc/4,Timer ON
OSCCON_Value	EQU	b'01110010'	;8MHz
;OSCCON_Value	EQU	b'11110000'	;32MHz
T2CON_Value	EQU	b'01001110'	;T2 On, /16 pre, /10 post
;T2CON_Value	EQU	b'01001111'	;T2 On, /64 pre, /10 post
PR2_Value	EQU	.125
;
;
CCP1CON_Value	EQU	0x00	;CCP1 off
;
DebounceTime	EQU	d'10'
;
;================================================================================================
;***** VARIABLE DEFINITIONS
; there are 128 bytes of ram, Bank0 0x20..0x7F, Bank1 0xA0..0xBF
; there are 256 bytes of EEPROM starting at 0x00 the EEPROM is not mapped into memory but
;  accessed through the EEADR and EEDATA registers
;================================================================================================
;  Bank0 Ram 020h-06Fh 80 Bytes
;
	cblock	0x20
;
	ISR_Temp		;scratch mem
	LED_Time
	LED2_Time	
	LED_Ticks		;Timer tick count
	LED2_Ticks
;
;
	EEAddrTemp		;EEProm address to read or write
	EEDataTemp		;Data to be writen to EEProm
;
;
	Timer1Lo		;1st 16 bit timer
	Timer1Hi		; one second RX timeiout
	Timer2Lo		;2nd 16 bit timer
	Timer2Hi		;
	Timer3Lo		;3rd 16 bit timer
	Timer3Hi		;GP wait timer
	Timer4Lo		;4th 16 bit timer
	Timer4Hi		; debounce timer
;
	Dest:2
;
	Position1:2
	Position2:2
	SysFlags
;
	Debounce
;
	endc
;
#Define	PulseSent	SysFlags,0
;
#Define	FirstRAMParam	Position1
#Define	LastRAMParam	SysFlags
;
;================================================================================================
;  Bank1 Ram 0A0h-0BFh 32 Bytes
;
;
;=======================================================================================================
;  Common Ram 70-7F same for all banks
;      except for ISR_W_Temp these are used for paramiter passing and temp vars
;=======================================================================================================
;
	cblock	0x70
	SigOutTime
	SigOutTimeH
	Flags
;Globals from I2C_SLAVE.inc
	Param73
	Param74
;
	CalcdDwell
	CalcdDwellH
	Param77
	Param78
	Param79
	Param7A
	Param7B
	Param7C
	Param7D
	Param7E
	Param7F
	endc
;
; Flags bits
#Define	IncBtnFlag	Flags,0
#Define	DecBtnFlag	Flags,1
#Define	LED2Flag	Flags,2
#Define	DataChangedFlag	Flags,3
#Define	ServoOff	Flags,4
#Define	SMRevFlag	Flags,5
#Define	NewSWData	Flags,6
;
;
;=========================================================================================
;Conditionals
HasISR	EQU	0x80	;used to enable interupts 0x80=true 0x00=false
;
;=========================================================================================
;==============================================================================================
; ID Locations
	__idlocs	0x10A2
;
;==============================================================================================
; EEPROM locations (NV-RAM) 0x00..0x7F (offsets)
	org	0xF000
;
	de	LOW kMidPulseWidth	;nvPosition1Lo
	de	HIGH kMidPulseWidth
	de	LOW kMidPulseWidth
	de	HIGH kMidPulseWidth
;
	de	0x00
;
	cblock	0x00
	nvPosition1Lo
	nvPosition1Hi
	nvPosition2Lo
	nvPosition2Hi
;
	nvSysFlags
	endc
;
#Define	nvFirstParamByte	nvPosition1Lo
#Define	nvLastParamByte	nvSysFlags
;
;
;==============================================================================================
;============================================================================================
;
;
	ORG	0x000	; processor reset vector
	CLRF	STATUS
	CLRF	PCLATH
  	goto	start	; go to beginning of program
;
;===============================================================================================
; Interupt Service Routine
;
; we loop through the interupt service routing every 0.008192 seconds
;
;
	ORG	0x004	; interrupt vector location
	movlb	0	; bank0
;
	btfss	PIR1,TMR2IF
	goto	IRQ_2
	bcf	PIR1,TMR2IF	; reset interupt flag bit
;
;Decrement timers until they are zero
; 
	CLRF	FSR0H
	call	DecTimer1	;if timer 1 is not zero decrement
	call	DecTimer2
	call	DecTimer3
	call	DecTimer4
;
;-----------------------------------------------------------------
; blink LEDs
	BankSel	TRISA
	BSF	SysLEDTrisBit	;LED off
	BSF	LED2TrisBit	;LED2 off
;
	BankSel	PORTA	;bank 0
	BCF	IncBtnFlag
	BTFSS	IncBtnBit
	BSF	IncBtnFlag
;
	BCF	DecBtnFlag
	BTFSS	DecBtnBit
	BSF	DecBtnFlag
;
	bsf	NewSWData
;
SystemBlink_1	DECFSZ	LED_Ticks,F
	bra	SystemBlink_end
;
	MOVF	LED_Time,W
	movwf	LED_Ticks
;
	BankSel	TRISA
	BCF	SysLEDTrisBit	;LED on
SystemBlink_end	MOVLB	0
;
	decfsz	LED2_Ticks,F
	bra	LED2_End
;
	MOVF	LED2_Time,W
	movwf	LED2_Ticks
;
	BankSel	TRISA
	BTFSC	LED2Flag
	BCF	LED2TrisBit
;
LED2_End	MOVLB	0
;-----------------------------------------------------------------
;
IRQ_2:
;==================================================================================
;
; Handle CCP1 Interupt Flag, Enter w/ bank 0 selected
;
IRQ_Servo1	MOVLB	0	;bank 0
	BTFSS	PIR1,CCP1IF
	GOTO	IRQ_Servo1_End
;
	BTFSS	ServoOff	;Are we sending a pulse?
	GOTO	IRQ_Servo1_1	; Yes
;
;Oops, how did we get here???
	MOVLB	0x05                   ;Bank 5
	CLRF	CCP1CON
	GOTO	IRQ_Servo1_X
;
IRQ_Servo1_1	BSF	PulseSent
	MOVLB	0x05                   ;Bank 5
	BTFSC	CCP1CON,CCP1M0	;Set output on match?
	GOTO	IRQ_Servo1_OL	; No
; An output just went high
;
	MOVF	SigOutTime,W	;Put the pulse into the CCP reg.
	ADDWF	CCPR1L,F
	MOVF	SigOutTime+1,W
	ADDWFC	CCPR1H,F
	MOVLW	CCP1CON_Clr	;Clear output on match
	MOVWF	CCP1CON	;CCP1 clr on match
;Calculate dwell time
	MOVLW	LOW kServoDwellTime
	MOVWF	CalcdDwell
	MOVLW	HIGH kServoDwellTime
	MOVWF	CalcdDwellH
	MOVF	SigOutTime,W
	SUBWF	CalcdDwell,F
	MOVF	SigOutTime+1,W
	SUBWFB	CalcdDwellH,F
	GOTO	IRQ_Servo1_X
;
; output went low so this cycle is done
IRQ_Servo1_OL	MOVLW	LOW kServoDwellTime
	ADDWF	CCPR1L,F
	MOVLW	HIGH kServoDwellTime
	ADDWFC	CCPR1H,F
;
	MOVLW	CCP1CON_Set	;Set output on match
	MOVWF	CCP1CON
;
IRQ_Servo1_X	MOVLB	0x00                   ;Bank 0
	BCF	PIR1,CCP1IF
IRQ_Servo1_End:
;--------------------------------------------------------------------
;
	retfie		; return from interrupt
;
;
;==============================================================================================
;**********************************************************************************************
;==============================================================================================
;
start	MOVLB	0x01	; select bank 1
	bsf	OPTION_REG,NOT_WPUEN	; disable pullups on port B
	bcf	OPTION_REG,TMR0CS	; TMR0 clock Fosc/4
	bcf	OPTION_REG,PSA	; prescaler assigned to TMR0
	bsf	OPTION_REG,PS0	;111 8mhz/4/256=7812.5hz=128uS/Ct=0.032768S/ISR
	bsf	OPTION_REG,PS1	;101 8mhz/4/64=31250hz=32uS/Ct=0.008192S/ISR
	bsf	OPTION_REG,PS2
;
	MOVLW	OSCCON_Value
	MOVWF	OSCCON
	movlw	b'00010111'	; WDT prescaler 1:65536 period is 2 sec (RESET value)
	movwf	WDTCON 	
;	
	MOVLB	0x03	; bank 3
	CLRF	ANSELA	;Digital
;
; setup timer 1 for 0.5uS/count
;
	BANKSEL	T1CON	; bank 0
	MOVLW	T1CON_Val
	MOVWF	T1CON
	bcf	T1GCON,TMR1GE
;
; clear memory to zero
	CALL	ClearRam
;
; Setup timer 2 for 0.01S/Interupt
	MOVLW	T2CON_Value	;Setup T2 for 100/s
	MOVWF	T2CON
	BANKSEL	PR2
	MOVLW	PR2_Value
	MOVWF	PR2
	MOVLB	1	;Bank 1
	BSF	PIE1,TMR2IE
	movlb	0                      ;Bank 0
;
; setup ccp1
;
	BSF	ServoOff
	BANKSEL	APFCON
	BSF	APFCON,CCP1SEL	;RA5
	BANKSEL	CCP1CON
	CLRF	CCP1CON
;
	MOVLB	0x01	;Bank 1
	bsf	PIE1,CCP1IE
;
; setup data ports
	BANKSEL	PORTA
	MOVLW	PortAValue
	MOVWF	PORTA	;Init PORTA
	BANKSEL	TRISA
	MOVLW	PortADDRBits
	MOVWF	TRISA
;
	MOVLB	0	;bank 0
	CLRWDT
;
	MOVLW	LEDTIME
	MOVWF	LED_Time
	movlw	0x01	;continuos ON
	movwf	LED2_Time
;
	CLRWDT
	CALL	CopyToRam
	CLRWDT
;
;
	bsf	INTCON,PEIE	; enable periferal interupts
;	bsf	INTCON,T0IE	; enable TMR0 interupt
	bsf	INTCON,GIE	; enable interupts
;
	MOVLB	0x00	;bank 0
;
;=========================================================================================
;=========================================================================================
;  Main Loop
;
	CALL	StartServo
;=========================================================================================
;
MainLoop	CLRWDT
	MOVLB	0x00                   ;Bank 0
;
; Handle Inc/Dec buttons
	movf	Timer4Lo,F
	SKPZ
	bra	ML_Btns_End
	btfss	IncBtnFlag
	bra	ML_Btns_Dec
;
	call	CopyPosToTemp
	movlw	0x01
	addwf	Param7C,F
	clrw
	addwfc	Param7D
	call	ClampInt
	call	CopyTempToPos
	bsf	DataChangedFlag
;
	movlw	0x05
	movwf	Timer4Lo
	bra	ML_Btns_End
;
ML_Btns_Dec	btfss	DecBtnFlag
	bra	ML_Btns_End
;
	call	CopyPosToTemp
	movlw	0x01
	subwf	Param7C,F
	clrw
	subwfb	Param7D
	call	ClampInt
	call	CopyTempToPos
	bsf	DataChangedFlag
;	
	movlw	0x05
	movwf	Timer4Lo
ML_Btns_End:
	btfsc	DataChangedFlag
	call	SaveParams
	bcf	DataChangedFlag
;
;-------------------------
;
	btfss	NewSWData
	bra	Move_End
	bcf	NewSWData
;	
	btfss	CmdInputBit
	bra	ML_CmdNormal
; debounce
	movlw	0x05
	subwf	Debounce,W
	SKPZ
	bra	Rev_Debounce
;	
	movlb	2	;Bank 2
	bsf	RelayDrvrBit
	bsf	FeedbackBit
	movlb	0	;Bank0
	bsf	SMRevFlag
	bsf	LED2Flag
	call	CopyPos2ToTemp
	bra	Move_It
;
Rev_Debounce	incf	Debounce,F
	bra	Move_End
;
ML_CmdNormal	movf	Debounce,F
	SKPZ
	bra	Norm_Debounce
;
	movlb	2	;Bank 2
	bcf	RelayDrvrBit
	bcf	FeedbackBit
	movlb	0	;Bank 0
	bcf	SMRevFlag
	bcf	LED2Flag
	call	CopyPos1ToTemp
	bra	Move_It
;
Norm_Debounce	decf	Debounce,F
	bra	Move_End
;
Move_It:
	CALL	Copy7CToSig
Move_End:
;
	goto	MainLoop
;
;========================================================================================
; Param7D:Param7C >> SigOutTimeH:SigOutTime
;
; Don't disable interrupts if you don't need to...
Copy7CToSig	MOVF	Param7C,W
	SUBWF	SigOutTime,W
	SKPZ
	GOTO	Copy7CToSig_1
	MOVF	Param7D,W
	SUBWF	SigOutTimeH,W
	SKPNZ
	Return
;
Copy7CToSig_1	bcf	INTCON,GIE
	btfsc	INTCON,GIE
	bra	Copy7CToSig_1
	MOVF	Param7C,W
	MOVWF	SigOutTime
	MOVF	Param7D,W
	MOVWF	SigOutTimeH
	bsf	INTCON,GIE
;	
	RETURN
;
;=========================================================================
;
CopyTempToPos	btfss	SMRevFlag
	bra	CopyTempToPos1
	bra	CopyTempToPos2
;
CopyPosToTemp	btfss	SMRevFlag
	bra	CopyPos1ToTemp
	bra	CopyPos2ToTemp
;
;====================================
;
CopyPos1ToTemp	movf	Position1+1,W
	movwf	Param7D
	movf	Position1,W
	movwf	Param7C
	return
;
;=====================================
;
CopyPos2ToTemp	movf	Position2+1,W
	movwf	Param7D
	movf	Position2,W
	movwf	Param7C
	return
;
;=====================================
;
CopyTempToPos1	movf	Param7D,W
	movwf	Position1+1
	movf	Param7C,W
	movwf	Position1
	return
;
CopyTempToPos2	movf	Param7D,W
	movwf	Position2+1
	movf	Param7C,W
	movwf	Position2
	return
;
;=========================================================================================
;=========================================================================================
; Set CCP1 to go high is 0x100 clocks
;
StartServo	MOVLB	0	;bank 0
	BTFSS	ServoOff
	RETURN
	BCF	ServoOff
;
	CALL	SetMiddlePosition
	CALL	Copy7CToSig
;
	MOVLW	0x00	;start in 0x100 clocks
	MOVWF	TMR1L
	MOVLW	0xFF
	MOVWF	TMR1H
;
	MOVLB	0x05                   ;Bank 5
	CLRF	CCPR1H
	CLRF	CCPR1L
	MOVLW	CCP1CON_Set
	MOVWF	CCP1CON	;go high on match
	MOVLB	0x00	;Bank 0
	RETURN
;
; Don't disable interrupts if you don't need to...
SetMiddlePosition	MOVLW	LOW kMidPulseWidth
	MOVWF	Param7C
	MOVLW	HIGH kMidPulseWidth
	MOVWF	Param7D
	Return
;
;=========================================================================================
; ClampInt(Param7D:Param7C,kMinPulseWidth,kMaxPulseWidth)
;
; Entry: Param7D:Param7C
; Exit: Param7D:Param7C=ClampInt(Param7D:Param7C,kMinPulseWidth,kMaxPulseWidth)
;
ClampInt	MOVLW	high kMaxPulseWidth
	SUBWF	Param7D,W	;7D-kMaxPulseWidth
	SKPNB		;7D<Max?
	GOTO	ClampInt_1	; Yes
	SKPZ		;7D=Max?
	GOTO	ClampInt_tooHigh	; No, its greater.
	MOVLW	low kMaxPulseWidth	; Yes, MSB was equal check LSB
	SUBWF	Param7C,W	;7C-kMaxPulseWidth
	SKPNZ		;=kMaxPulseWidth
	RETURN		;Yes
	SKPB		;7C<Max?
	GOTO	ClampInt_tooHigh	; No
	RETURN		; Yes
;
ClampInt_1	MOVLW	high kMinPulseWidth
	SUBWF	Param7D,W	;7D-kMinPulseWidth
	SKPNB		;7D<Min?
	GOTO	ClampInt_tooLow	; Yes
	SKPZ		;=Min?
	RETURN		; No, 7D>kMinPulseWidth
	MOVLW	low kMinPulseWidth	; Yes, MSB is a match
	SUBWF	Param7C,W	;7C-kMinPulseWidth
	SKPB		;7C>=Min?
	RETURN		; Yes
;	
ClampInt_tooLow	MOVLW	low kMinPulseWidth
	MOVWF	Param7C
	MOVLW	high kMinPulseWidth
	MOVWF	Param7D
	RETURN
;
ClampInt_tooHigh	MOVLW	low kMaxPulseWidth
	MOVWF	Param7C
	MOVLW	high kMaxPulseWidth
	MOVWF	Param7D
	RETURN
;
	if oldCode
;=========================================================================================
;=====================================================================================
;
MoveTo78	MOVWF	FSR0L
	MOVF	INDF0,W
	MOVWF	Param78
	INCF	FSR0L,F
	MOVF	INDF0,W
	MOVWF	Param79
	RETURN
;
;=====================================================================================
;
MoveTo7C	MOVWF	FSR0L
	MOVF	INDF0,W
	MOVWF	Param7C
	INCF	FSR0L,F
	MOVF	INDF0,W
	MOVWF	Param7D
	RETURN
;
;=====================================================================================
;
Move78To7C	MOVF	Param78,W
	MOVWF	Param7C
	MOVF	Param79,W
	MOVWF	Param7D
	RETURN
;
;=====================================================================================
;
MoveFrom7C	MOVWF	FSR0L
	MOVF	Param7C,W
	MOVWF	INDF0
	INCF	FSR0L,F
	MOVF	Param7D,W
	MOVWF	INDF0
	RETURN
;
;=====================================================================================
; Less or Equal
;
; Entry: Param7D:Param7C, Param79:Param78
; Exit: Param77:0=Param7D:Param7C<=Param79:Param78
;
Param7D_LE_Param79	CLRF	Param77	;default to >
	MOVF	Param79,W
	SUBWF	Param7D,W	;Param7D-Param79
	SKPNB		;Param7D<Param79?
	GOTO	SetTrue	; Yes
	SKPZ		;Param7D>Param79?
	RETURN		; Yes
	MOVF	Param78,W	; No, MSB is a match
	SUBWF	Param7C,W	;Param7C-Param78
	SKPNB		;Param7C<Param78?
	GOTO	SetTrue	; Yes
	SKPZ		;LSBs then same?
	RETURN		; No
;
SetTrue	BSF	Param77,0
	RETURN
;
;=====================================================================================
; Greater or Equal
;
; Entry: Param7D:Param7C, Param79:Param78
; Exit: Param77:0=Param7D:Param7C>=Param79:Param78
;
Param7D_GE_Param79	CLRF	Param77	;default to <
	MOVF	Param79,W
	SUBWF	Param7D,W	;Param7D-Param79
	SKPNB		;Param7D<Param79?
	RETURN		; Yes
	SKPZ		;Param7D>Param79?
	GOTO	SetTrue	; Yes
Param7D_GE_Param79_1	MOVF	Param78,W	; No, MSB is a match
	SUBWF	Param7C,W	;Param7C-Param78
	SKPNB		;Param7C<Param78?
	RETURN		; Yes
	GOTO	SetTrue	; No
;
;======================================================================================
;
EqualMin	CLRF	Param77
	MOVLW	high kMinPulseWidth
	SUBWF	Param7D,W
	SKPZ
	RETURN
	MOVLW	low kMinPulseWidth
	SUBWF	Param7C,W
	SKPNZ
	BSF	Param77,0
	RETURN
	
;
Subtract1000	MOVLW	low kMinPulseWidth
	SUBWF	Param7C,F
	SUBBF	Param7D,F
	MOVLW	high kMinPulseWidth
	SUBWF	Param7D,F
	RETURN
;
Subtract1500	MOVLW	low d'1500'
	SUBWF	Param7C,F
	SUBBF	Param7D,F
	MOVLW	high d'1500'
	SUBWF	Param7D,F
	RETURN
;
X2	CLRC
	RLF	Param7C,F
	RLF	Param7D,F
	RETURN
;
Add1000	MOVLW	low kMinPulseWidth
	ADDWF	Param7C,F
	ADDCF	Param7D,F
	MOVLW	high kMinPulseWidth
	ADDWF	Param7D,F
	RETURN
;
	endif
;=============================================================================================
;==============================================================================================
;
	include	F1822_Common.inc
;
;=========================================================================================
;=========================================================================================
;
;
;
;
	END
;
