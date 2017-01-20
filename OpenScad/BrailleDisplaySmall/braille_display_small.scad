use <BezierScad.scad>

width=80;

bearing_radius = 8;//11.8;
bearing_height = 6;
pin_rad = .9;//.4


//liftPin(.4);
//doubleLiftPin(.4); 
//translate([0,0,2.2]) %centerPinBridge();

//translate([0,-12.5,9]) assembly(false);
//printDoubleLiftPin(6);
//printCenterLiftPin();



//import("braille_display_v2_shaft.stl");
//import("braille_display_v2_stepper-connector1.stl");
//import("doublepin.stl");
//import("singleliftpin.stl");

                
rotate([0,-90,0]){
//centerLiftPin2(.4,25);
difference(){
  // translate([-9,-21,-30]) frontPlate();
    //translate([15,-21,-30]) backPlate();
        translate([-9,-2.5,14]) {
difference(){
           /* centerPinBridge();
            translate([9,1.5,-4.5]){
                translate([0,0,0]) centerLiftPin(.4,23);
                translate([3,0,0]) centerLiftPin(.4,23);
                translate([7,0,0]) centerLiftPin(.4,23);
                translate([10,0,0]) centerLiftPin(.4,23);
            }*/
        }
        }
    //assembly(false);
}
}
//liftPinInsetGroup(1);
//plateBuild();
//assembly();
//printBearingTest();
module printBearingTest(){
    rotate([0,90,0]){
    difference(){
    color("green") cube([bearing_height,25,25],center=true);
    rotate([0,90,0]) translate([0,0,-10]) cylinder(r=8, h=20, $fn=40); 
    }
}
}

module printCenterLiftPin(){
    translate([0,0,1.6]){
		rotate([0,90,0]) translate([0,0,0]) centerLiftPin(.4,30);
       	rotate([0,90,0])  translate([0,3,0]) centerLiftPin(.4,30);
        rotate([0,90,0]) translate([0,6,0]) centerLiftPin(.4,30);
        rotate([0,90,0])  translate([0,9,0]) centerLiftPin(.4,30);
    }
}

module printDoubleLiftPin(n){
    
    for(i=[0:n-1]){
        x = i*20;
        if(i%2==0){
            translate([x,0,0]) doubleLiftPin(.4);
        }else{
            translate([x,-40,0]) doubleLiftPin(.4);
        }
    }
}

//rotate([0,0,0]) printSingleLiftPin(1);
module printSingleLiftPin(n){
    
    for(i=[0:n-1]){
        x = i*20;
        if(i%2==0){
            translate([x,0,0]) liftPin(.4);
        }else{
            translate([x,-15,0]) liftPin(.4);
        }
    }
}

module topPlate(){
    difference(){
        translate([-15,-25.5,17]) basePlate();
        //translate([-15,-25.5,-37]) basePlate();
        //translate([-9,-21,-37]) frontPlate();
        //translate([15,-21,-37]) backPlate();
        assembly(true);
    }
}

/*uncomment to print topplate or bearing set
*/
rotate([0,180,0]){
    rotate([0,90,0]){
        //rotate([0,-90,0]) translate([28,35,-19]) topPlate();
        //front bearing add 2 
        //bearingSet(2);
        //back bearing
        //bearingSet(0);
    }
}

module bearingSet(h){
    for(i=[0:5]){
        translate([0,i*20,0]) {
            difference(){
                bearing(h);
                cube([34,8.5,4.5], center=true);
            }
        }
    }
}

//potCoupler();
//translate([17,0,0]) bearingCoupler();

module bearingCoupler(){
	translate([0,0,5]) cylinder(d=5.1, h=2.5, $fn=40);
	translate([0,0,7.5]) cylinder(d1=5.0, d2=4.8, h=12.5, $fn=40);
 	difference(){
	  cylinder(d=12, h=5, $fn=40);
	  cube([8.5,4.5,7.5], center=true);	
  	}
}

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

translate([-10,10,2]) printLiftPins(8);
module printLiftPins(n){

	//rotate([0,90,0]) centerLiftPin(.4, 30, 0, false);
    //translate([x,3,0]) if(short) liftPin(pin_rad,print);

    for(i=[0:n-1]){
        x = i*8;
        if(i%2==0){
            translate([0,x,0]) rotate([90,0,0]) liftPinLong(pin_rad,false);
        }else{
            translate([50,x-8,0])  rotate([90,0,0]) liftPinLong(pin_rad,false);
        }
    }
}
//printCamaxel(6);
module printCamaxel(n){
    for(i=[0:n-1]){
        x = i*8;
        if(i%2==0){
            translate([0,x,0]) camaxel();
        }else{
            translate([58,x-8,0]) camaxel();
        }
    }
}

