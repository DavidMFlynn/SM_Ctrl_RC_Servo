;====================================================================================================
;
;   Filename:	RCServoSWMachine.asm
;   Date:	8/6/2019
;   File Version:	1.0b4
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
; 1.0b4   8/6/2019	FC1, Move to commanded position at power up. 1S servo powered time.
; 1.0b3   8/5/2019	Added move to center when both buttons are pressed.
; 1.0b2   7/20/2019	Delay at startup at mid point for 3 seconds, Slower motion for lower power.
; 	Stop senting pulses after in position for 0.5s.
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
;====================================================================================================
;====================================================================================================
; What happens next:
;
;   The system LED blinks once per second
;  Once at power-up:
;   Set position to the commanded position for 3 seconds.
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
;   CCP1 outputs a 900uS to 2100uS (1800..4200 counts) pulse every 16,000uS
;
;   Resolution is 0.5uS
;
;  if kInPosShutdown is set servo will power down after 0.5s
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
CCP1CON_Int	EQU	b'00001010'
;
kOffsetCtrValue	EQU	d'2047'
kMinPulseWidth	EQU	d'1800'	;900uS
kMidPulseWidth	EQU	d'3000'	;1500uS
kMaxPulseWidth	EQU	d'4200'	;2100uS
kDefaultPosition1	EQU	kMidPulseWidth+d'200'
kDefaultPosition2	EQU	kMidPulseWidth-d'200'
kServoDwellTime	EQU	d'40000'	;20mS
kInPosShutdown	EQU	b'00000010'	;b'00000010' enabled 0x00 disabled
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
	CurPos:2
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
#Define	InPosShutdown	SysFlags,1
#Define	InPosition	SysFlags,2
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
;
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
ServoMoveTime	EQU	.100	;time servo is powered when CMD changes
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
	de	LOW kDefaultPosition1	;nvPosition1Lo
	de	HIGH kDefaultPosition1
	de	LOW kDefaultPosition2
	de	HIGH kDefaultPosition2
;
	de	kInPosShutdown	;nvSysFlags
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
	movlb                  1                      ;bank 1
	BSF	SysLEDTrisBit	;LED off
	BSF	LED2TrisBit	;LED2 off
;
	movlb	0	;bank 0
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
	movlb                  1                      ;bank 1
	BCF	SysLEDTrisBit	;LED on
SystemBlink_end	MOVLB	0                      ;bank 0
;
	decfsz	LED2_Ticks,F
	bra	LED2_End
;
	MOVF	LED2_Time,W
	movwf	LED2_Ticks
;
	BTFSS	LED2Flag
	bra                    LED2_End
	movlb                  1                      ;bank 1
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
	BSF	PulseSent
	BTFSS	ServoOff	;Are we sending a pulse?
	GOTO	IRQ_Servo1_1	; Yes
;
;Oops, how did we get here???
	MOVLB	0x05                   ;Bank 5
	CLRF	CCP1CON
	GOTO	IRQ_Servo1_X
;
IRQ_Servo1_1	MOVLB	0x05                   ;Bank 5
	BTFSC	CCP1CON,CCP1M0	;Set output on match?
	GOTO	IRQ_Servo1_OL	; No
; An output just went high
;
	MOVF	SigOutTime,W	;Put the pulse into the CCP reg.
	ADDWF	CCPR1L,F
	MOVF	SigOutTime+1,W
	ADDWFC	CCPR1H,F
	movlb	0	;Bank 0
	movlw	CCP1CON_Int
	btfss	InPosShutdown
	MOVLW	CCP1CON_Clr	;Clear output on match
	btfss	InPosition
	MOVLW	CCP1CON_Clr	;Clear output on match
	movlb	5	;Bank 5
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
	movlb	0	;Bank 0
	movlw	CCP1CON_Int
	btfss	InPosShutdown
	MOVLW	CCP1CON_Set	;Set output on match
	btfss	InPosition
	MOVLW	CCP1CON_Set	;Set output on match
	movlb	5	;Bank 5
	MOVWF	CCP1CON	;Idle output low
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
	movlb	0	; bank 0
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
	MOVLW	PR2_Value
	MOVWF	PR2
	MOVLB	1	;Bank 1
	BSF	PIE1,TMR2IE
	movlb	0                      ;Bank 0
