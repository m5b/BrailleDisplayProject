
shaft_radius = 2.5;
shaft_gap = 21;
shaft_start_pos = 17;
shaft_height = 60;
cam_start_pos = 15;
cam_radius = 10;
shaft_offset = 5;
braille_hole_height = 11;
braille_pin_height = 10;

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

//print_frame();
//assembled_view();
//print_top();
//print_pin_case(6);
//print_pin_stack();
camshaftTop(3, 31, true);
//translate([0,0,35]) 
//camshaftMid(3, 31, true);//standard is 21
//translate([0,0,70]) 
//camshaftBottom(3, 31, true);
/*
    PRINT

*/
module print(){

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

module shaft(amount, useSpacer){
    rotate([0,90,0]) {
        if(useSpacer){
            union(){
                translate([0,0,cam_start_pos]) cylinder(r=shaft_radius*2,h=5, $fn=40);
                translate([0,0,0]) cylinder(r=shaft_radius,h=shaft_height+amount, $fn=40);
            }
        }else{
            translate([0,0,0]) cylinder(r=shaft_radius,h=shaft_height+amount, $fn=40);
        }
    }
}

module camlobe(arr){
    for (i=[0 : 15]) {
        for(r = [ arr[i] ]){
            if(r==1){
                //hull(){
                    rotate([0,90,0]) cylinder(r=cam_radius+3, h=4, $fn=40);
                    rotate([22.5*i,0,0]){ 
                        translate([0,0,cam_radius+2]) rotate([0,90,0]) {
                            cylinder(r=3,h=4, $fn=40);
                        }
                    }
                //}
            }
        }
    }
}

module cam(arr){
    for (i=[0 : 15]) {
        for(r = [ arr[i] ]){
            if(r==1){
                rotate([22.5*i,0,0]){ 
                    translate([0,0,shaft_radius+1]) sphere(r=1.4, $fn=40);//cylinder(r=1,h=3, $fn=40);
                }
            }
        }
    }

}

/*

Creates a camshaft using the top braille row optimized array.

offset - indicates the x position along the shaft that the cams should start
useSpacer - will add a spacer at beginning of shaft according to the global value stored 
    in cam_start_pos.  This keeps the cams aligned properly when placed in frame  
*/

module camshaftTop(numOfGears, offset, useSpacer){
    length = numOfGears * 32;
    color("green") shaft(length, useSpacer);
    for(i=[offset : 32 : length]){
        color("orange") translate([i,0,0])   camlobe(shaft0Row1);
        color("orange") translate([i+4,0,0]) camlobe(shaft0Row2);
        color("orange") translate([i+8,0,0]) camlobe(shaft0Row3);
        color("orange") translate([i+12,0,0]) camlobe(shaft0Row4);
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


