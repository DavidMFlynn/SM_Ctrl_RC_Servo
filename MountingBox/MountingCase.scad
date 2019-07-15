// ******************************************
// R/C Servo Switch Machine Controller Case
// by David Flynn
// Created: 8/4/2017
// Revision: 1.3 5/15/2019
// Units: mm
// ******************************************
// History
// 1.3 5/15/2019 Added Vertical Servo Mounting
// 1.2 5/14/2019 Converted to mm
// 1.1 9/13/2017 Deeper, rounder, bigger text.
// 1.0 8/4/2017
// ******************************************
// for STL output
//rotate([180,0,0])CaseTop(OneRly=false);
//rotate([180,0,0])CaseTop(OneRly=true);
//CaseBase();
//SG90Mount();
//
//  *** Vertical Servo Mount ***
//VMountDrillGuide();
//VMountServo();
//rotate([180,0,0]) VMountCtoS();
//*******************************************
include <CommonStuffSAEmm.scad>

$fn=90;
Overlap=0.05;
IDXtra=0.2;

CaseWall_t=2;
PCB_OA_z=0.556*25.4; // to C2, 0.393 to IC1, not counting the relays
Base_h=0.4*25.4;

PCB_x=2.1*25.4;
PCB_y=2.3*25.4;
PCB_Bolt_x=1.925*25.4;
PCB_Bolt1_y=0.25*25.4;
PCB_Bolt2_y=2.05*25.4;
PCB_t=0.062*25.4+0.03*25.4; // 0.03 is gap
PCB_Bot=CaseWall_t+0.05*25.4;
Top_h=PCB_OA_z-Base_h+PCB_Bot+CaseWall_t;   //0.2;

MountingHoleSpacing=3*25.4;
PCB_Inset=0.05*25.4;

	Case_x=PCB_x+PCB_Inset*2+CaseWall_t*2;
	Case_y=PCB_y+PCB_Inset*2+CaseWall_t*2;

module RoundRect(X=10,Y=10,H=10,R=1){
	translate([0,0,-H/2])hull(){
		translate([-X/2+R,-Y/2+R,0])cylinder(r=R,h=H);
		translate([X/2-R,-Y/2+R,0])cylinder(r=R,h=H);
		translate([-X/2+R,Y/2-R,0])cylinder(r=R,h=H);
		translate([X/2-R,Y/2-R,0])cylinder(r=R,h=H);
	} // hull
} // RoundRect

//RoundRect();

module CaseBase(){
	difference(){
		union(){
			translate([0,0,Base_h/2])
				RoundRect(X=Case_x,Y=Case_y,H=Base_h,R=1);
			
			// mounting tabs
			hull(){
				translate([0,-MountingHoleSpacing/2,0]) cylinder(d=12.7,h=3);
				translate([0,MountingHoleSpacing/2,0]) cylinder(d=12.7,h=3);
			} // hull
			
			
		} // union
		
		translate([0,0,Base_h/2+CaseWall_t])
			RoundRect(X=PCB_x+PCB_Inset*2,Y=PCB_y+PCB_Inset*2,H=Base_h,R=1);
		
		translate([0,-MountingHoleSpacing/2,3]) Bolt6ClearHole();
		translate([0,MountingHoleSpacing/2,3]) Bolt6ClearHole();
		// PCB mounting screws
		translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,PCB_Bot]){
				translate([0,PCB_Bolt1_y,0]) Bolt4Hole();
				translate([0,PCB_Bolt2_y,0]) Bolt4Hole();
			}
			
		// case screws
		translate([-Case_x/2+5,-Case_y/2-CaseWall_t,Base_h/2]) rotate([90,0,0]) Bolt4Hole();
		mirror([0,1,0])
		translate([-Case_x/2+5,-Case_y/2-CaseWall_t,Base_h/2]) rotate([90,0,0]) Bolt4Hole();
	} // diff
	// PCB mounting screws
	difference(){
	translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,0]){
				translate([0,PCB_Bolt1_y,0]) cylinder(d=8,h=PCB_Bot);
				translate([0,PCB_Bolt2_y,0]) cylinder(d=8,h=PCB_Bot);
			}
			translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,PCB_Bot]){
				translate([0,PCB_Bolt1_y,0]) Bolt4Hole();
				translate([0,PCB_Bolt2_y,0]) Bolt4Hole();
			}
		} // diff
} // CaseBase

