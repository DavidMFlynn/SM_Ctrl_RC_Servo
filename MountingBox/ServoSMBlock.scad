// *************************************************
// Standard Servo Switch Machine Block & Adaptor
// by Dave Flynn
// Filename:ServoSMBlock.scad
// Created: 8/18/2018
// Revision: 1.0a1 7/17/2019
// Units: mm
// **************************************************
//  ***** History ******
// 1.0a1 7/17/2019 RC1, Servo and PCB mount, Ball servo horn.
// 1.0d1 8/18/2018 First rev'd version
//
// **************************************************
//  ***** for STL output *****
// Arm(L=37.5);
// SMBlock();
// SMBlock(PCBMount="G2RrA");
// mirror([1,0,0]) SMBlock(PCBMount="G2RrA"); // Left side mount
// **************************************************


include<CommonStuffSAEmm.scad>
include<LD-20MGServoLib.scad>

$fn=90;
Overlap=0.05;
IDXtra=0.2;



module Arm(L=37.5){
	// Arm for MG996R servo
	//Ball_d=3/8*25.4;
	Ball_d=5/16*25.4;
	Arm_h=5;
	S_Wheel_d=21;
	
	module ArmBall(){
		Wire_d=0.055*25.4;
		
		difference(){
			sphere(d=Ball_d,$fn=30);
			translate([0,0,-Ball_d/2-Overlap]) cylinder(d=Wire_d+IDXtra,h=Ball_d+Overlap*2);
		} // diff
	} // ArmBall

	//ArmBall();
	
	difference(){
		union(){
			cylinder(d=S_Wheel_d,h=Arm_h);
			
			hull(){
				cylinder(d=(S_Wheel_d+Ball_d)/2,h=Arm_h);
				
				translate([L,0,0]) cylinder(d=Ball_d+4,h=Arm_h);
			} // hull
			
		} // union
		
		// the ball
		translate([L,0,Arm_h/2]) sphere(d=Ball_d+IDXtra,$fn=60);
		translate([L,0,-Overlap]) cylinder(d=Ball_d*0.707,h=Arm_h+Overlap*2);
		
		// slot
		translate([L-Ball_d,-0.5,-Overlap]) cube([Ball_d*2+Overlap,1,Arm_h+Overlap*2]);
		
		// screw access
		translate([0,0,-Overlap]) cylinder(d=8,h=Arm_h+Overlap*2);
		
		// Mounting screws
		for (j=[0:3]) rotate([0,0,90*j]) translate([8,0,Arm_h]) Bolt2ClearHole();
	} // diff
	
	
} // Arm

//Arm(L=37.5);

module RoundRect(X=10,Y=10,Z=2,R=1){
	hull(){
	translate([-X/2+R,-Y/2+R,0]) cylinder(r=R,h=Z);
	translate([X/2-R,-Y/2+R,0]) cylinder(r=R,h=Z);
	translate([-X/2+R,Y/2-R,0]) cylinder(r=R,h=Z);
	translate([X/2-R,Y/2-R,0]) cylinder(r=R,h=Z);
	}
} // RoundRect

module SMBlock(PCBMount=""){
	// or "G2RrA" or "G2RMini"
	
	Block_x=2.75*25.4;
	Block_y=3.625*25.4;
	Block_z=12; // 0.75*25.4;
	BlockChamfer=0.094*25.4;
	
	Shaft_x=0.5625*25.4;
	Shaft_y=1.0*25.4;
	Shaft_z=50; // 2.5*25.4;
	Servo_Shaft_Offset=9.85;
	Servo_TopOfWheel=20.6;
	Servo_y=54.5;
	Servo_Body_l=40.5;
	Servo_h1=19.3; // bottom of servo to bottom of mount
	Servo_w=20.2;
	
	MH_x=1*25.4;
	MH_y=1.875*25.4;
	
	// G2R Rev A
	PCBG2RrA_X=2.3*25.4;
	PCBG2RrA_Y=2.10*25.4;
	PCBG2RrA_BC_X=1.80*25.4;
	PCBG2RrA_Bolt_Y=0.20*25.4;
	PCBG3RrA_Loc_Y=-14;

	
	// G2R Mini PCB
	PCB_X=2.3*25.4;
	PCB_Y=1.85*25.4;
	PCB_BC_X=2.0*25.4;
	PCB_Bolt_Y=0.15*25.4;
	PCB_Loc_Y=-12;
	