;
; setup ccp1
;
	BSF	ServoOff
	movlb	2                      ;bank 2
	BSF	APFCON,CCP1SEL	;RA5
	movlb	5                      ;bank 5
	CLRF	CCP1CON
;
	MOVLB	0x01	;Bank 1
	bsf	PIE1,CCP1IE
;
; setup data ports
	movlb                  0                      ;bank 0
	MOVLW	PortAValue
	MOVWF	PORTA	;Init PORTA
	movlb                  1                      ;bank 1
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
	movlw	0x04
	movwf	Timer4Lo	;power up delay
;
;=========================================================================================
;=========================================================================================
;  Main Loop
;
	CALL	StartServo
;=========================================================================================
;
BtnChangeRate	EQU	0x02	;change by 1uS per 0.05 seconds
SlewChangeRate	EQU	0x10	;change by 5uS per 0.01 seconds
;
MainLoop	CLRWDT
	MOVLB	0x00                   ;Bank 0
;
; Handle Inc/Dec buttons
	movf	Timer4Lo,W
	iorwf	Timer4Hi,W
	SKPZ		;Timer4 == 0?
	bra	ML_Btns_End	; No
	btfss	IncBtnFlag	;Inc button is down?
	bra	ML_Btns_Dec	; No
;
	btfss	DecBtnFlag	;Dec button is down?
	bra	ML_Btns_Inc	; No
; Handle both buttons, move to center
	movlw	low kMidPulseWidth
	movwf	Dest
	movlw	high kMidPulseWidth
	movwf	Dest+1
	bcf	DataChangedFlag
	bra	Set_Dest_End
;
; Handle INC button
ML_Btns_Inc	call	CopyPosToTemp
	movlw	BtnChangeRate
	addwf	Param7C,F
	movlw	0x00
	addwfc	Param7D,F
	call	ClampInt
	call	CopyTempToPos
	bsf	DataChangedFlag
;
	movlw	0x05	; 0.05 seconds
	movwf	Timer4Lo
	bra	ML_Btns_End
;
ML_Btns_Dec	btfss	DecBtnFlag	;Dec button is down?
	bra	ML_Btns_Save	; No
;
; Handle DEC button
	call	CopyPosToTemp
	movlw	BtnChangeRate
	subwf	Param7C,F
	movlw	0x00
	subwfb	Param7D,F
	call	ClampInt
	call	CopyTempToPos
	bsf	DataChangedFlag
;
	movlw	0x05	; 0.05 seconds
	movwf	Timer4Lo
	bra	ML_Btns_End

ML_Btns_Save	btfsc	DataChangedFlag
	call	SaveParams
	bcf	DataChangedFlag
ML_Btns_End:
;
;-------------------------
; Set Dest
;
	btfss	NewSWData	;10mS interval passed?
	bra	Set_Dest_End	; No
	bcf	NewSWData
;
	btfss	CmdInputBit	;Contorl signal active?
	bra	ML_CmdNormal	; No
; debounce, don't change until we've seen the input 5 times
	movlw	0x05
	subwf	Debounce,W
	SKPZ		;5 times?
	bra	Rev_Debounce	; No
;
	movlb	2	;Bank 2 for LATA
	bsf	RelayDrvrBit
	bsf	FeedbackBit
	movlb	0	;Bank0
	bsf	SMRevFlag
	bsf	LED2Flag
	bra	Move_It
;
Rev_Debounce	incf	Debounce,F
	bra	Set_Dest_End
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
	bra	Move_It
;
Norm_Debounce	decf	Debounce,F
	bra	Set_Dest_End
;
Move_It	call	CopyPosToDest
;
Set_Dest_End:
;
;---------------------
; Move CurPos toward Dest
	movlb	0	;Bank 0
	btfss	PulseSent
	bra	Move_End
	bcf	PulseSent
;
	movf	Dest,W
	subwf	CurPos,W
	movwf	Param78
	movf	Dest+1,W
	subwfb	CurPos+1,W
	iorwf	Param78,F
	SKPZ		;Dest == CurPos?
	bra	Move_It_NIP
	movf	Timer2Lo,F
	SKPNZ
	bsf	InPosition
	bra	Move_It_Now	; Yes
;
Move_It_NIP	movlw	ServoMoveTime
	movwf	Timer2Lo
	bcf	InPosition
;
	movf	Dest,W
	movwf	Param78
	movf	Dest+1,W
	movwf	Param79