//translate([0,0,-Base_h-Overlap])CaseBase();

W1_y=2.2*25.4;
W2_y=0.1*25.4;
LED_x=1.6*25.4;
LED1_y=1.475*25.4;
LED2_y=1.15*25.4;
SW_x=1.9*25.4;
SW1_y=1.525*25.4;
SW2_y=1.075*25.4;
Rly_x=0.3*25.4;
Rly_y=0.05*25.4;
Rly_w=1.2*25.4;
Rly_h=1.1*25.4;
P2_x=1.375*25.4;
P2_y=2.075*25.4;
P2_w=0.350*25.4;
P2_h=0.150*25.4;

module CaseTop(OneRly=false){
	difference(){
		translate([0,0,Top_h/2])
			RoundRect(X=Case_x,Y=Case_y,H=Top_h,R=1);
		
		translate([0,0,Top_h/2-CaseWall_t])
			RoundRect(X=PCB_x+PCB_Inset*2,Y=PCB_y+PCB_Inset*2,H=Top_h,R=1);
		
		// PCB mounting screws
		translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,Top_h]){
				translate([0,PCB_Bolt1_y,0]) Bolt4HeadHole();
				translate([0,PCB_Bolt2_y,0]) Bolt4HeadHole();
		}
		// Relays
		if (OneRly==true){
			translate([-PCB_x/2+Rly_x,-PCB_y/2+Rly_y+Rly_h/2,0]) cube([Rly_w,Rly_h/2,Top_h+Overlap]);
		}else{
		translate([-PCB_x/2+Rly_x,-PCB_y/2+Rly_y,0]) cube([Rly_w,Rly_h,Top_h+Overlap]);}
		
		// Servo connector
		translate([-PCB_x/2+P2_x,-PCB_y/2+P2_y,0]) cube([P2_w,P2_h,Top_h+Overlap]);
		
		// wires
		translate([-Case_x/2-Overlap,-PCB_y/2+W2_y-1,-Overlap])cube([CaseWall_t+Overlap*2,W1_y-W2_y+3,3]);
		// LEDs
		translate([-PCB_x/2+LED_x,-PCB_y/2,0]){
			translate([0,LED1_y,0])	cylinder(d=3,h=Top_h+Overlap);
			translate([0,LED2_y,0])	cylinder(d=3,h=Top_h+Overlap);}
		// Switches
		translate([-PCB_x/2+SW_x,-PCB_y/2,0]){
			translate([0,SW1_y,0])	cylinder(d=3,h=Top_h+Overlap);
			translate([0,SW2_y,0])	cylinder(d=3,h=Top_h+Overlap);}
			
		// Text
			TestDepth=0.0236*25.4;
		translate([-PCB_x/2,-PCB_y/2,Top_h-TestDepth]){
			translate([LED_x-2,LED1_y+3,0]) linear_extrude(height=TestDepth) text("N",5);
			translate([LED_x-2,LED2_y-8,0]) linear_extrude(height=TestDepth) text("R",5);
			translate([SW_x-2,SW1_y+3,0]) linear_extrude(height=TestDepth) text("+",6);
			translate([SW_x-2,SW2_y-3-1,0]) linear_extrude(height=TestDepth) text("_",6);
			translate([P2_x-5,P2_y,0]) linear_extrude(height=TestDepth) text("S",5);
			translate([P2_x+2.5,P2_y+4,0]) linear_extrude(height=TestDepth) text("+ -",5);
			translate([0.00,PCB_y-6,0]) linear_extrude(height=TestDepth) text("R/C",6);
			translate([0.00,PCB_y-13,0]) linear_extrude(height=TestDepth) text("Servo SM",6);
			translate([5,PCB_y-60,0]) rotate([0,0,90]) linear_extrude(height=TestDepth) text("DMFE 2019",6);
			
		}
	} // diff
	
	// PCB mounting screws
	Post_l=Base_h-PCB_Bot-PCB_t+Top_h-Overlap;
	difference(){
			translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,-Base_h+PCB_Bot+PCB_t]){
				translate([0,PCB_Bolt1_y,0]) cylinder(d=8,h=Post_l);
				translate([0,PCB_Bolt2_y,0]) cylinder(d=8,h=Post_l);
			}
			translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,Top_h]){
				translate([0,PCB_Bolt1_y,0]) Bolt4HeadHole(depth=Top_h+Base_h);
				translate([0,PCB_Bolt2_y,0]) Bolt4HeadHole(depth=Top_h+Base_h);
			}
		} // diff
		
	// case screws
	difference(){
		union(){
			translate([-Case_x/2,-Case_y/2-CaseWall_t/2,0]) cube([11,CaseWall_t,Top_h]);
			translate([-Case_x/2,-Case_y/2-CaseWall_t-IDXtra,-Base_h]) cube([11,CaseWall_t,Base_h+Top_h]);
		} // union
			
		translate([-Case_x/2+5,-Case_y/2-CaseWall_t-IDXtra,-Base_h/2]) rotate([90,0,0]) Bolt4ClearHole();
	} // diff
	mirror([0,1,0])
	difference(){
		union(){
			translate([-Case_x/2,-Case_y/2-CaseWall_t/2,0]) cube([11,CaseWall_t,Top_h]);
			translate([-Case_x/2,-Case_y/2-CaseWall_t-IDXtra,-Base_h]) cube([11,CaseWall_t,Base_h+Top_h]);
		} // union
		
		translate([-Case_x/2+4,-Case_y/2-CaseWall_t-IDXtra,-Base_h/2]) rotate([90,0,0]) Bolt4ClearHole();
	} // diff
} // CaseTop

