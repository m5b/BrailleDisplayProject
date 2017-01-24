//some globals that help with pin adjustment, not even sure if I use them anymore!
width=80;
bearing_radius = 8;//11.8;
bearing_height = 6;
pin_rad = .9;//.4

/*
I have added individual cam stl's to the repository. To print them in either ABS or cut with laser, arrange appropriately and export.
The cam stl file names are:

Cam responsible for top row of braille cell:
camTopA.stl
camTopB.stl
camTopC.stl

Cam responsible for middle row of braille cell:
camMidA.stl
camMidB.stl
camMidC.stl

Cam responsible for bottom row of braille cell:
camBotA.stl
camBotB.stl
camBotC.stl

Example:
import("camBotA.stl");
*/

/*
uncomment the follow assembly methods to view full assembly of a cam and the frame
*/
//assembledcam();
assembly(false);

/*
Print lift pins
n = number to print
*/
module printSingleLiftPin(n){
    for(i=[0:n-1]){
        x = i*20;
        if(i%2==0){
            translate([x,0,0]) rotate([90,0,0]) liftPin(.4);
        }else{
            translate([x,-15,0]) rotate([90,0,0]) liftPin(.4);
        }
    }
}

/*
Print long lift pins
n = number to print
*/
module printLongLiftPins(n){
    for(i=[0:n-1]){
        x = i*8;
        if(i%2==0){
            translate([0,x,0]) rotate([90,0,0]) liftPinLong(pin_rad,false);
        }else{
            translate([50,x-8,0])  rotate([90,0,0]) liftPinLong(pin_rad,false);
        }
    }
}
/*
Print cam shafts
n = number to print
*/
module printCamshaft(n){
    for(i=[0:n-1]){
        x = i*8;
        if(i%2==0){
            translate([0,x,0]) camshaft();
        }else{
            translate([58,x-8,0]) camshaft();
        }
    }
}
/*
Creates a printable top plate.
*/
module printTopPlate(){
    rotate([0,180,0]) difference(){
        rotate([0,0,0]) coverplate(true);
        translate([-18,0,0]) rotate([0,0,0]) frontplate(.8);
        translate([15,0,0]) rotate([0,0,0]) backplate(.8);
    }
}
/*
Creates a printable base plate.
*/
module printBasePlate(){
    difference(){
        baseplate(true);
        translate([-18,0,0]) rotate([0,0,0]) frontplate(.8);
        translate([15,0,0]) rotate([0,0,0]) backplate(.8);
    }
}
/*
This is a view of an assembled cam.  Rendering the actual cams takes a long time, so it is easier to use the stl file for positioning and placement of pins and supporting frame.  Use this to make alignment adjustments, etc.
*/
module assembledcam(){
	import("braille_display_allcams.stl");
}
/*
A view of the entire assembly.
p = to pass on the print boolean used by pin modules
*/
module assembly(p=true){
    // Center Pins
    //centerPins(-11.9, 13.2, 180, p);
    //centerPins(13.9,13.2, 0, p);

    // Edge Pins
    //edgePins(6,41.5,true,p);
    //edgePins(19.9,41.5,false,p);

	rotate([0,0,0]) coverplate(true);
	//baseplate(true);
	translate([-18,0,0]) rotate([0,0,0]) frontplate();
	translate([15,0,0]) rotate([0,0,0]) backplate();

    //Using this for quick spacing eye check, leave commented out.
    //translate([-20,0,0]) color("red") cube([20,20,20]);
}
/*
All cams positioning wholes to be used with front and back plates.
*/
module camset(){
    //rotary pot
    translate([15,7.65,0]) {
        translate([0,0,0]) rotate([0,90,0]) cylinder(r=8, h=50);
        translate([-50,0,0]) rotate([0,90,0]) cylinder(d=7.5, h=100);
        translate([-21,0,0]) cube([5,13,14], center=true);
    }
    //bearing
    translate([0,-7.25,0]) {
		translate([-50,0,0]) rotate([0,90,0]) cylinder(r=8, h=50);
		translate([0,0,0]) rotate([0,90,0]) cylinder(d=7.5, h=100);
		translate([33,0,0]) cube([5,13,14], center=true);
	}
}

