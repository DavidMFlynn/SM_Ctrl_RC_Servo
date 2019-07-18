EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:microchip_pic12mcu
LIBS:mechanical
LIBS:relays
LIBS:RCSMCtrl-cache
EELAYER 26 0
EELAYER END
$Descr A 11000 8500
encoding utf-8
Sheet 1 1
Title "R/C Servo Switch Machine Control"
Date "2017-09-16"
Rev "A"
Comp "DMFE"
Comment1 "G2R Version "
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L PIC12(L)F1822-I/P IC1
U 1 1 5615DFEB
P 4350 4900
F 0 "IC1" H 3100 5450 50  0000 L CNN
F 1 "PIC12F1822-I/P" H 3100 5350 50  0000 L CNN
F 2 "Housings_DIP:DIP-8_W7.62mm" H 4350 4900 60  0001 C CNN
F 3 "" H 4350 4900 60  0000 C CNN
	1    4350 4900
	1    0    0    -1  
$EndComp
$Comp
L D D4
U 1 1 5615E03B
P 6300 1200
F 0 "D4" H 6300 1300 50  0000 C CNN
F 1 "D" H 6300 1100 50  0000 C CNN
F 2 "Diodes_SMD:Diode-SMA_Handsoldering" H 6300 1200 60  0001 C CNN
F 3 "" H 6300 1200 60  0000 C CNN
	1    6300 1200
	-1   0    0    -1  
$EndComp
$Comp
L CP1_Small C2
U 1 1 5615E068
P 8150 1400
F 0 "C2" H 8160 1470 50  0000 L CNN
F 1 "33uF" H 8160 1320 50  0000 L CNN
F 2 "Capacitors_Elko_ThroughHole:Elko_vert_11.2x6.3mm_RM2.5_CopperClear" H 8150 1400 60  0001 C CNN
F 3 "" H 8150 1400 60  0000 C CNN
	1    8150 1400
	1    0    0    -1  
$EndComp
$Comp
L C_Small C3
U 1 1 5615E08D
P 9150 1400
F 0 "C3" H 9160 1470 50  0000 L CNN
F 1 ".1uF" H 9160 1320 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 9150 1400 60  0001 C CNN
F 3 "" H 9150 1400 60  0000 C CNN
	1    9150 1400
	1    0    0    -1  
$EndComp
$Comp
L C_Small C4
U 1 1 5615E0CC
P 9450 1400
F 0 "C4" H 9460 1470 50  0000 L CNN
F 1 ".1uF" H 9460 1320 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 9450 1400 60  0001 C CNN
F 3 "" H 9450 1400 60  0000 C CNN
	1    9450 1400
	1    0    0    -1  
$EndComp
$Comp
L LM7805CT U1
U 1 1 5615E0EF
P 8650 1250
F 0 "U1" H 8450 1450 40  0000 C CNN
F 1 "LM7805CT" H 8650 1450 40  0000 L CNN
F 2 "TO_SOT_Packages_SMD:TO-252-2" H 8650 1350 30  0001 C CIN
F 3 "" H 8650 1250 60  0000 C CNN
	1    8650 1250
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X15 P1
U 1 1 5615E11B
P 1350 1900
F 0 "P1" H 1350 2700 50  0000 C CNN
F 1 "CONN_01X15" H 1300 1050 50  0000 C CNN
F 2 "Wires:Wires_AWG20x15" H 1350 1900 60  0001 C CNN
F 3 "" H 1350 1900 60  0000 C CNN
	1    1350 1900
	-1   0    0    -1  
$EndComp
$Comp
L +5V #PWR01
U 1 1 5615E337
P 9350 1100
F 0 "#PWR01" H 9350 950 50  0001 C CNN
F 1 "+5V" H 9350 1240 50  0000 C CNN
F 2 "" H 9350 1100 60  0000 C CNN
F 3 "" H 9350 1100 60  0000 C CNN
	1    9350 1100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 5615E366