;
	movf	CurPos,W
	movwf	Param7C
	movf	CurPos+1,W
	movwf	Param7D
;
	call	Param7D_LE_Param79
	btfss	Param77,0	;CurPos<=Dest?
	bra	Move_It_Neg	; No, CurPos>Dest
;CurPos<Dest, so move CurPos positive
	movlw	SlewChangeRate
	addwf	Param7C,F
	movlw	0x00
	addwfc	Param7D,F
	call	Param7D_LE_Param79
	btfss	Param77,0	;CurPos<=Dest Still?
	bra	Move_It_Dest	; No, CurPos>Dest
			; Yes, CurPos+=SlewChangeRate
;
; make the calculated position the current position
Move_It_New	movf	Param7C,W
	movwf	CurPos
	movf	Param7D,W
	movwf	CurPos+1
	bra	Move_It_Now
;
Move_It_Neg
	movlw	SlewChangeRate
	subwf	Param7C,F
	movlw	0x00
	subwfb	Param7D,F
	call	Param7D_LE_Param79
	btfsc	Param77,0	;CurPos<=Dest now?
	bra	Move_It_Dest	; Yes, CurPos<=Dest
	bra	Move_It_New
;
; make the current position the destination
Move_It_Dest	movf	Dest,W
	movwf	CurPos
	movf	Dest+1,W
	movwf	CurPos+1
;
Move_It_Now:
	movf	CurPos,W
	movwf	Param7C
	movf	CurPos+1,W
	movwf	Param7D
	CALL	Copy7CToSig
Move_End:
;
	goto	MainLoop
;
;========================================================================================
; Param7D:Param7C >> SigOutTimeH:SigOutTime
; Entry: Param7D:Param7C
;
; Don't disable interrupts if you don't need to...
; If Param7D:Param7C == SigOutTimeH:SigOutTime then return
Copy7CToSig	MOVF	Param7C,W
	SUBWF	SigOutTime,W
	SKPZ
	GOTO	Copy7CToSig_1
	MOVF	Param7D,W
	SUBWF	SigOutTimeH,W
	SKPNZ
	Return
;
;SigOutTimeH:SigOutTime = Param7D:Param7C
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
CopyPosToDest	btfss	SMRevFlag
	bra	CopyPos1ToDest
	bra	CopyPos2ToDest
;
;====================================
;
CopyPos1ToDest	movf	Position1+1,W
	movwf	Dest+1
	movf	Position1,W
	movwf	Dest
	return
;
;=====================================
;
CopyPos2ToDest	movf	Position2+1,W
	movwf	Dest+1
	movf	Position2,W
	movwf	Dest
	return
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
SS_Start_Loop	movf	Timer4Lo,F
	SKPZ
	bra	SS_Start_Loop
;
; Initialize to commanded position
	btfss	CmdInputBit	;Contorl signal active?
	bra	SS_CmdNormal	; No
	movlb	2	;Bank 2 for LATA
	bsf	RelayDrvrBit
	bsf	FeedbackBit
	movlb	0	;Bank0
	bsf	SMRevFlag
	bsf	LED2Flag
	bra	SS_Move_It
;
SS_CmdNormal	movlb	2	;Bank 2
	bcf	RelayDrvrBit
	bcf	FeedbackBit
	movlb	0	;Bank 0
	bcf	SMRevFlag
	bcf	LED2Flag
;
SS_Move_It	call	CopyPosToDest
	call	SetDestAsCur
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
	movlw	low .300	;Do nothing for 3 seconds
	movwf	Timer4Lo
	movlw	high .300
	movwf	Timer4Hi
	movlw	ServoMoveTime	;At power up move to commanded position
	movwf	Timer2Lo
	bcf	InPosition
	RETURN
;
;=========================================================================================
;
SetMiddlePosition	MOVLW	LOW kMidPulseWidth
	MOVWF	Param7C
	movwf	Dest
	movwf	CurPos
	MOVLW	HIGH kMidPulseWidth
	MOVWF	Param7D
	movwf	Dest+1
	movwf	CurPos+1
	Return
;
;=========================================================================================
;
SetDestAsCur	movf	Dest,W
	MOVWF	Param7C
	movwf	CurPos
	movf	Dest+1,W
	MOVWF	Param7D
	movwf	CurPos+1
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
