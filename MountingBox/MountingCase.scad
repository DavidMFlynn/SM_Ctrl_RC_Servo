// ******************************************
// R/C Servo Switch Machine Controller Case
// by David Flynn
// Created: 8/4/2017
// Revision: 1.1 9/13/2017
// Units: Inches
// ******************************************
// History
// 1.1 9/13/2017 Deeper, rounder, bigger text.
// 1.0 8/4/2017
// ******************************************
// for STL output
rotate([180,0,0])scale(25.4)translate([0,0,-Top_h])CaseTop(OneRly=false);
//rotate([180,0,0])scale(25.4)translate([0,0,-Top_h])CaseTop(OneRly=true);
scale(25.4)translate([Case_x+0.2,0,0])CaseBase();
//scale(25.4)SG90Mount();
//*******************************************
include <CommonStuffSAE.scad>

$fn=90;
Overlap=0.005;
IDXtra=0.008;

CaseWall_t=0.08;
PCB_OA_z=0.556; // to C2, 0.393 to IC1, not counting the relays
Base_h=0.4;

PCB_x=2.1;
PCB_y=2.3;
PCB_Bolt_x=1.925;
PCB_Bolt1_y=0.25;
PCB_Bolt2_y=2.05;
PCB_t=0.062+0.03; // 0.03 is gap
PCB_Bot=CaseWall_t+0.05;
Top_h=PCB_OA_z-Base_h+PCB_Bot+CaseWall_t;   //0.2;

MountingHoleSpacing=3;
PCB_Inset=0.05;

	Case_x=PCB_x+PCB_Inset*2+CaseWall_t*2;
	Case_y=PCB_y+PCB_Inset*2+CaseWall_t*2;

module RoundRect(X=1,Y=1,H=1,R=0.04){
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
			translate([0,0,Base_h/2])//cube([PCB_x+PCB_Inset*2+CaseWall_t*2,PCB_y+PCB_Inset*2+CaseWall_t*2,Base_h],center=true);
				RoundRect(X=Case_x,Y=Case_y,H=Base_h,R=0.04);
			
			// mounting tabs
			hull(){
				translate([0,-MountingHoleSpacing/2,0]) cylinder(d=0.5,h=0.125);
				translate([0,MountingHoleSpacing/2,0]) cylinder(d=0.5,h=0.125);
			} // hull
			
			
		} // union
		
		translate([0,0,Base_h/2+CaseWall_t])//cube([PCB_x+PCB_Inset*2,PCB_y+PCB_Inset*2,Base_h],center=true);
			RoundRect(X=PCB_x+PCB_Inset*2,Y=PCB_y+PCB_Inset*2,H=Base_h,R=0.04);
		
		translate([0,-MountingHoleSpacing/2,0.125]) Bolt6ClearHole();
		translate([0,MountingHoleSpacing/2,0.125]) Bolt6ClearHole();
		// PCB mounting screws
		translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,PCB_Bot]){
				translate([0,PCB_Bolt1_y,0]) Bolt4Hole();
				translate([0,PCB_Bolt2_y,0]) Bolt4Hole();
			}
			
		// case screws
		translate([-Case_x/2+0.2,-Case_y/2-CaseWall_t,Base_h/2]) rotate([90,0,0]) Bolt4Hole();
		mirror([0,1,0])
		translate([-Case_x/2+0.2,-Case_y/2-CaseWall_t,Base_h/2]) rotate([90,0,0]) Bolt4Hole();
	} // diff
	// PCB mounting screws
	difference(){
	translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,0]){
				translate([0,PCB_Bolt1_y,0]) cylinder(d=0.3,h=PCB_Bot);
				translate([0,PCB_Bolt2_y,0]) cylinder(d=0.3,h=PCB_Bot);
			}
			translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,PCB_Bot]){
				translate([0,PCB_Bolt1_y,0]) Bolt4Hole();
				translate([0,PCB_Bolt2_y,0]) Bolt4Hole();
			}
		} // diff
} // CaseBase

