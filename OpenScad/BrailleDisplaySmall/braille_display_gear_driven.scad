
shaft_radius = 4.5;//2.5;
shaft_gap = 21;
shaft_start_pos = 17;
shaft_height = 1;//60;
cam_start_pos = 0;
cam_radius = 8;//11.8;
shaft_offset = 5;
braille_hole_height = 11;
braille_pin_height = 10;
lobe_deg = 18;//21.6;//22.5;
lobe_height = 3;
lobe_radius = 1.5;

//shaft 0
shaft0Row1 = [0,0,1,1,0,1,1,1,1,1,0,1,0,0,0,0];
shaft0Row2 = [0,1,1,1,1,0,0,0,0,1,1,1,0,0,1,0];
shaft0Row3 = [0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1];
shaft0Row4 = [0,0,0,1,1,0,1,1,0,0,0,1,0,1,1,1];

//shaft 1
shaft1Row1 = [1,1,0,1,0,0,0,0,1,1,1,0,1,1,0,0];
shaft1Row2 = [1,0,1,1,0,1,0,0,0,0,0,0,1,1,1,1];
shaft1Row3 = [1,1,1,0,1,0,1,0,0,1,0,0,1,0,0,1];
shaft1Row4 = [1,1,0,0,1,0,0,0,0,0,1,1,0,1,1,1];

//shaft 2
shaft2Row1 = [1,0,0,1,0,0,1,0,1,0,1,0,0,1,1,1];
shaft2Row2 = [1,0,1,1,1,1,0,1,1,0,0,0,0,0,1,0];
shaft2Row3 = [1,0,1,0,0,1,0,0,1,1,1,1,0,0,0,1];
shaft2Row4 = [1,1,1,1,1,0,1,0,0,1,0,0,0,0,0,1];

rowG = [0,0,1,0,1,1,0,1,0,0,1,0,1,1,0,0,0,1,1,1,0,0,1,1,0,1,0,1,0,0,1,0];

//assembledSmallCam();
printCamSheet();
//printShaft();

//translate([0,0,35]) 
//rotate([(22.5*12),0,0]) camshaftMid(3, 31, true);//standard is 21
//translate([0,0,70])
//rotate([22.5*0,0,0]) camshaftBottom(3, 31, true);
/*
    PRINT
*/

//simulation(16,2,10);
/*
Displays the cams as they would be configured in the actual braille device.  This allows
quick testing and validation of the controller code.  The positions that are passed in
should match the values sent from the arduino code to update the motors.
*/
module simulation(top, mid, bot){

    
    difference(){
        rotate([lobe_deg* (top + .6666),0,0]) camshaftTop(1, 31, true);
        render(convexity=2) {
            color("green") shaft(31, false);
        }
    }
    translate([0,-35,0]) {
        //difference(){
            rotate([lobe_deg* (mid + .6666), 0, 0]) rotate([lobe_deg*9,0,0]) camshaftMid(1, 31, true);//standard is 21
            render(convexity=2) {
                color("green") shaft(31, false);
            }
        //}
    }

    translate([0,-70,0]){
        difference(){
            rotate([lobe_deg* (bot + .6666), 0, 0]) rotate([lobe_deg*4,0,0]) camshaftBottom(1, 31, true);
            render(convexity=2) {
                color("green") shaft(31, false);
            }
        }
    }
}