P 8650 1700
F 0 "#PWR02" H 8650 1450 50  0001 C CNN
F 1 "GND" H 8650 1550 50  0000 C CNN
F 2 "" H 8650 1700 60  0000 C CNN
F 3 "" H 8650 1700 60  0000 C CNN
	1    8650 1700
	1    0    0    -1  
$EndComp
$Comp
L +24V #PWR03
U 1 1 5615E395
P 8050 1100
F 0 "#PWR03" H 8050 950 50  0001 C CNN
F 1 "+24V" H 8050 1240 50  0000 C CNN
F 2 "" H 8050 1100 60  0000 C CNN
F 3 "" H 8050 1100 60  0000 C CNN
	1    8050 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1200 6150 1200
Wire Wire Line
	6450 1200 8250 1200
Wire Wire Line
	8050 1100 8050 1200
Connection ~ 8050 1200
Wire Wire Line
	8150 1300 8150 1200
Connection ~ 8150 1200
Wire Wire Line
	8150 1500 8150 1600
Wire Wire Line
	8150 1600 9450 1600
Wire Wire Line
	9450 1600 9450 1500
Wire Wire Line
	9150 1500 9150 1600
Connection ~ 9150 1600
Wire Wire Line
	8650 1500 8650 1700
Connection ~ 8650 1600
Wire Wire Line
	9050 1200 9450 1200
Wire Wire Line
	9450 1200 9450 1300
Wire Wire Line
	9150 1300 9150 1200
Connection ~ 9150 1200
Wire Wire Line
	9350 1200 9350 1100
Connection ~ 9350 1200
Wire Wire Line
	1650 2600 1550 2600
Wire Wire Line
	1550 2500 1750 2500
Wire Wire Line
	1700 2400 1550 2400
Wire Wire Line
	1550 2300 1850 2300
Wire Wire Line
	1550 2200 1900 2200
Wire Wire Line
	1550 2100 1950 2100
Wire Wire Line
	1550 2000 2050 2000
Wire Wire Line
	1550 1800 2150 1800
Wire Wire Line
	1550 1600 2250 1600
$Comp
L GND #PWR04
U 1 1 5615E92B
P 2750 1300
F 0 "#PWR04" H 2750 1050 50  0001 C CNN
F 1 "GND" H 2750 1150 50  0000 C CNN
F 2 "" H 2750 1300 60  0000 C CNN
F 3 "" H 2750 1300 60  0000 C CNN
	1    2750 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1300 2750 1300
$Comp
L CONN_01X03 P2
U 1 1 5615E998
P 8050 4900
F 0 "P2" H 8050 5100 50  0000 C CNN
F 1 "CONN_01X03" H 8150 4700 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x03" H 8050 4900 60  0001 C CNN
F 3 "" H 8050 4900 60  0000 C CNN
	1    8050 4900
	1    0    0    -1  
$EndComp
Text Notes 8200 4650 0    60   ~ 0
Servo
$Comp
L +5V #PWR05
U 1 1 5615EA1E
P 7750 4600
F 0 "#PWR05" H 7750 4450 50  0001 C CNN
F 1 "+5V" H 7750 4740 50  0000 C CNN
F 2 "" H 7750 4600 60  0000 C CNN
F 3 "" H 7750 4600 60  0000 C CNN
	1    7750 4600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 5615EA50
P 7750 5150
F 0 "#PWR06" H 7750 4900 50  0001 C CNN
F 1 "GND" H 7750 5000 50  0000 C CNN
F 2 "" H 7750 5150 60  0000 C CNN
F 3 "" H 7750 5150 60  0000 C CNN
	1    7750 5150
	1    0    0    -1  