	difference(){
		union(){
			hull(){
				//translate([0,0,(Block_z-BlockChamfer)/2]) cube([Block_x,Block_y,Block_z-BlockChamfer],center=true);
				RoundRect(X=Block_x,Y=Block_y,Z=Block_z-BlockChamfer,R=2);
				translate([0,0,Block_z/2]) cube([Block_x-BlockChamfer*2,Block_y-BlockChamfer*2,Block_z],center=true);
			} // hull
			
			// Servo mounts
			translate([Shaft_x-(Servo_w/2-Overlap),Shaft_y-Servo_Shaft_Offset-(Servo_y/2+1),0]) 
				cube([Servo_w-Overlap*2,Servo_y+2,Servo_h1+10]);
		} // union
		
		// mounting holes
		translate([-MH_x/2,MH_y/2,Block_z]) Bolt6ClearHole(depth=Block_z);
		translate([MH_x/2,-MH_y/2,Block_z]) Bolt6ClearHole(depth=Block_z);
		
		//wire path
		translate([Shaft_x,Shaft_y+11,2]) cylinder(d=8,h=30);
		translate([Shaft_x,Shaft_y+11,4]) rotate([0,-45,0]) cylinder(d=8,h=30);
		
		// Servo
		translate([Shaft_x,Shaft_y,Shaft_z-Servo_TopOfWheel]) rotate([0,0,90]) Servo_LD20MG(BottomMount=false,TopAccess=false);
		// remove servo bottom
		translate([Shaft_x-10.25,Shaft_y-20-10,-Overlap]) cube([20.5,40.5,3]);
	
		// Remove extra
		translate([-MH_x/2,-MH_y/2,-Overlap])hull(){
			cylinder(d=22,h=Block_z+Overlap*2);
			translate([0,20,0]) cylinder(d=22,h=Block_z+Overlap*2);
		}
	
	} // diff
	
	//PCB mount for RC servo controller
	if (PCBMount=="G2RMini")
	translate([1,PCB_Loc_Y,Block_z-Overlap]){
		difference(){
			union(){
				translate([-PCB_Bolt_Y,-PCB_BC_X/2,0])  hull(){
					translate([0,0,PCB_Bolt_Y+1]) rotate([0,90,0]) cylinder(d=8,h=6);
					translate([0,-5,0]) cube([6,10,1]);}
					
				translate([-PCB_Bolt_Y,PCB_BC_X/2,0])  hull(){
					translate([0,0,PCB_Bolt_Y+1]) rotate([0,90,0]) cylinder(d=8,h=6);
					translate([0,-5,0]) cube([6,10,1]);}
			} // union
		
			translate([-PCB_Bolt_Y,-PCB_BC_X/2,PCB_Bolt_Y+1]) rotate([0,-90,0])Bolt6Hole();
			translate([-PCB_Bolt_Y,PCB_BC_X/2,PCB_Bolt_Y+1]) rotate([0,-90,0])Bolt6Hole();}
		} // diff
	
	if (PCBMount=="G2RrA")
	translate([1,PCBG3RrA_Loc_Y,Block_z-Overlap]){
		difference(){
			union(){
				translate([-PCBG2RrA_Bolt_Y,-PCBG2RrA_BC_X/2,0])  hull(){
					translate([0,0,PCBG2RrA_Bolt_Y+1]) rotate([0,90,0]) cylinder(d=8,h=6);
					translate([0,-5,0]) cube([6,10,1]);}
					
				translate([-PCBG2RrA_Bolt_Y,PCBG2RrA_BC_X/2,0])  hull(){
					translate([0,0,PCBG2RrA_Bolt_Y+1]) rotate([0,90,0]) cylinder(d=8,h=6);
					translate([0,-5,0]) cube([6,10,1]);}
			} // union
		
			translate([-PCBG2RrA_Bolt_Y,-PCBG2RrA_BC_X/2,PCBG2RrA_Bolt_Y+1]) rotate([0,-90,0]) Bolt6Hole();
			translate([-PCBG2RrA_Bolt_Y,PCBG2RrA_BC_X/2,PCBG2RrA_Bolt_Y+1]) rotate([0,-90,0]) Bolt6Hole();}
		} // diff
		