//translate([0,0,-Base_h-Overlap])CaseBase();

W1_y=2.2;
W2_y=0.1;
LED_x=1.6;
LED1_y=1.475;
LED2_y=1.15;
SW_x=1.9;
SW1_y=1.525;
SW2_y=1.075;
Rly_x=0.3;
Rly_y=0.05;
Rly_w=1.2;
Rly_h=1.1;
P2_x=1.375;
P2_y=2.075;
P2_w=0.350;
P2_h=0.150;

module CaseTop(OneRly=false){
	difference(){
		translate([0,0,Top_h/2])//cube([Case_x,Case_y,Top_h],center=true);
			RoundRect(X=Case_x,Y=Case_y,H=Top_h,R=0.04);
		
		translate([0,0,Top_h/2-CaseWall_t])//cube([PCB_x+PCB_Inset*2,PCB_y+PCB_Inset*2,Top_h],center=true);
			RoundRect(X=PCB_x+PCB_Inset*2,Y=PCB_y+PCB_Inset*2,H=Top_h,R=0.04);
		
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
		translate([-Case_x/2-Overlap,-PCB_y/2+W2_y-0.05,-Overlap])cube([CaseWall_t+Overlap*2,W1_y-W2_y+0.1,0.1]);
		// LEDs
		translate([-PCB_x/2+LED_x,-PCB_y/2,0]){
			translate([0,LED1_y,0])	cylinder(d=0.1,h=Top_h+Overlap);
			translate([0,LED2_y,0])	cylinder(d=0.1,h=Top_h+Overlap);}
		// Switches
		translate([-PCB_x/2+SW_x,-PCB_y/2,0]){
			translate([0,SW1_y,0])	cylinder(d=0.15,h=Top_h+Overlap);
			translate([0,SW2_y,0])	cylinder(d=0.15,h=Top_h+Overlap);}
			
		// Text
			TestDepth=0.0236;
		translate([-PCB_x/2,-PCB_y/2,Top_h-TestDepth]){
			translate([LED_x-0.08,LED1_y+0.1,0]) linear_extrude(height=TestDepth) text("N",0.18);
			translate([LED_x-0.08,LED2_y-0.28,0]) linear_extrude(height=TestDepth) text("R",0.18);
			translate([SW_x-0.08,SW1_y+0.1,0]) linear_extrude(height=TestDepth) text("+",0.24);
			translate([SW_x-0.08,SW2_y-0.1-0.05,0]) linear_extrude(height=TestDepth) text("_",0.24);
			translate([P2_x-0.2,P2_y,0]) linear_extrude(height=TestDepth) text("S",0.18);
			translate([P2_x+0.10,P2_y+0.16,0]) linear_extrude(height=TestDepth) text("+ -",0.18);
			translate([0.00,PCB_y-0.25,0]) linear_extrude(height=TestDepth) text("R/C",0.22);
			translate([0.00,PCB_y-0.55,0]) linear_extrude(height=TestDepth) text("Servo SM",0.22);
			translate([0.20,PCB_y-2.35,0]) rotate([0,0,90]) linear_extrude(height=TestDepth) text("DMFE 2017",0.22);
			
		}
	} // diff
	