//CaseTop(OneRly=true);

SG90_t=0.5*25.4;
SG90Ear_w=0.190*25.4;
SG90Ear_t=0.100*25.4;
SG90Body_w=0.893*25.4;
SG90Bot_h=0.652*25.4;
SG90Top_h=0.266*25.4;
SG90DriveBoss_d=0.454*25.4;
SG90DriveBoss_h=0.460*25.4;
SG90Drive_h=0.626*25.4;
SG90HoleOffset=0.100*25.4;
	SG90Mount_w=0.375*25.4;
	SG90Mount_t=0.250*25.4;

module SG90Servo(){
	translate([-SG90Body_w/2,0,-SG90_t/2])cube([SG90Body_w,SG90Bot_h,SG90_t]);
	difference(){
		translate([-SG90Body_w/2-SG90Ear_w,-SG90Ear_t,-SG90_t/2]) cube([SG90Body_w+SG90Ear_w*2,SG90Ear_t,SG90_t]);
		translate([-SG90Body_w/2-SG90HoleOffset,-SG90Ear_t,0]) rotate([90,0,0])Bolt2ClearHole();
		translate([SG90Body_w/2+SG90HoleOffset,-SG90Ear_t,0]) rotate([90,0,0])Bolt2ClearHole();
	} // diff
	translate([-SG90Body_w/2,-SG90Top_h,-SG90_t/2])cube([SG90Body_w,SG90Top_h,SG90_t]);
	translate([-SG90Body_w/2+SG90DriveBoss_d/2,-SG90DriveBoss_h,0])rotate([-90,0,0])cylinder(d=SG90DriveBoss_d,h=SG90DriveBoss_h);
	translate([-SG90Body_w/2+SG90DriveBoss_d/2,-SG90Drive_h,0])rotate([-90,0,0])cylinder(d=7,h=SG90Drive_h);
	translate([-SG90Body_w/2+SG90DriveBoss_d/2,-SG90Drive_h,0])rotate([-90,0,0])cylinder(d=19,h=1);
	
} // SG90Servo

//color("Red")SG90Servo();

ServoWheelOffset=5.5;
WingCL=15;

module VMountDrillGuide(){
	VMS_h=3;
	