	// PCB G2R Mini
	//translate([-3,PCB_Loc_Y,0])
	//translate([0,-PCB_X/2,Block_z]) color("Red") rotate([0,-90,0]) cube([PCB_Y,PCB_X,1.5]);
	
		// PCB G2R Rev A
	//translate([-4.5,PCBG3RrA_Loc_Y,0])
	//translate([0,-PCBG2RrA_X/2,Block_z]) color("Red") rotate([0,-90,0]) cube([PCBG2RrA_Y,PCBG2RrA_X,1.5]);

} // SMBlock

//SMBlock();

module HPRRSMBlock(){
	Block_x=2.75*25.4;
	Block_y=3.625*25.4;
	Block_z=12; // 0.75*25.4;
	BlockChamfer=0.094*25.4;
	
	Shaft_x=0.5625*25.4;
	Shaft_y=1.0*25.4;
	Shaft_z=2.5*25.4;
	Servo_Shaft_Offset=9.85;
	Servo_TopOfWheel=21.4;
	Servo_y=54.5;
	Servo_Body_l=40.5;
	Servo_h1=28.2; // bottom of servo to bottom of mount
	Servo_w=20.2;
	
	MH_x=1*25.4;
	MH_y=1.875*25.4;
	
	PH_x = 2.125 * 25.4;
	PH_y1 = 3 * 25.4;
	PH_y2 = 2 * 25.4;
	PH_y3 = 1 * 25.4;
	
	SH_x = 2.25 * 25.4;
	
	EH_x = 1.1 * 25.4;
	
	difference(){
		union(){
			hull(){
				translate([0,0,(Block_z-BlockChamfer)/2]) cube([Block_x,Block_y,Block_z-BlockChamfer],center=true);
				translate([0,0,Block_z/2]) cube([Block_x-BlockChamfer*2,Block_y-BlockChamfer*2,Block_z],center=true);
			} // hull
			
			// Servo mounts
			//translate([Shaft_x,Shaft_y-Servo_Shaft_Offset,Servo_h1-5-0.4]) cube([Servo_w-Overlap*2,Servo_y+2,Servo_h1+10],center=true);
		} // union
		
		// mounting holes
		translate([-MH_x/2,MH_y/2,Block_z]) Bolt6ClearHole(depth=Block_z);
		translate([MH_x/2,-MH_y/2,Block_z]) Bolt6ClearHole(depth=Block_z);
		translate([-MH_x/2,-MH_y/2,Block_z]) Bolt6ClearHole(depth=Block_z);
		translate([MH_x/2,MH_y/2,Block_z]) Bolt6ClearHole(depth=Block_z);
		
		// perimeter holes
		translate([-PH_x/2,PH_y1/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([-PH_x/2,PH_y2/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([-PH_x/2,PH_y3/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([PH_x/2,PH_y1/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([PH_x/2,PH_y2/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([PH_x/2,PH_y3/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([-PH_x/2,-PH_y1/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([-PH_x/2,-PH_y2/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([-PH_x/2,-PH_y3/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([PH_x/2,-PH_y1/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([PH_x/2,-PH_y2/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([PH_x/2,-PH_y3/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		
		translate([0,PH_y1/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([-EH_x/2,PH_y1/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([EH_x/2,PH_y1/2,Block_z]) Bolt6Hole(depth=Block_z-3);
		
		// Solenoid holes
		translate([0,0,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([-SH_x/2,0,Block_z]) Bolt6Hole(depth=Block_z-3);
		translate([SH_x/2,0,Block_z]) Bolt6Hole(depth=Block_z-3);
		
		
		// Servo
		//translate([Shaft_x,Shaft_y,Shaft_z-Servo_TopOfWheel]) rotate([0,0,90]) Servo_LD20MG(BottomMount=false,TopAccess=false);
	} // diff
	
	// Servo
		translate([Shaft_x,Shaft_y,Shaft_z-Servo_TopOfWheel]) rotate([0,0,90]) Servo_LD20MG(BottomMount=false,TopAccess=false);
	
} // HPRRSMBlock

//HPRRSMBlock();




