/*
Latches to be embedded onto the front and back plates for locking down the cover plate.
*/
module plateLatch() {
    latchRadius = 1.4;
    color("magenta")
    rotate([90, 0, 0]) {
        cylinder(r=latchRadius, h=96, $fn=40);
        
        translate([0, -3, 0])
            cylinder(r=latchRadius, h=96, $fn=40);
    }
}

/*
The front plate for the display with rotary pot and bearing slots differenced out.
pad = additional adding to account for width variation in print. Use when differencing with top and base plates.
*/
module frontplate(pad = 0){
	difference(){
		translate([-5,0,14]) color("green") cube([5+pad,96+pad,58], center=true);
		camset();
    	translate([0,-19,25]) camset();
    	translate([0,20,25]) camset();
	}

    // Latches
    translate([-7.5, 48, 37.5]) {
        plateLatch();
    }
}
/*
The back plate for the display with rotary pot and bearing slots differenced out.
pad = additional adding to account for width variation in print. Use when differencing with top and base plates.
*/
module backplate(pad = 0){
	difference(){
		translate([32,0,14]) color("cyan") cube([5+pad,96+pad,58], center=true);
		camset();
    	translate([0,-19,25]) camset();
    	translate([0,20,25]) camset();
	}

    // Latches
    translate([34.5, 48, 37.5]) {
        plateLatch();
    }
}
/*
The coverplate for the display with all pins differenced out.
*/
module coverplate(print=true){
    // The cover plate itself
	difference(){
	  translate([12,0,42]) color("blue") cube([82,100,5], center=true);
	  centerPins(-11.9, 13.2, 180, print);
	  centerPins(13.9,13.2, 0, print);
	  edgePins(6,41.5,true,print);
	  edgePins(19.9,41.5,false,print);
	}

    // Side latches
    module coverLatch() {
        latchRadius = 1.25;

        cube([1.5, 100, 3.5]);
        translate([latchRadius, 0, 0]) {
            rotate([270, 0, 0]) {
                cylinder(h=100, r=latchRadius, $fn=40);
            }
        }
    }

    color("yellow")
    union() {
        translate([-29, -50, 36]) {
            coverLatch();
        }

        translate([53, 50, 36]) {
            rotate([0, 0, 180]) {
                coverLatch();
            }
        }
    }
}
/*
The baseplate for the display with all pins differenced out.
*/
module baseplate(print=true){
	difference(){
	  translate([12,0,-13.5]) color("blue") cube([78,100,5], center=true);
	  centerPins(-11.9, 13.2, 180, print);
	  centerPins(13.9,13.2, 0, print);
	}
}


module camshaft(){
        color("blue") translate([0,0,0]) cube([49.5,8.5,4.5]);
}
/*
Displays 8 center lift pins arranged according to braille standard
loc = moves pin +/- along the x axis
z = moves pin +/i along hte z axis
r = rotates pinset along the z axis
print = if true, adds padding to either side of support edge of pins.  Set to true when using to difference insets from top plate.
*/

module centerPins(loc=0,z=0, r=0, print=false){
	rotate([0,0,r]){

        // Apparently there is slight misalignment that happens on the rotated pieces...
        xOffset = r == 0 ? 0 : 0.05;

	  	translate([loc + xOffset,-.75,z]){
		  translate([0,0,0])  centerLiftPin(.4, 30, print);
		  translate([3,0,0])  centerLiftPin(.4, 30, print);
		  translate([7,0,0])  centerLiftPin(.4, 30, print);
		  translate([10,0,0]) centerLiftPin(.4, 30, print);
  		}
    }
}
/*
Displays 8 short or long lift pins arranged according to braille standard
loc = moves pin +/- along the x axis
z = moves pin +/i along hte z axis
short = true for short pint, false for long pin
print = if true, adds padding to either side of support edge of pins.  Set to true when using to difference insets from top plate.
*/