$EndComp
$Comp
L R R11
U 1 1 5615EA82
P 7400 4800
F 0 "R11" V 7480 4800 50  0000 C CNN
F 1 "220R" V 7400 4800 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 7330 4800 30  0001 C CNN
F 3 "" H 7400 4800 30  0000 C CNN
	1    7400 4800
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR07
U 1 1 5615EBDB
P 2850 4500
F 0 "#PWR07" H 2850 4350 50  0001 C CNN
F 1 "+5V" H 2850 4640 50  0000 C CNN
F 2 "" H 2850 4500 60  0000 C CNN
F 3 "" H 2850 4500 60  0000 C CNN
	1    2850 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 5615EC07
P 2850 5300
F 0 "#PWR08" H 2850 5050 50  0001 C CNN
F 1 "GND" H 2850 5150 50  0000 C CNN
F 2 "" H 2850 5300 60  0000 C CNN
F 3 "" H 2850 5300 60  0000 C CNN
	1    2850 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2850 4500 2850 4600
Wire Wire Line
	2850 4600 2950 4600
Wire Wire Line
	2850 5300 2850 5200
Wire Wire Line
	2850 5200 2950 5200
Wire Wire Line
	7850 4800 7550 4800
Wire Wire Line
	7850 4900 7750 4900
Wire Wire Line
	7750 4900 7750 4600
Wire Wire Line
	7850 5000 7750 5000
Wire Wire Line
	7750 5000 7750 5150
Wire Wire Line
	5750 5100 6950 5100
Wire Wire Line
	6950 5100 6950 4800
Wire Wire Line
	6950 4800 7250 4800
$Comp
L R R2
U 1 1 5615EF3D
P 5300 2400
F 0 "R2" V 5380 2400 50  0000 C CNN
F 1 "1K" V 5300 2400 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 5230 2400 30  0001 C CNN
F 3 "" H 5300 2400 30  0000 C CNN
	1    5300 2400
	0    1    1    0   
$EndComp
$Comp
L D D3
U 1 1 5615EFBB
P 4900 2400
F 0 "D3" H 4900 2500 50  0000 C CNN
F 1 "D" H 4900 2300 50  0000 C CNN
F 2 "Diodes_SMD:Diode-SMA_Handsoldering" H 4900 2400 60  0001 C CNN
F 3 "" H 4900 2400 60  0000 C CNN
	1    4900 2400
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 5615F017
P 5750 2400
F 0 "R4" V 5830 2400 50  0000 C CNN
F 1 "10K" V 5750 2400 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 5680 2400 30  0001 C CNN
F 3 "" H 5750 2400 30  0000 C CNN
	1    5750 2400
	0    1    1    0   
$EndComp
$Comp
L R R5
U 1 1 5615F057
P 6100 2100
F 0 "R5" V 6180 2100 50  0000 C CNN
F 1 "47K" V 6100 2100 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6030 2100 30  0001 C CNN
F 3 "" H 6100 2100 30  0000 C CNN
	1    6100 2100
	0    1    1    0   
$EndComp
$Comp
L C_Small C1
U 1 1 5615F096
P 5550 2600
F 0 "C1" H 5560 2670 50  0000 L CNN
F 1 ".1uF" H 5560 2520 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 5550 2600 60  0001 C CNN
F 3 "" H 5550 2600 60  0000 C CNN
	1    5550 2600
	1    0    0    -1  
$EndComp
$Comp
L Q_NPN_EBC Q1
U 1 1 5615F0F6
P 5000 3900
F 0 "Q1" H 5300 3950 50  0000 R CNN
F 1 "2N7000" H 5500 3850 50  0000 R CNN
F 2 "Housings_TO-92:TO-92_Inline_Narrow_Oval" H 5200 4000 29  0001 C CNN
F 3 "" H 5000 3900 60  0000 C CNN
	1    5000 3900
	-1   0    0    -1  
$EndComp
$Comp
L Q_PNP_EBC Q2
U 1 1 5615F168
P 6250 2400
F 0 "Q2" H 6550 2450 50  0000 R CNN
F 1 "2N3906" H 6750 2350 50  0000 R CNN
F 2 "Housings_TO-92:TO-92_Inline_Narrow_Oval" H 6450 2500 29  0001 C CNN
F 3 "" H 6250 2400 60  0000 C CNN
	1    6250 2400
	1    0    0    1   