//assembly(true);
module assembly(pins){
	p = false;//print
    //cams
    %camset(true);
    %translate([0,-19,25]) camset(true);
    %translate([0,20,25]) camset(true);
    //
    // Center Pins
    centerPins(-11.9, 13.2, 180, p);
    centerPins(13.9,13.2, 0, p);

    // Edge Pins
    edgePins(6,41.5,true,p);
    edgePins(19.9,41.5,false,p);

   /* 
rotate([0,180,0]) difference(){
	rotate([0,0,0]) coverplate(true);
	//baseplate(true);
	translate([-18,0,0]) rotate([0,0,0]) frontplate(.8);
	translate([15,0,0]) rotate([0,0,0]) backplate(.8);
}
*/
	//rotate([0,0,0]) coverplate(true);
//	baseplate(true);
//	translate([-18,0,0]) rotate([0,0,0]) frontplate();
//	translate([15,0,0]) rotate([0,0,0]) backplate();

//translate([-20,0,0]) color("red") cube([20,20,20]);
}

module frontplate(pad = 0){
	difference(){
		translate([-5,0,14]) color("green") cube([5+pad,96+pad,58], center=true);
		camset(true);
    	translate([0,-19,25]) camset(true);
    	translate([0,20,25]) camset(true);
	}
}

module backplate(pad = 0){
	difference(){
		translate([32,0,14]) color("green") cube([5+pad,96+pad,58], center=true);
		camset(true);
    	translate([0,-19,25]) camset(true);
    	translate([0,20,25]) camset(true);
	}
}

module coverplate(p){
	difference(){
	  translate([12,0,42]) color("blue") cube([78,100,5], center=true);
	  centerPins(-11.9, 13.2, 180, p);
	  centerPins(13.9,13.2, 0, p);
	  edgePins(6,41.5,true,p);
	  edgePins(19.9,41.5,false,p);
	}
}
module baseplate(p){
	difference(){
	  translate([12,0,-13.5]) color("blue") cube([78,100,5], center=true);
	  centerPins(-11.9, 13.2, 180, p);
	  centerPins(13.9,13.2, 0, p);
	}
}

module camaxel(){
        color("blue") translate([0,0,0]) cube([49.5,8.5,4.5]);
}

module camset(stagger){
    if(stagger){
        translate([15,7.65,0]) {
			cam();
			translate([0,0,0]) rotate([0,90,0]) cylinder(r=8, h=50);
			translate([-50,0,0]) rotate([0,90,0]) cylinder(d=7.5, h=100);
			translate([-21,0,0]) cube([5,13,14], center=true);
		}
    }else{
        translate([0,0,0]) cam();
    }
    translate([0,-7.25,0]) {
		cam();
		translate([-50,0,0]) rotate([0,90,0]) cylinder(r=8, h=50);
		translate([0,0,0]) rotate([0,90,0]) cylinder(d=7.5, h=100);
		translate([33,0,0]) cube([5,13,14], center=true);
	}
}

module cam(){
	import("braille_display_allcams.stl");
}

module centerPins(loc=0,z=0, r=0, print=false){
	rotate([0,0,r]){
	  	translate([loc,-.75,z]){
		  translate([0,0,0]) centerLiftPin(.4, 30, 0, print);
		  translate([3,0,0]) centerLiftPin(.4, 30, 0, print);
		  translate([7,0,0]) centerLiftPin(.4, 30, 0, print);
		  translate([10,0,0]) centerLiftPin(.4, 30, 0, print);
  		}
    }
}