	difference(){
		union(){
			hull(){
				translate([ServoWheelOffset,WingCL,0]) cylinder(d=10,h=VMS_h);
				translate([ServoWheelOffset,-WingCL,0]) cylinder(d=10,h=VMS_h);
				cylinder(d=10,h=VMS_h);
			}
		 // handlle
			hull(){
				translate([20,0,0]) cylinder(d=3,h=15);
			translate([5.5,0,0]) cylinder(d=3,h=15);
			}
	}
		translate([ServoWheelOffset,WingCL,0]) rotate([180,0,0]) Bolt6ClearHole();
		translate([ServoWheelOffset,-WingCL,0]) rotate([180,0,0]) Bolt6ClearHole();
		rotate([180,0,0]) Bolt6ClearHole();
	}
} // VMountDrillGuide

//VMountDrillGuide();

module VMountServo(){
	VMS_h=4; //32;
	VMS_w=SG90_t+6;
	VMS_x=35;
	
	difference(){
		union(){
			translate([ServoWheelOffset,0,VMS_h/2]) RoundRect(X=VMS_x,Y=VMS_w,H=VMS_h,R=3);
			
			
			hull(){ 
				translate([ServoWheelOffset,WingCL,0]) cylinder(d=10,h=VMS_h);
				translate([ServoWheelOffset,-WingCL,0]) cylinder(d=10,h=VMS_h);
			} // hull
			
			translate([ServoWheelOffset,WingCL,0]) cylinder(d=10,h=32);
			translate([ServoWheelOffset,-WingCL,0]) cylinder(d=10,h=32);
		} // union
		
		//translate([0,0,5]) cylinder(d=22,VMS_h);
		
		// Mounting screws
		translate([ServoWheelOffset,WingCL,0]) rotate([180,0,0]) Bolt6ClearHole(depth=32);
		translate([ServoWheelOffset,-WingCL,0]) rotate([180,0,0]) Bolt6ClearHole(depth=32);
		
		// ServoBody
		translate([5.5-SG90Body_w/2-IDXtra,-SG90_t/2-IDXtra,-Overlap]) 
			cube([SG90Body_w+IDXtra*2,SG90_t+IDXtra*2,VMS_h+Overlap*2]);
		// Servo mounting screws
		translate([5.5+SG90Body_w/2+SG90HoleOffset,0,0]) rotate([180,0,0]) Bolt2Hole();
		translate([5.5-SG90Body_w/2-SG90HoleOffset,0,0]) rotate([180,0,0]) Bolt2Hole();
	} // diff
	
	
} // VMountServo

//translate([0,0,-10.5]) VMountServo();

module VMountCtoS(){
	// Vertical Mount Collar to Servo
	Collar_d=7/32*25.4;
	VMCS_h=20;
	VMCS_d=18;
	
	difference(){
		cylinder(d=VMCS_d,h=VMCS_h);
		
		// Servo horn
		translate([0,0,-Overlap]) {
			cylinder(d=7,h=3.5);
			hull(){ cylinder(d=6,h=3.5); translate([VMCS_d/2,0,0])cylinder(d=4.7,h=3.5);}
			hull(){ cylinder(d=6,h=3.5); translate([-VMCS_d/2,0,0])cylinder(d=4.7,h=3.5);}
		}
		
		translate([0,0,-Overlap]) cylinder(d=Collar_d+IDXtra,h=VMCS_h+Overlap*2);
		translate([0,0,VMCS_h-3]) rotate([90,0,0]) Bolt2ClearHole();
	} // diff
	
} // VMountCtoS

//VMountCtoS();
//translate([5.5,0,-13]) rotate([-90,0,0]) color("Tan") SG90Servo();

module SG90Mount(){
	difference(){
		union(){
			translate([0,0,0])cube([SG90Mount_w,SG90Mount_t,SG90_t/2+3]);
		
		} // union
		translate([SG90HoleOffset,0,SG90_t/2]) rotate([90,0,0]) Bolt2Hole();
		
		translate([SG90Mount_w-3,3,SG90_t/2+3])Bolt4ClearHole();
	} // diff
	
} // SG90Mount

//translate([SG90Body_w/2,-SG90Mount_t-SG90Ear_t,-SG90_t/2])SG90Mount();

