$EndComp
$Comp
L R R6
U 1 1 5615F21C
P 6700 2700
F 0 "R6" V 6780 2700 50  0000 C CNN
F 1 "47K" V 6700 2700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6630 2700 30  0001 C CNN
F 3 "" H 6700 2700 30  0000 C CNN
	1    6700 2700
	0    1    1    0   
$EndComp
$Comp
L GND #PWR09
U 1 1 5615F2D0
P 6950 2800
F 0 "#PWR09" H 6950 2550 50  0001 C CNN
F 1 "GND" H 6950 2650 50  0000 C CNN
F 2 "" H 6950 2800 60  0000 C CNN
F 3 "" H 6950 2800 60  0000 C CNN
	1    6950 2800
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR010
U 1 1 5615F314
P 6350 2000
F 0 "#PWR010" H 6350 1850 50  0001 C CNN
F 1 "+5V" H 6350 2140 50  0000 C CNN
F 2 "" H 6350 2000 60  0000 C CNN
F 3 "" H 6350 2000 60  0000 C CNN
	1    6350 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1400 2550 1400
Wire Wire Line
	2550 1400 2550 1500
Wire Wire Line
	2550 1500 4650 1500
Wire Wire Line
	4650 1500 4650 2400
Wire Wire Line
	4650 2400 4750 2400
Wire Wire Line
	5050 2400 5150 2400
Wire Wire Line
	5450 2400 5600 2400
Wire Wire Line
	5550 2400 5550 2500
Connection ~ 5550 2400
Wire Wire Line
	5900 2400 6050 2400
Wire Wire Line
	6350 2000 6350 2200
Wire Wire Line
	6350 2600 6350 4900
Wire Wire Line
	6350 2700 6550 2700
Wire Wire Line
	6850 2700 6950 2700
Wire Wire Line
	6950 2700 6950 2800
$Comp
L GND #PWR011
U 1 1 5615F8AB
P 5550 2800
F 0 "#PWR011" H 5550 2550 50  0001 C CNN
F 1 "GND" H 5550 2650 50  0000 C CNN
F 2 "" H 5550 2800 60  0000 C CNN
F 3 "" H 5550 2800 60  0000 C CNN
	1    5550 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 2800 5550 2700
Wire Wire Line
	6350 4900 5750 4900
Connection ~ 6350 2700
Wire Wire Line
	6250 2100 6350 2100
Connection ~ 6350 2100
Wire Wire Line
	5950 2100 5900 2100
Wire Wire Line
	5900 2100 5900 2400
$Comp
L SW_PUSH SW1
U 1 1 5615FBDF
P 7450 5800
F 0 "SW1" H 7600 5910 50  0000 C CNN
F 1 "SW_PUSH" H 7450 5720 50  0000 C CNN
F 2 "Buttons_Switches_SMD:SW_SPST_PTS645" H 7450 5800 60  0001 C CNN
F 3 "" H 7450 5800 60  0000 C CNN
	1    7450 5800
	1    0    0    -1  
$EndComp
$Comp
L SW_PUSH SW2
U 1 1 5615FC51
P 7450 6400
F 0 "SW2" H 7600 6510 50  0000 C CNN
F 1 "SW_PUSH" H 7450 6320 50  0000 C CNN
F 2 "Buttons_Switches_SMD:SW_SPST_PTS645" H 7450 6400 60  0001 C CNN
F 3 "" H 7450 6400 60  0000 C CNN
	1    7450 6400
	1    0    0    -1  
