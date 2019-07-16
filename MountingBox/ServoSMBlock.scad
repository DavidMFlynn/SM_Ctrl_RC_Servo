// *************************************************
// Standard Servo Switch Machine Block & Adaptor
// by Dave Flynn
// Filename:ServoSMBlock.scad
// Created: 8/18/2018
// Revision: 1.0d1 8/18/2018
// Units: mm
// **************************************************

include<CommonStuffSAEmm.scad>
include<LD-20MGServoLib.scad>

$fn=90;
Overlap=0.05;
IDXtra=0.2;



module Arm(L=30){
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

//Arm();

module SMBlock(){
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
	
	// G2R Mini PCB
	PCB_X=2.3*25.4;
	PCB_Y=1.85*25.4;
	PCB_BC_X=2.0*25.4;
	PCB_Bolt_Y=0.15*25.4;
	
	difference(){
		union(){
			hull(){
				translate([0,0,(Block_z-BlockChamfer)/2]) cube([Block_x,Block_y,Block_z-BlockChamfer],center=true);
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
		translate([Shaft_x,Shaft_y+9,4]) rotate([0,-45,0]) cylinder(d=8,h=30);
		
		// Servo
		translate([Shaft_x,Shaft_y,Shaft_z-Servo_TopOfWheel]) rotate([0,0,90]) Servo_LD20MG(BottomMount=false,TopAccess=false);
		
		//PCB mount for RC servo controller
	
	
	} // diff
	
	translate([1,-12,Block_z-Overlap]){
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
	
		
	// PCB
	//translate([-3,-12,0])
	//translate([0,-PCB_X/2,Block_z]) color("Red") rotate([0,-90,0]) cube([PCB_Y,PCB_X,1.5]);
	
} // SMBlock

SMBlock();

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




