	// PCB mounting screws
	Post_l=Base_h-PCB_Bot-PCB_t+Top_h-Overlap;
	difference(){
			translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,-Base_h+PCB_Bot+PCB_t]){
				translate([0,PCB_Bolt1_y,0]) cylinder(d=0.3,h=Post_l);
				translate([0,PCB_Bolt2_y,0]) cylinder(d=0.3,h=Post_l);
			}
			translate([-PCB_x/2+PCB_Bolt_x,-PCB_y/2,Top_h]){
				translate([0,PCB_Bolt1_y,0]) Bolt4HeadHole(lDepth=Top_h+Base_h);
				translate([0,PCB_Bolt2_y,0]) Bolt4HeadHole(lDepth=Top_h+Base_h);
			}
		} // diff
		
	// case screws
	difference(){
		union(){
			translate([-Case_x/2,-Case_y/2-CaseWall_t/2,0]) cube([0.4,CaseWall_t,Top_h]);
			translate([-Case_x/2,-Case_y/2-CaseWall_t-IDXtra,-Base_h]) cube([0.4,CaseWall_t,Base_h+Top_h]);}
			translate([-Case_x/2+0.2,-Case_y/2-CaseWall_t-IDXtra,-Base_h/2]) rotate([90,0,0]) Bolt4ClearHole();
	} // diff
	mirror([0,1,0])
	difference(){
		union(){
			translate([-Case_x/2,-Case_y/2-CaseWall_t/2,0]) cube([0.4,CaseWall_t,Top_h]);
			translate([-Case_x/2,-Case_y/2-CaseWall_t-IDXtra,-Base_h]) cube([0.4,CaseWall_t,Base_h+Top_h]);}
			translate([-Case_x/2+0.2,-Case_y/2-CaseWall_t-IDXtra,-Base_h/2]) rotate([90,0,0]) Bolt4ClearHole();
	} // diff
} // CaseTop

//CaseTop(OneRly=true);

SG90_t=0.5;
SG90Ear_w=0.190;
SG90Ear_t=0.100;
SG90Body_w=0.893;
SG90Bot_h=0.652;
SG90Top_h=0.266;
SG90DriveBoss_d=0.454;
SG90DriveBoss_h=0.460;
SG90Drive_h=0.626;
SG90HoleOffset=0.100;
	SG90Mount_w=0.375;
	SG90Mount_t=0.250;

module SG90Servo(){
	translate([-SG90Body_w/2,0,-SG90_t/2])cube([SG90Body_w,SG90Bot_h,SG90_t]);
	difference(){
		translate([-SG90Body_w/2-SG90Ear_w,-SG90Ear_t,-SG90_t/2]) cube([SG90Body_w+SG90Ear_w*2,SG90Ear_t,SG90_t]);
		translate([-SG90Body_w/2-SG90HoleOffset,-SG90Ear_t,0]) rotate([90,0,0])Bolt2ClearHole();
		translate([SG90Body_w/2+SG90HoleOffset,-SG90Ear_t,0]) rotate([90,0,0])Bolt2ClearHole();
	} // diff
	translate([-SG90Body_w/2,-SG90Top_h,-SG90_t/2])cube([SG90Body_w,SG90Top_h,SG90_t]);
	translate([-SG90Body_w/2+SG90DriveBoss_d/2,-SG90DriveBoss_h,0])rotate([-90,0,0])cylinder(d=SG90DriveBoss_d,h=SG90DriveBoss_h);
	translate([-SG90Body_w/2+SG90DriveBoss_d/2,-SG90Drive_h,0])rotate([-90,0,0])cylinder(d=0.275,h=SG90Drive_h);
	translate([-SG90Body_w/2+SG90DriveBoss_d/2,-SG90Drive_h,0])rotate([-90,0,0])cylinder(d=0.75,h=0.05);
	
} // SG90Servo

//color("Red")SG90Servo();

module SG90Mount(){
	difference(){
		union(){
			translate([0,0,0])cube([SG90Mount_w,SG90Mount_t,SG90_t/2+0.125]);
		
		} // union
		translate([SG90HoleOffset,0,SG90_t/2]) rotate([90,0,0]) Bolt2Hole();
		
		translate([SG90Mount_w-0.125,0.125,SG90_t/2+0.125])Bolt4ClearHole();
	} // diff
	
} // SG90Mount

//translate([SG90Body_w/2,-SG90Mount_t-SG90Ear_t,-SG90_t/2])SG90Mount();

