$EndComp
$Comp
L LED D5
U 1 1 5615FCA7
P 7350 5500
F 0 "D5" H 7350 5600 50  0000 C CNN
F 1 "LED" H 7350 5400 50  0000 C CNN
F 2 "LEDs:LED-1206" H 7350 5500 60  0001 C CNN
F 3 "" H 7350 5500 60  0000 C CNN
	1    7350 5500
	1    0    0    -1  
$EndComp
$Comp
L LED D6
U 1 1 5615FD14
P 7350 6100
F 0 "D6" H 7350 6200 50  0000 C CNN
F 1 "LED" H 7350 6000 50  0000 C CNN
F 2 "LEDs:LED-1206" H 7350 6100 60  0001 C CNN
F 3 "" H 7350 6100 60  0000 C CNN
	1    7350 6100
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR012
U 1 1 5615FD70
P 8050 5400
F 0 "#PWR012" H 8050 5250 50  0001 C CNN
F 1 "+5V" H 8050 5540 50  0000 C CNN
F 2 "" H 8050 5400 60  0000 C CNN
F 3 "" H 8050 5400 60  0000 C CNN
	1    8050 5400
	1    0    0    -1  
$EndComp
$Comp
L R R8
U 1 1 5615FDC0
P 6900 5500
F 0 "R8" V 6980 5500 50  0000 C CNN
F 1 "1K" V 6900 5500 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6830 5500 30  0001 C CNN
F 3 "" H 6900 5500 30  0000 C CNN
	1    6900 5500
	0    1    1    0   
$EndComp
$Comp
L R R10
U 1 1 5615FE34
P 6900 6100
F 0 "R10" V 6980 6100 50  0000 C CNN
F 1 "1K" V 6900 6100 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6830 6100 30  0001 C CNN
F 3 "" H 6900 6100 30  0000 C CNN
	1    6900 6100
	0    1    1    0   
$EndComp
$Comp
L R R7
U 1 1 5615FEF5
P 6900 5350
F 0 "R7" V 6980 5350 50  0000 C CNN
F 1 "47K" V 6900 5350 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6830 5350 30  0001 C CNN
F 3 "" H 6900 5350 30  0000 C CNN
	1    6900 5350
	0    1    1    0   
$EndComp
$Comp
L R R9
U 1 1 5615FF65
P 6900 5950
F 0 "R9" V 6980 5950 50  0000 C CNN
F 1 "47K" V 6900 5950 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 6830 5950 30  0001 C CNN
F 3 "" H 6900 5950 30  0000 C CNN
	1    6900 5950
	0    1    1    0   
$EndComp
$Comp
L GND #PWR013
U 1 1 5615FFC8
P 8050 6500
F 0 "#PWR013" H 8050 6250 50  0001 C CNN
F 1 "GND" H 8050 6350 50  0000 C CNN
F 2 "" H 8050 6500 60  0000 C CNN
F 3 "" H 8050 6500 60  0000 C CNN
	1    8050 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7750 5800 8050 5800
Wire Wire Line
	8050 5800 8050 6500
Wire Wire Line
	7750 6400 8050 6400
Connection ~ 8050 6400
Wire Wire Line
	7500 5500 8050 5500
Wire Wire Line
	8050 5500 8050 5400
Wire Wire Line
	7900 6100 7500 6100
Wire Wire Line
	7900 5350 7900 6100
Connection ~ 7900 5500
Wire Wire Line
	7050 5500 7200 5500
Wire Wire Line
	7050 6100 7200 6100
Wire Wire Line
	7900 5350 7050 5350
Wire Wire Line
	7050 5950 7900 5950
Connection ~ 7900 5950
Wire Wire Line
	5750 4800 6300 4800
Wire Wire Line
	6300 4800 6300 5800
Wire Wire Line
	6300 5350 6750 5350
Wire Wire Line
	6300 5500 6750 5500
Connection ~ 6300 5350
Wire Wire Line
	5750 5000 6150 5000
Wire Wire Line
	6150 5000 6150 6400
Wire Wire Line
	6150 5950 6750 5950
Wire Wire Line
	6150 6100 6750 6100
