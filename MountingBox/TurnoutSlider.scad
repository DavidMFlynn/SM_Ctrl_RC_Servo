// ****************************************
// Turnout slider
// Filename: TurnoutSlider.scad
// by Dave Flynn
// Created: 10/20/2020
// Revision: 1.1   11/17/2020
// Units: mm
// ****************************************
//  ***** History *****
// 1.1   11/17/2020 Added ExtendedSlider and mount
// 1.0   10/21/2020 Turnout lock.
// 0.9   10/20/2020 First code.
// ****************************************
//  ***** for STL output
// MountingBlock(HasLock=false);
// mirror([0,1,0]) MountingBlock(HasLock=false);
// MountingBlock(HasLock=true); // for #6 left
// mirror([0,1,0]) MountingBlock(HasLock=true); // for #6 right
//
// Slider();
// ExtendedSlider(L=80);
// ExtenderMount(); // used with ExtendedSlider
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

module ExtendedSlider(L=30){
	
	
	difference(){
		union(){
			hull(){
				translate([-Dove_w/2,-Silde_L/2,0]) cube([Dove_w,Silde_L,0.6]);
				translate([-Dove_w2/2,-Silde_L/2,Dove_h]) cube([Dove_w2,Silde_L,0.01]);
			} // hull
			
			translate([0,-L,0])
			hull(){
				translate([-Dove_w/2,-Silde_L/2,0]) cube([Dove_w,Silde_L,0.6]);
				translate([-Dove_w2/2,-Silde_L/2,Dove_h]) cube([Dove_w2,Silde_L,0.01]);
			} // hull
			
			// torsion rod guides
			translate([0,Silde_L/4,0]){
				translate([0,2,Dove_h-Overlap]) cylinder(d=3,h=2);
				translate([0,-2,Dove_h-Overlap]) cylinder(d=3,h=2);
			}
			
			// connector bar
			hull(){
				translate([0,-L,0]) cylinder(d=Dove_w2,h=2.2);
				cylinder(d=Dove_w2,h=2.2);
			} // hull
		} // union
		
		
		// throw rod
		translate([0,-L-Silde_L/4,0]){
		translate([0,0,-Overlap]) cylinder(d=SM_Rod_d+IDXtra*2,h=Dove_h);
		translate([0,0,1.3]) cylinder(d=4,h=Dove_h);
		}
		
		
	} // difference
} // ExtendedSlider

// translate([-4,0,0]) ExtendedSlider(L=30);

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


module ExtenderMount(){
	Travel=4.0; // 3.5 is not quite enough
	MB_L=30;
	MB_W=Silde_L+Travel;
	RoadBed_H=4.7; // Woodland Scenics Track-Bed
	MB_H=RoadBed_H+1.5;
	
	BoltInset=4.5;
	
	difference(){
		translate([-4,0,0]) RoundRect(X=MB_L,Y=MB_W,Z=MB_H,R=2);
		
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
		translate([-4,0,0]){
		translate([-MB_L/2+BoltInset,-4,MB_H]) Bolt4ButtonHeadHole();
		translate([MB_L/2-BoltInset,-4,MB_H]) Bolt4ButtonHeadHole();}
			
		//translate([-MB_L/2-Overlap,-MB_W/2-Overlap,RoadBed_H]) cube([MB_L+Overlap*2,7,2]);
		
	} // difference
	
} // ExtenderMount

//translate([0,-30,-2.2]) ExtenderMount();

module MountingBlock(HasLock=false){
	Travel=4.0; // 3.5 is not quite enough
	MB_L=40;
	MB_W=Silde_L+Travel;
	RoadBed_H=4.7; // Woodland Scenics Track-Bed
	MB_H=RoadBed_H+1.5;
	ThrowBar_w=5.6+1;
	
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
			
		//translate([-MB_L/2-Overlap,-MB_W/2-Overlap,RoadBed_H]) cube([MB_L+Overlap*2,7,2]);
		
		// Throw bar
		translate([MB_L/2-BoltInset*2-ThrowBar_w,-MB_W/2-Overlap,RoadBed_H]) cube([ThrowBar_w,MB_W+Overlap*2,MB_H]);
	} // difference
	
	// torsion rod guides
    translate([-MB_L/2+3,Silde_L/4,MB_H-Overlap]){
        translate([0,2,0]) cylinder(d=3,h=2);
        translate([0,-2,0]) cylinder(d=3,h=2);
    }
    
    // Atlas Turnout Lock
    Lock_X=18;
    Lock_Y=6.5;
    LockBody_Edge=6.6; // from center of throw bar
    if (HasLock==true) difference(){
        translate([MB_L/2-Lock_X/2,MB_W/2,0]) RoundRect(X=Lock_X,Y=Lock_Y*2,Z=MB_H,R=2);
        
        // Throw bar
		translate([MB_L/2-BoltInset*2-ThrowBar_w,-MB_W/2-Overlap,RoadBed_H]) cube([ThrowBar_w,MB_W+Lock_Y+Overlap*2,MB_H]);
        
        // Lock Tie
        translate([MB_L/2-BoltInset*2-ThrowBar_w/2,MB_W/2+2,RoadBed_H]) cube([LockBody_Edge,Lock_Y,MB_H]);
        
        translate([MB_L/2-BoltInset*2-ThrowBar_w/2+LockBody_Edge+1.5,MB_W/2+2+0.1,RoadBed_H]) hull(){
            cylinder(d=0.2,h=MB_H);
            translate([-1.5,0,0]) cylinder(d=0.2,h=MB_H);
            translate([0,1.5,0]) cylinder(d=0.2,h=MB_H);
            translate([-1.5,2.8,0]) cylinder(d=0.2,h=MB_H);
        }
    }
} // MountingBlock

//translate([0,0,-2.2]) MountingBlock();
//translate([-4,0,0]) Slider();

























