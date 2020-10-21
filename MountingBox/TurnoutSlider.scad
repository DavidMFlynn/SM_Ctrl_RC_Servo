// ****************************************
// Turnout slider
// Filename: TurnoutSlider.scad
// by Dave Flynn
// Created: 10/20/2020
// Revision: 0.9   10/20/2020
// Units: mm
// ****************************************
//  ***** History *****
// 0.9   10/20/2020 First code.
// ****************************************
//  ***** for STL output
// MountingBlock();
// Slider();
// ****************************************

include<CommonStuffSAEmm.scad>

Overlap=0.05;
IDXtra=0.2;
$fn=$preview? 24:90;

SM_Rod_d=0.0625*25.4;

	Dove_w=10;
	Dove_w2=6;
	Dove_h=3.5;
Silde_L=14;

module Slider(){
	
	
	difference(){
		union(){
			hull(){
				translate([-Dove_w/2,-Silde_L/2,0]) cube([Dove_w,Silde_L,0.6]);
				translate([-Dove_w2/2,-Silde_L/2,Dove_h]) cube([Dove_w2,Silde_L,0.01]);
			} // hull
			
			// torsion rod guides
			translate([0,Silde_L/4,0]){
				translate([0,2,Dove_h-Overlap]) cylinder(d=3,h=2);
				translate([0,-2,Dove_h-Overlap]) cylinder(d=3,h=2);
			}
		} // union
		
		// throw rod
		translate([0,-Silde_L/4,0]){
		translate([0,0,-Overlap]) cylinder(d=SM_Rod_d+IDXtra*2,h=Dove_h);
		translate([0,0,1.3]) cylinder(d=4,h=Dove_h);
		}
		
		
	} // difference
} // Slider

// Slider();

module RoundRect(X,Y,Z,R){
	hull(){
		translate([-X/2+R,-Y/2+R,0]) cylinder(r=R,h=Z);
		translate([-X/2+R,Y/2-R,0]) cylinder(r=R,h=Z);
		translate([X/2-R,-Y/2+R,0]) cylinder(r=R,h=Z);
		translate([X/2-R,Y/2-R,0]) cylinder(r=R,h=Z);
	} // hull
} // RoundRect

module MountingBlock(){
	Travel=4;
	MB_L=35;
	MB_W=Silde_L+Travel;
	RoadBed_H=3/16*25.4;
	MB_H=RoadBed_H+1.5;
	ThrowBar_w=3;
	
	BoltInset=4.5;
	
	difference(){
		RoundRect(X=MB_L,Y=MB_W,Z=MB_H,R=2);
		
		translate([-4,0,0]){
		// Dove
		hull(){
			translate([-Dove_w/2-IDXtra,-MB_W/2-Overlap,2]) cube([Dove_w+IDXtra*2,MB_W+Overlap*2,0.6+IDXtra]);
			translate([-Dove_w2/2-IDXtra,-MB_W/2-Overlap,2+Dove_h+IDXtra*2]) cube([Dove_w2+IDXtra*2,MB_W+Overlap*2,0.01]);
		} // hull
		translate([-Dove_w2/2-IDXtra,-MB_W/2-Overlap,2+Dove_h+IDXtra*2]) cube([Dove_w2+IDXtra*2,MB_W+Overlap*2,MB_H]);
		
		// throw rod slot
		translate([0,-Silde_L/4,-Overlap])
			hull(){
				translate([0,-Travel/2,0]) cylinder(d=SM_Rod_d+IDXtra*2,h=MB_H);
				translate([0,Travel/2,0]) cylinder(d=SM_Rod_d+IDXtra*2,h=MB_H);
			} // hull
		}
		
		// Mounting holes
		translate([-MB_L/2+BoltInset,-4,MB_H]) Bolt4ButtonHeadHole();
		translate([MB_L/2-BoltInset,-4,MB_H]) Bolt4ButtonHeadHole();
			
		// Throw bar
		translate([MB_L/2-BoltInset*2-1-ThrowBar_w/2,-MB_W/2-Overlap,RoadBed_H]) cube([ThrowBar_w,MB_W+Overlap*2,MB_H]);
	} // difference
	
	// torsion rod guides
			translate([-MB_L/2+3,Silde_L/4,MB_H-Overlap]){
				translate([0,2,0]) cylinder(d=3,h=2);
				translate([0,-2,0]) cylinder(d=3,h=2);
			}
} // MountingBlock

//translate([0,0,-2.2]) MountingBlock();
//translate([-4,0,0]) Slider();

