Connection ~ 6150 5950
Wire Wire Line
	6300 5800 7150 5800
Connection ~ 6300 5500
Wire Wire Line
	6150 6400 7150 6400
Connection ~ 6150 6100
$Comp
L D D1
U 1 1 5616087C
P 4050 3450
F 0 "D1" H 4050 3550 50  0000 C CNN
F 1 "D" H 4050 3350 50  0000 C CNN
F 2 "Diodes_SMD:Diode-SMA_Handsoldering" H 4050 3450 60  0001 C CNN
F 3 "" H 4050 3450 60  0000 C CNN
	1    4050 3450
	0    1    1    0   
$EndComp
$Comp
L D D2
U 1 1 5616090E
P 4050 3950
F 0 "D2" H 4050 4050 50  0000 C CNN
F 1 "D" H 4050 3850 50  0000 C CNN
F 2 "Diodes_SMD:Diode-SMA_Handsoldering" H 4050 3950 60  0001 C CNN
F 3 "" H 4050 3950 60  0000 C CNN
	1    4050 3950
	0    1    1    0   
$EndComp
$Comp
L GND #PWR014
U 1 1 561609E3
P 4450 4200
F 0 "#PWR014" H 4450 3950 50  0001 C CNN
F 1 "GND" H 4450 4050 50  0000 C CNN
F 2 "" H 4450 4200 60  0000 C CNN
F 3 "" H 4450 4200 60  0000 C CNN
	1    4450 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 4200 4950 4200
Wire Wire Line
	4900 4200 4900 4100
Wire Wire Line
	4050 4200 4050 4100
Connection ~ 4450 4200
Wire Wire Line
	4050 3600 4050 3800
Wire Wire Line
	3450 3700 4900 3700
Connection ~ 4050 3700
Wire Wire Line
	4050 3000 4050 3300
$Comp
L +24V #PWR015
U 1 1 56160EC8
P 4050 3000
F 0 "#PWR015" H 4050 2850 50  0001 C CNN
F 1 "+24V" H 4050 3140 50  0000 C CNN
F 2 "" H 4050 3000 60  0000 C CNN
F 3 "" H 4050 3000 60  0000 C CNN
	1    4050 3000
	1    0    0    -1  
$EndComp
Connection ~ 4050 3100
$Comp
L R R3
U 1 1 561611D8
P 5500 3900
F 0 "R3" V 5580 3900 50  0000 C CNN
F 1 "1K" V 5500 3900 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 5430 3900 30  0001 C CNN
F 3 "" H 5500 3900 30  0000 C CNN
	1    5500 3900
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 56161263
P 5100 4200
F 0 "R1" V 5180 4200 50  0000 C CNN
F 1 "47K" V 5100 4200 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 5030 4200 30  0001 C CNN
F 3 "" H 5100 4200 30  0000 C CNN
	1    5100 4200
	0    1    1    0   
$EndComp
Connection ~ 4900 4200
Wire Wire Line
	5200 3900 5350 3900
Wire Wire Line
	5250 4200 5300 4200
Wire Wire Line
	5300 4200 5300 3900
Connection ~ 5300 3900
Wire Wire Line
	5650 3900 5850 3900
Wire Wire Line
	5850 3900 5850 4600
Wire Wire Line
	5850 4600 5750 4600
$Comp
L Q_NPN_EBC Q3
U 1 1 56161683
P 9050 3150
F 0 "Q3" H 9350 3200 50  0000 R CNN
F 1 "2N7000" H 9550 3100 50  0000 R CNN
F 2 "Housings_TO-92:TO-92_Inline_Narrow_Oval" H 9250 3250 29  0001 C CNN
F 3 "" H 9050 3150 60  0000 C CNN
	1    9050 3150
	-1   0    0    -1  