module edgePins(loc=0,z=0,short=true,print=true){
    translate([loc,0,z]){
        x = -33;
        for(i=[1,3]){
            rotate([0,0,i*90]){
                // Apparently there is slight misalignment that happens on the rotated pieces...
                yOffset = i == 3 ?-0.15 : 0;
            	translate([x,3 + yOffset,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
                translate([x,6 + yOffset,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
                translate([x,-1 + yOffset,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
                translate([x,-4 + yOffset,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
            }
       }
    }
}

/*
Lift pin used in center, with base mount
*/
module centerLiftPin(pinRadius, height, print=false){
    thickness = 1.85;

    hull() {
        translate([0,.75,height - 0.75]) {
            rotate([0,90,0]) color("green") cylinder(r=.85, h=thickness, $fn=40);
            if(print) translate([0.925,0,0]) 
                cube([2.5,6,6],center=true); // Poke through the cover plate for braille pins
        }
        cube([thickness,1.5,height - 0.75]);
    }
    translate([0,1.5,0]) rotate([105,0,0]) cube([thickness,1.5,20]);
    translate([0,-7,-2.7]) rotate([0,90,0])  cylinder(r=2, h=thickness, $fn=40);
    translate([0,-21,-24.5]) cube([thickness,4,21]);
    translate([0,-21,-27]){
		 cube([thickness,20,3]);
		 if(print){
    		translate([-.2,-.2,-1]) cube([2.3,20.4,4]);
		}
	}
}

/*
Lift pins with lift cam in outer position.
*/
module liftPinLong(pinRadius, print=false){
    rotate([90,0,0]){
        h = 1.85;

	translate([-15,0,0]) 
	{
		cube([43.5,2,h]);
		if(print){
			translate([-.2,-2,-.2]) cube([43.9,4,2.3]);
		}
		//joint
		translate([0,-2,0]) cube([5,2,h]);
		//down arm
		translate([4,-2,0]) rotate([0,0,340]) cube([15,2,h]);

		//lobe arm
		translate([18,-7,0]) {
		    cube([28,2,h]);
		    //lift lobe
		    translate([3,0,0]) cylinder(r=1, h=h, $fn=40);
		}
		//lift arm
		translate([46,-7,0]) {
            hull(){
                color("red")
                rotate([0,0,85]) cube([8,1.5,h]);
                //pin lobe
                translate([0,8,0]) color("green") cylinder(r=.85, h=h, $fn=40);
            }
		}
	}
    }
}
/*
Lift pins with lift cam in inner position
*/
module liftPin(pinRadius, print=false){
    rotate([90,0,0]){
        h = 1.85;

        cube([28.5,2,h]);
		if(print){
			translate([-.2,-2,-.2]) cube([28.9,4,2.3]);
		}
        translate([0,-2,0]) cube([5,2,h]);
        translate([4,-2,0]) rotate([0,0,340]) cube([15,2,h]);
        translate([18,-7,0]) {
            cube([13,2,h]);
            translate([3,0,0]) cylinder(r=1, h=h, $fn=40);
        }
        translate([31,-7,0]) {
            hull() {
                color("blue")
                rotate([0,0,85]) cube([8,1.5,h]);
                translate([0,8,0]) color("green") cylinder(r=.85, h=h, $fn=40);
            }
        }
    }
}

/*
A coupler for connecting the cam shaft to the bearing insert
*/
module bearingCoupler(){
	translate([0,0,5]) cylinder(d=5.1, h=2.5, $fn=40);
	translate([0,0,7.5]) cylinder(d1=5.0, d2=4.8, h=12.5, $fn=40);
 	difference(){
	  cylinder(d=12, h=5, $fn=40);
	  cube([8.5,4.5,7.5], center=true);	
  	}
}

/*
A coupler for connecting the rotary pot to the cam shaft
*/
module potCoupler(){
 	difference(){
	union(){
	  cylinder(d=12, h=5, $fn=40);
	  translate([0,0,4]) cylinder(d=8.5, h=11, $fn=40);
}
	  cube([8.5,4.5,7.5], center=true);	
		translate([0,0,5]) {
		  difference(){
			color("blue") cylinder(d=6.15, h=20, $fn=40);
		  	translate([0,3,2]) cube([8,1.5,4.5], center=true);	
		  }
		}
  	  }
}

module frontPlate(){
    color("green") cube([bearing_height,70,56]);
}

module backPlate(){
    color("green") cube([bearing_height+2,70,56]);
}

module basePlate(){
    color("orange") cube([40, 80, 2]);
}