module edgePins(loc=0,z=0,short=true,print=true){
    translate([loc,0,z]){
        x = -33;
        for(i=[1:2:3]){
            rotate([0,0,i*90]){
            	translate([x,3,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
                translate([x,6,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
                translate([x,-1,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
                translate([x,-4,0]) if(short) liftPin(pin_rad,print); else liftPinLong(pin_rad,print);
            }
       }
    }
}

module centerLiftPin(pinRadius, height, gap=0, print=false){
    translate([0,.75,height]) {
		rotate([0,90,0]) color("green") cylinder(r=.85, h=2, $fn=40);
    	if(print) translate([1,0,-1]) cube([2,6,5],center=true);
	}
    cube([2 + gap,1.5 + gap,height]);
    translate([0,1.5,0]) rotate([105,0,0]) cube([2,1.5,20]);
    translate([0,-7,-2.7]) rotate([0,90,0])  cylinder(r=2, h=2, $fn=40);
    translate([0,-21,-24.5]) cube([2,4,21]);
    translate([0,-21,-27]){
		 cube([2,20,3]);
		 if(print){
    		translate([-.2,-.2,-1]) cube([2.3,20.4,4]);
		}
	}

    //translate([0,.75,0]) rotate([0,90,0]) cylinder(r=.75, h=2, $fn=40);
}

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
		translate([46,-7,.35]) {
hull(){
		    rotate([0,0,85]) cube([8,1.5,h-.5]);
		    //pin lobe
		    translate([0,8,.7]) rotate([0,0,0]) color("green") sphere(r=.85, $fn=40);//cylinder(r=.85, h=h-.4, $fn=40);
}
		}
	}
    }
}

module liftPin(pinRadius, print=false){
    rotate([90,0,0]){
        h = 1.9;

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
            rotate([0,0,85]) cube([8,1.5,h]);
            translate([0,8.5,0]) rotate([0,0,-5]) color("green") cylinder(r=.85, h=h, $fn=40);
        }
    }
}



//stl's must be commented out to use this assembly for unions(diffs)
module assembly2(pins){
    //translate([1,4.75,3.5]) rotate([-90,0,0]) liftPin(.4);
    import("braille_display_allcams.stl");
    translate([0,-15.5,0]) import("braille_display_allcams.stl");
    //color("blue") translate([-13,-4.5,-2.5]) cube([34,8.5,4.5]);
    //translate([-10,0,0]) bearing();
    //translate([15,0,0]) bearing();
    if(pins){
      rotate([90,0,90]){
       translate([-20,16.5,0]){
            liftPin(pin_rad);
            translate([0,0,3]) liftPin(pin_rad);
            translate([0,0,7]) liftPin(pin_rad);
            translate([0,0,10]) liftPin(pin_rad);
        }
    }
    }
    translate([0,27,0]){
        import("braille_display_allcams.stl");
        translate([0,15.5,0]) import("braille_display_allcams.stl");
        //color("blue") translate([-13,-4.5,-2.5]) cube([34,8.5,4.5]);
        //translate([-10,0,0]) bearing();
        //translate([15,0,0]) bearing();
       if(pins){
            rotate([90,0,270]){
            translate([-20,16.5,-12]){
                doubleLiftPin(pin_rad);
                translate([0,0,3]) doubleLiftPin(pin_rad);
                translate([0,0,7]) doubleLiftPin(pin_rad);
                translate([0,0,10]) doubleLiftPin(pin_rad);
            }
        }
       }
    }
    translate([0,16,-23]){
        translate([0,11.5,0]) import("braille_display_allcams.stl");
        translate([-15,-4,0]) import("braille_display_allcams.stl");
        //color("blue") translate([-13,-4.5,-2.5]) cube([34,8.5,4.5]);
        //translate([-10,0,0]) bearing(10);
        //translate([15,0,0]) bearing();
        /* not using centerbridge...*/
        translate([-9,-3.5,14]) {
            /*difference(){
                translate([0,1,0]) centerPinBridge();
                translate([9,2.5,-4.5]){
                    translate([-.5,-.5,0]) centerLiftPin(.4,30,1);
                    translate([2.5,-.5,0]) centerLiftPin(.4,30,1);
                    translate([6.5,-.5,0]) centerLiftPin(.4,30,1);
                    translate([9.5,-.5,0]) centerLiftPin(.4,30,1);
                }
            }*/
            /*translate([9,2.5,-4.5]){
                translate([0,0,0]) centerLiftPin(.4,30);
                translate([3,0,0]) centerLiftPin(.4,30);
                translate([7,0,0]) centerLiftPin(.4,30);
                translate([10,0,0]) centerLiftPin(.4,30);
            }*/
        }
    }
    //translate([-9,-21,-37]) frontPlate();
    //translate([15,-21,-37]) backPlate();
    //translate([-15,-25.5,-37]) basePlate();
    //translate([-15,-25.5,16]) basePlate();
}

module motorAdapter(){
    difference(){
       //translate([-9,-21,-30]) frontPlate();
        //translate([15,-21,-30]) backPlate();
        translate([-12,0,0]) bearing();
        color("blue") translate([-41,-4,-2]) cube([34,8,4]);
        rotate([0,90,0]) cylinder(13, 2.25, 2.5, true, $fn=40);
    }
}
module centerPinBridge(){
    color("orange") cube([30,4.5,9.8]);
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

module bearing(h){
    rotate([0,90,0]) cylinder(r=bearing_radius, h=bearing_height + h, $fn=40);      //added 2 to bearing height for print          
}

module mountingPlate(){
    difference(){
        plateBuild();
        liftPinInsetGroup(1);
        translate([0,7,0]) liftPinInsetGroup(1);
    }
}

module plateBuild(){
        translate([0,-6.5,0]) cube([71,20,4]);
        translate([34,-6.5,3]) cube([3,20,7]);
}

module liftPinInset(){
    difference(){
        cube([30.5,csz*2,csz]);
        //translate([37,-.2,-.5]) rotate([0,0,85]) cube([2.5,2,2.5]);
    }
    translate([32,-5.5,0]) {
        rotate([0,0,85]) cube([12,2.5,2.5]);
    }
}

module doubleLiftPin(pinRadius){
    liftPin(pinRadius);
    translate([-15,-25,0]) cube([4,25,2]);
    translate([0,-23,0]){
        translate([2,-1,0]) rotate([0,0,340]) cube([17,2,2]);
        translate([18,-7,0]) {
            cube([28,2,2]);
            translate([2,0,0]) cylinder(r=1, h=2, $fn=40);
            translate([22.5,0,0]) cylinder(r=1, h=2, $fn=40);
        }
        translate([32,-7,0]) {
            rotate([0,0,85]) cube([30,2,2]);
            translate([1.5,35,1]) rotate([90,0,-5]) cylinder(r=pinRadius, h=5, $fn=40);
        }
    }
}


module centerLiftPin2(pinRadius, height){
    translate([.75,.75,height]) cylinder(r=pinRadius, h=2, $fn=40);
    cube([1.5,1.5,height]);
    translate([0,-.75,0]) cube([4,3,2]);
    translate([0,.75,0]) rotate([0,90,0]) cylinder(r=1.5, h=1.5, $fn=40);
}

module centerLifPinInset(){
    
}

module noarc(h){
    cube([13,2,h]);
    translate([3,0,0]) cylinder(r=1, h=h, $fn=40);
}

module arc(){
    difference(){
        cylinder(r=8, h=2, $fn=40);
        translate([0,-2.2,-.5]) cylinder(r=8.3, h=3, $fn=40);
        translate([-9,-8,-.5]) cube([17,12,3]);
    }
    translate([0,6,0]) cylinder(r=1, h=2, $fn=40);
}

module curvePin(){
    //cube([20,20,0]);
    cube([2,18,2]);
    difference(){
    translate([0,22,0]) cylinder(r=5, h=2, $fn=40);
    translate([-4,22,-.1]) cylinder(r=4, h=2.2, $fn=40);
    translate([-10,0,0]) cube([10,28,2]);
    }
}





module liftPinPlate(){
    startX = 4;
    startY = 3;
    pinHeight = 2;

    difference(){
        cube([17,14.5,1]);
        for(i=[0:2]){
            for(j=[0:0]){
                translate([startX+i*2.5,startY,0]) dividerGrid();
            }
        }
    }
    translate([startX,startY,0]) {
        singleCell(0.8, pinHeight);
    }
    translate([startX,startY+6,0]) singleCell(0.8, pinHeight);
}

module singleCell(pinRadius, pinHeight){
    for (i=[0 : 2]) {
        for(j=[0:1]){
            translate([2.5*i,2.5*j,0]) color("green") cylinder(r=pinRadius, h=pinHeight, $fn=40);
        }
    }
}

module dividerGrid(){
    translate([-1.0,-2.5,-1.25]) cube([.2,3.5,5]);
    translate([0.8,-2.5,-1.25]) cube([.2,3.5,5]);
    translate([-1.0,.8,-1.25]) cube([2.0,.2,5]);
    //right side
    translate([-1.0,1.5,-1.25]) cube([.2,3.5,5]);
    translate([0.8,1.5,-1.25]) cube([.2,3.5,5]);
    translate([-1.0,1.5,-1.25]) cube([2.0,.2,5]);
}

//MISC STUFF

module flexarm(){
    cube([12,3,2]);
    translate([1,0,0]) cube([0.3,9,2]);
    translate([6,0,0]) cube([0.3,9,2]);
    translate([11,0,0]) cube([0.3,9,2]);
    translate([0,6,0]) cube([12,3,2]);
}

module swingarm(){
    translate([0,-1,0]) {
        cube([5,1,2.5]);
        translate([4,0,0]) {
            rotate([0,0,-15]) cube([12,1,2.5]);
            translate([12,-3.3,0]){
                rotate([0,0,70]) {
                    cube([5,1,2.5]);
                    translate([5,0,0]) rotate([0,0,20]) cube([5,1,2.5]);
                }
            }
        }
    }
}