$EndComp
$Comp
L D D7
U 1 1 5616168F
P 8100 2700
F 0 "D7" H 8100 2800 50  0000 C CNN
F 1 "SMA" H 8100 2600 50  0000 C CNN
F 2 "Diodes_SMD:Diode-SMA_Handsoldering" H 8100 2700 60  0001 C CNN
F 3 "" H 8100 2700 60  0000 C CNN
	1    8100 2700
	0    1    1    0   
$EndComp
$Comp
L D D8
U 1 1 56161695
P 8100 3200
F 0 "D8" H 8100 3300 50  0000 C CNN
F 1 "SMA" H 8100 3100 50  0000 C CNN
F 2 "Diodes_SMD:Diode-SMA_Handsoldering" H 8100 3200 60  0001 C CNN
F 3 "" H 8100 3200 60  0000 C CNN
	1    8100 3200
	0    1    1    0   
$EndComp
$Comp
L GND #PWR016
U 1 1 5616169B
P 8500 3450
F 0 "#PWR016" H 8500 3200 50  0001 C CNN
F 1 "GND" H 8500 3300 50  0000 C CNN
F 2 "" H 8500 3450 60  0000 C CNN
F 3 "" H 8500 3450 60  0000 C CNN
	1    8500 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 3450 9000 3450
Wire Wire Line
	8950 3450 8950 3350
Wire Wire Line
	8100 3450 8100 3350
Connection ~ 8500 3450
Wire Wire Line
	8100 2850 8100 3050
Wire Wire Line
	7800 2950 8950 2950
Connection ~ 8100 2950
Wire Wire Line
	8100 2250 8100 2550
$Comp
L +24V #PWR017
U 1 1 561616A9
P 8100 2250
F 0 "#PWR017" H 8100 2100 50  0001 C CNN
F 1 "+24V" H 8100 2390 50  0000 C CNN
F 2 "" H 8100 2250 60  0000 C CNN
F 3 "" H 8100 2250 60  0000 C CNN
	1    8100 2250
	1    0    0    -1  
$EndComp
$Comp
L R R13
U 1 1 561616B1
P 9550 3150
F 0 "R13" V 9630 3150 50  0000 C CNN
F 1 "1K" V 9550 3150 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 9480 3150 30  0001 C CNN
F 3 "" H 9550 3150 30  0000 C CNN
	1    9550 3150
	0    1    1    0   
$EndComp
$Comp
L R R12
U 1 1 561616B7
P 9150 3450
F 0 "R12" V 9230 3450 50  0000 C CNN
F 1 "47K" V 9150 3450 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 9080 3450 30  0001 C CNN
F 3 "" H 9150 3450 30  0000 C CNN
	1    9150 3450
	0    1    1    0   
$EndComp
Connection ~ 8950 3450
Wire Wire Line
	9250 3150 9400 3150
Wire Wire Line
	9300 3450 9350 3450
Wire Wire Line
	9350 3450 9350 3150
Connection ~ 9350 3150
Wire Wire Line
	9700 3150 9900 3150
Wire Wire Line
	9900 3150 9900 4200
Wire Wire Line
	9900 4200 6650 4200
Wire Wire Line
	6650 4200 6650 4700
Wire Wire Line
	6650 4700 5750 4700
Wire Wire Line
	1550 1500 2450 1500
Wire Wire Line
	2450 1500 2450 1600
Wire Wire Line
	7800 1600 7800 2950
Wire Wire Line
	2450 1600 7800 1600
$Comp
L IM00 K1
U 1 1 5983B462
P 3250 2200
F 0 "K1" V 4217 2200 50  0000 C CNN
F 1 "IM00" V 4126 2200 50  0000 C CNN
F 2 "Relays_THT:Relay_DPDT_Panasonic_JW2" H 3250 2200 50  0001 C CNN
F 3 "" H 3250 2200 50  0001 C CNN
	1    3250 2200
	-1   0    0    1   