//added .5 to axle diameter to account for print smash - msb 4/18/16
module printCamSheet(){
    rotate([0,-90,0]){
        difference(){
            camBotPinA();
            translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
        }
        translate([0,22,0]){
            difference(){
                camBotPinB();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,44,0]){
            difference(){
                camBotPinC();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,66,0]){
            difference(){
                camBotPinD();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        
        translate([0,0,-22]){
            difference(){
                camMidPinA();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,22,-22]){
            difference(){
                camMidPinB();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,44,-22]){
            difference(){
                camMidPinC();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,66,-22]){
            difference(){
                camMidPinD();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        
        translate([0,0,-44]){
            difference(){
                camTopPinA();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,22,-44]){
            difference(){
                camTopPinB();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,44,-44]){
            difference(){
                camTopPinC();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
        translate([0,66,-44]){
            difference(){
                camTopPinD();
                translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
            }
        }
    }
}

module printCam(){
    rotate([0,-90,0]){
        difference(){
         //camshaftTop(1, 4, false, shaft0Row3);
            camBotPinD();
            translate([-5,-4,-2]) cube([20,8,4]);
        }
        //color("red") translate([-.3,-12,-12]) cube([.3,24,24]);
    }
}


module printShaft(){

    cube([20,8,3.7]);
    color("red") translate([-5,-8,-.3]) cube([30,24,.3]);
}

module print_top(){
    translate([0,0,0]){
        difference(){
            translate([0.5,0,0]) top();
            union(){
                print_pin_stack();
                translate([5,-23,35]) cube([17,46,15]);
                translate([5,-36,43]) cube([17,12,25]);
                translate([5,24,43]) cube([17,13,25]);
            }
        }
    }
}

module print_frame(){
    rotate([0,0,0]){
        difference(){
            frame();
            //alternate_cam_align();
        }
        translate([2.5,0,0]) frame();
    }
}

module print_pin_stack(){
    rotate([0,90,90]){
        color("Red") pin_view();
    }
}

module print_pin_case(size){
    rotate([0,180,0]){
        difference(){
            translate([-1,-35,0]) cube([16*size+1,70,pinArmHeight+2]);
            for(i=[0 : size-1]){    
                translate([16*i,0,0]) pin_stack_extrusion();
            }
        }
    }
}

/*
    VIEWS
*/

module assembledSmallCam(){
    rotate([0,-90,0]){
        difference(){
         //camshaftTop(1, 4, false, shaft0Row3);
            //camTopPinC();
            //translate([-5,-4,-2]) cube([20,8,4]);
        }
    }

    color("green") translate([-5,-4.5,-2.5]) cube([20,8.5,4.5]);
    camTopPinA();
    translate([lobe_height,0,0]) camTopPinB();
    translate([lobe_height*2,0,0]) camTopPinC();
    translate([lobe_height*3,0,0]) camTopPinD();
}

module assembled_view(){
    difference(){
        %translate([-1,-35,20]) cube([17,70,pinArmHeight+2]);    
        //%pin_stack_extrusion();
    }
    translate([0,0,15.5]) pin_view();

    translate([-cam_start_pos,-31,0]) camshaft();
    translate([-cam_start_pos,0,0]) camshaft();
    translate([-cam_start_pos,31,0]) camshaft();

}

module pin_view(){
    translate([0,0,0]) pin_character();
    translate([(pinCylinderThickness+1)*2,0,0]) pin_character();
    //%pin_stack_extrusion();
    //%translate([(pinCylinderThickness+1)*2,0,0]) pin_stack_extrusion();
}

module pin_character(){
    armpos = (pinCylinderRadius*2) + 1;
    //add top two pins
    translate([0,armpos,0]) cam_pin_arm(pinCylinderThickness-0.8,-1.8);
    translate([pinCylinderThickness+1,armpos,0]) cam_pin_arm(0.8,-1.8);
    //middle pins
    translate([0,0,0]) vertical_cam_pin(true,true,pinCylinderThickness-0.8, 0);
    translate([pinCylinderThickness+1,0,0]) vertical_cam_pin(true,true,0.8,0);
    //bottom pins
    mirror([0,180,0]){
        translate([0,armpos,0]) cam_pin_arm(pinCylinderThickness-0.8,-1.8);
        translate([pinCylinderThickness+1,armpos,0]) cam_pin_arm(0.8,-1.8);
    }
}

module pin_stack_extrusion(){
    pin_character_extrusion();
    translate([(pinCylinderThickness+1)*2,0,0]) pin_character_extrusion();
}

module pin_character_extrusion(){
    armpos = (pinCylinderRadius*2) + 1;
    //add top two pins
    translate([0,armpos,0]) cam_pin_arm_extrusion(pinCylinderThickness-0.8,-1.8);
    translate([pinCylinderThickness+1,armpos,0]) cam_pin_arm_extrusion(0.8, -1.8);
    //middle pins
    translate([0,0,0]) vertical_cam_pin_extrusion(pinCylinderThickness-0.8,0);
    translate([pinCylinderThickness+1,0,0]) vertical_cam_pin_extrusion(0.8,0);
    //bottom pins
    mirror([0,180,0]){
        translate([0,armpos,0]) cam_pin_arm_extrusion(pinCylinderThickness-0.8, -1.8);
        translate([pinCylinderThickness+1,armpos,0]) cam_pin_arm_extrusion(0.8, -1.8);
    }
}
/*
    PINS
*/

pinCylinderRadius = 2.25;//old size = 2.5
pinCylinderThickness = 2.75;//old size = 3
pinArmHeight = 25;
extrusion = 2;

module vertical_cam_pin(usepin, uselobe, pinoffsetX, pinoffsetY){
    translate([0,0,0]){
        union(){
            //this cylinder is the top pin
            if(usepin){
                translate([pinoffsetX,pinoffsetY,pinArmHeight]) cylinder(r=.75, h=8, $fn=40);
            }
            //the rest is the arm
            if(uselobe){
                translate([0,0,0]) rotate([0,90,0]) cylinder(r=pinCylinderRadius,h=pinCylinderThickness, $fn=40);
            }
            translate([0,-pinCylinderRadius,0]) cube([pinCylinderThickness,(pinCylinderRadius*2),pinArmHeight]);
        }
    }
}

module cam_pin_arm(pinoffsetX, pinoffsetY){
    translate([0,0,0]){
        union(){
            vertical_cam_pin(true, false, pinoffsetX, pinoffsetY);
            translate([0,25,0]) vertical_cam_pin(false,true);
 
            //everage arm connectors
            translate([0,0,pinArmHeight]) rotate([-90,0,0]) cube([pinCylinderThickness,8,25]);
            //translate([0,0,pinArmHeight]) rotate([-90,0,0]) cube([pinCylinderThickness,5,25]);

        }
    }
}

module vertical_cam_pin_extrusion(pinoffsetX, pinoffsetY){
    translate([0,0,0]){
        union(){
            //this cylinder is the top pin
            translate([pinoffsetX,pinoffsetY,pinArmHeight]) cylinder(r=1, h=8, $fn=40);
            
            translate([-.25,-pinCylinderRadius-0.25,0]) cube([pinCylinderThickness+0.5,pinCylinderRadius*2+0.5,pinArmHeight]);
        }
    }
}

module cam_pin_arm_extrusion(pinoffsetX, pinoffsetY){
    translate([0,0,0]){
        union(){
            vertical_cam_pin_extrusion(pinoffsetX,pinoffsetY);
            //everage arm connectors
            translate([-0.25,0,0]) cube([pinCylinderThickness+0.5, 22 + (pinCylinderRadius*2) +1,pinArmHeight]);
        }
    }
}

/*
    FRAME AND CONTAINER

*/

module frame(){
    translate([1,-37,-20]) color("Red") cube([2,100,90]);
}

module top(){
    translate([4,-37,45]) cube([20,75,25]);
}

module top_extrusion(){
    %cube([17,46,20]);
}


/*
    CAMSHAFT

*/

module shaft(amount, useSpacer, useShim){
    rotate([0,90,0]) {
        if(useSpacer){
            union(){
                translate([0,0,cam_start_pos]) cylinder(r=shaft_radius*2,h=5, $fn=40);
                translate([0,0,0]) cylinder(r=shaft_radius,h=shaft_height+amount, $fn=40);
            }
        }else{
            difference(){
                translate([0,0,0]) cylinder(r=shaft_radius,h=shaft_height+amount, $fn=40);
                translate([0,0,15]) cylinder(r=2.5,h=20, $fn=40);
            }
        }
    }
}
module hullifyLobe(arr, idx){
gi = 15;
    for (i=[idx : gi]) {
        for(r = [ arr[i] ]){
            if(r==1){
                rotate([lobe_deg*i,0,0]){ 
                    translate([0,0,cam_radius+.3]) rotate([0,90,0]) {
                        cylinder(r=lobe_radius,h=lobe_height, $fn=40);
                    }
                }
            }else{
                //assign (gi = 0);
                echo(gi);
            }
        }
    }
}

module camlobe(arr){
    hull(){
        hullifyLobe(arr, 0);
    }
    rotate([0,90,0]) %cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}

module camlobeInverse(arr){
    for (i=[0 : 15]) {
        for(r = [ arr[i] ]){
            if(r==0){
                rotate([lobe_deg*i,0,0]){ 
                    translate([0,0,cam_radius+lobe_radius+2.5]) rotate([0,90,0]) {
                        cylinder(r=lobe_radius+2,h=lobe_height, $fn=40);
                    }
                }
            }
        }
    }
}
/* not used and I don't know why!
module cam(arr){
    for (i=[0 : 15]) {
        for(r = [ arr[i] ]){
            if(r==1){
                rotate([lobe_deg*i,0,0]){ 
                    translate([0,0,shaft_radius+1]) sphere(r=1.4, $fn=40);//cylinder(r=1,h=3, $fn=40);
                }
            }
        }
    }

}
*/

/*

Creates a camshaft using the top braille row optimized array.

offset - indicates the x position along the shaft that the cams should start
useSpacer - will add a spacer at beginning of shaft according to the global value stored 
    in cam_start_pos.  This keeps the cams aligned properly when placed in frame  
*/

module camshaftTop(numOfGears, offset, useSpacer, arr){
    spread = 32;
    length = numOfGears * spread;// * 32;
    //color("green") shaft(length, useSpacer);
    for(i=[offset : spread : length]){
        difference(){
        //hull(){
            color("orange") translate([i,0,0])   camlobe(arr);
        //}
            //color("orange") translate([i,0,0])   camlobeInverse(arr);
        }
        //color("orange") translate([i+lobe_height,0,0]) camlobe(shaft0Row1);
        //color("orange") translate([i+(lobe_height*2),0,0]) camlobe(shaft0Row3);
        //color("orange") translate([i+(lobe_height*3),0,0]) camlobe(shaft0Row4);
    }
}

module camshaftMid(numOfGears, offset, useSpacer){
    length = numOfGears * 32;
    color("green") shaft(length, useSpacer);
    for(i=[offset : 32 : length]){
        color("orange") translate([i,0,0])   camlobe(shaft1Row1);
        color("orange") translate([i+4,0,0]) camlobe(shaft1Row2);
        color("orange") translate([i+8,0,0]) camlobe(shaft1Row3);
        color("orange") translate([i+12,0,0]) camlobe(shaft1Row4);
    }
}

module camshaftBottom(numOfGears, offset, useSpacer){
    length = numOfGears * 32;
    color("green") shaft(length, useSpacer);//-48);
    for(i=[offset : 32 : length]){
        color("orange") translate([i,0,0])   camlobe(shaft2Row1);
        color("orange") translate([i+4,0,0]) camlobe(shaft2Row2);
        color("orange") translate([i+8,0,0]) camlobe(shaft2Row3);
        color("orange") translate([i+12,0,0]) camlobe(shaft2Row4);
    }
}

/*
Limitations of low-end printers and openscad language have led me to 
create a lobe by lobe version for each cam row.  I want the lobes to be
smoothed to limit the constraints of diy printers and also smooth out the
movement between positions.
*/
module cam(deg){
    rotate([lobe_deg*deg,0,0]){ 
        translate([0,0,cam_radius+.3]) rotate([0,90,0]) {
            cylinder(r=lobe_radius,h=lobe_height, $fn=40);
        }
    }
}
//shaft0Row1 = [0,0,1,1,0,1,1,1,1,1,0,1,0,0,0,0];
module camTopPinA(){
    hull(){
        cam(2);
        cam(3);
    }
    hull(){
        cam(5);
        cam(6);
        cam(7);
        cam(8)
        cam(9);
    }
    cam(11);
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}

//shaft0Row2 = [0,1,1,1,1,0,0,0,0,1,1,1,0,0,1,0];
module camTopPinB(){
    hull(){
        cam(1);
        cam(2);
        cam(3);
        cam(4);
    }
    hull(){
        cam(9);
        cam(10);
        cam(11);
    }
    cam(14);
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}

//shaft0Row3 = [0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1];
module camTopPinC(){
    cam(4); 
    hull(){
       cam(7);
       cam(8);
       cam(9);
       cam(10);
       cam(11);
       cam(12); 
    }
    cam(15);
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
} 

//shaft0Row4 = [0,0,0,1,1,0,1,1,0,0,0,1,0,1,1,1];
module camTopPinD(){
    hull(){
        cam(3);
        cam(4);
    }
    hull(){
        cam(6);
        cam(7);
    }
    cam(11);
    hull(){
        cam(13);
        cam(14);
        cam(15);
    }
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}

//shaft1Row1 = [1,1,0,1,0,0,0,0,1,1,1,0,1,1,0,0];
module camMidPinA(){
    hull(){
        cam(0);
        cam(1);
    }
    cam(3);
    hull(){
        cam(8);
        cam(9);
        cam(10);
    }
    hull(){
        cam(12);
        cam(13);
    }
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}
//shaft1Row2 = [1,0,1,1,0,1,0,0,0,0,0,0,1,1,1,1];
module camMidPinB(){
    cam(0);
    hull(){
        cam(2);
        cam(3);
    }
    cam(5);
    hull(){
        cam(12);
        cam(13);
        cam(14);
        cam(15);
    }
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}
//shaft1Row3 = [1,1,1,0,1,0,1,0,0,1,0,0,1,0,0,1];
module camMidPinC(){
    hull(){
        cam(0);
        cam(1);
        cam(2);
    }
    cam(4);
    cam(6);
    cam(9);
    cam(12);
    cam(15);
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}
//shaft1Row4 = [1,1,0,0,1,0,0,0,0,0,1,1,0,1,1,1];
module camMidPinD(){
    hull(){
        cam(0);
        cam(1);
    }
    cam(4);
    hull(){
        cam(10);
        cam(11);
    }
    hull(){
        cam(13);
        cam(14);
        cam(15);
    }
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}

//shaft2Row1 = [1,0,0,1,0,0,1,0,1,0,1,0,0,1,1,1];
module camBotPinA(){
    cam(0);
    cam(3);
    cam(6);
    cam(8);
    cam(10);
    hull(){
        cam(13);
        cam(14);
        cam(15);
    }
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}
//shaft2Row2 = [1,0,1,1,1,1,0,1,1,0,0,0,0,0,1,0];
module camBotPinB(){
    cam(0);
    hull(){
        cam(2);
        cam(3);
        cam(4);
        cam(5);
    }
    hull(){
        cam(7);
        cam(8);
    }
    cam(14);
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}
//shaft2Row3 = [1,0,1,0,0,1,0,0,1,1,1,1,0,0,0,1];
module camBotPinC(){
    cam(0);
    cam(2);
    cam(5);
    hull(){
        cam(8);
        cam(9);
        cam(10);
        cam(11);
    }
    cam(15);
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}
//shaft2Row4 = [1,1,1,1,1,0,1,0,0,1,0,0,0,0,0,1];
module camBotPinD(){
    hull(){
        cam(0);
        cam(1);
        cam(2);
        cam(3);
        cam(4);
    }
    cam(6);
    cam(9);
    cam(15);
    rotate([0,90,0]) cylinder(r=cam_radius+.6, h=lobe_height, $fn=40);                
}