$EndComp
$Comp
L IM00 K2
U 1 1 5983BD36
P 3250 3200
F 0 "K2" V 4217 3200 50  0000 C CNN
F 1 "IM00" V 4126 3200 50  0000 C CNN
F 2 "Relays_THT:Relay_DPDT_Panasonic_JW2" H 3250 3200 50  0001 C CNN
F 3 "" H 3250 3200 50  0001 C CNN
	1    3250 3200
	-1   0    0    1   
$EndComp
Wire Wire Line
	3850 3100 4050 3100
Wire Wire Line
	3850 1800 3850 3100
Wire Wire Line
	3450 2900 3450 2800
Wire Wire Line
	3450 2800 3850 2800
Connection ~ 3850 2800
Wire Wire Line
	3450 2500 3750 2500
Wire Wire Line
	3750 2500 3750 3700
Wire Wire Line
	3450 3500 3450 3700
Connection ~ 3750 3700
Wire Wire Line
	3050 2800 3050 2900
Wire Wire Line
	2950 3500 2950 3650
Wire Wire Line
	2750 3800 2750 3500
Wire Wire Line
	2650 2900 2650 2850
Wire Wire Line
	2550 3500 2550 3850
Text Notes 1250 1250 2    60   ~ 0
+24VDC
Text Notes 1250 1350 2    60   ~ 0
GND
Text Notes 1250 1450 2    60   ~ 0
Control
Text Notes 1250 1550 2    60   ~ 0
Feedback
Text Notes 1250 1650 2    60   ~ 0
Aux 24V Out
Text Notes 3050 700  2    60   ~ 0
K2 is required for Aux 24V Out and contact set 3.
Text Notes 3500 7900 2    60   ~ 0
G2R Verion Revision A 9/16/2017 moved contact set 2 to K1
Text Notes 1250 1750 2    60   ~ 0
N.C.
Text Notes 1250 2050 2    60   ~ 0
1N\n1C\n1R
Text Notes 1250 2350 2    60   ~ 0
2N\n2C\n2R
Text Notes 1250 2650 2    60   ~ 0
3N\n3C\n3R
Wire Wire Line
	2150 1800 2150 2650
Wire Wire Line
	2050 2000 2050 2600
Wire Wire Line
	1950 2100 1950 2700
Wire Wire Line
	1850 2300 1850 2750
Wire Wire Line
	1750 2500 1750 2850
Wire Wire Line
	1750 2850 2650 2850
Wire Wire Line
	1700 2400 1700 3800
Wire Wire Line
	1700 3800 2750 3800
Wire Wire Line
	2550 3850 1650 3850
Wire Wire Line
	1650 3850 1650 2600
Wire Wire Line
	3450 1900 3450 1800
Wire Wire Line
	3450 1800 3850 1800
Wire Wire Line
	3050 2800 1800 2800
Wire Wire Line
	1800 2800 1800 1200
Connection ~ 1800 1200
Wire Wire Line
	2950 3650 2250 3650
Wire Wire Line
	2250 3650 2250 1600
NoConn ~ 3150 3500
Text Notes 8250 5050 2    60   ~ 0
S\n+\n-
NoConn ~ 1550 1700
Wire Wire Line
	1550 1900 1700 1900
Wire Wire Line
	1700 1900 1700 1750
Wire Wire Line
	1700 1750 3050 1750
Wire Wire Line
	3050 1750 3050 1900
Wire Wire Line
	2150 2650 3150 2650
Wire Wire Line
	3150 2650 3150 2500
Wire Wire Line
	2050 2600 2950 2600
Wire Wire Line
	2950 2600 2950 2500
Wire Wire Line
	1900 2200 1900 1850
Wire Wire Line
	1900 1850 2650 1850
Wire Wire Line
	2650 1850 2650 1900
Wire Wire Line
	1950 2700 2750 2700
Wire Wire Line
	2750 2700 2750 2500
Wire Wire Line
	1850 2750 2550 2750
Wire Wire Line
	2550 2750 2550 2500
$EndSCHEMATC