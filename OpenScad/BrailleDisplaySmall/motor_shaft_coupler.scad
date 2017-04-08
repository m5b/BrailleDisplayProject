SHAFT_OUTER_DIAMETER_TOP = 9;
SHAFT_OUTER_DIAMETER_BOTTOM = 7;
SHAFT_INNER_DIAMETER_TOP = 6;
SHAFT_INNER_DIAMETER_BOTTOM = 4;
SHAFT_SCREW_BOLT_DIAMETER = 3;
SHAFT_MOUNT_OUTER_DIAMETER = 10;
SHAFT_MOUNT_INNER_DIAMETER = 8;
SHAFT_LENGTH = 8;
SHAFT_BASE_LENGTH = 12;
SHAFT_BASE_THICKNESS = 4;
SHAFT_BASE_DIAMETER = 21;
BASE_SCREW_DIAMETER = 1.5;
CENTER_TO_BASE_SCREW_DISTANCE = 7.25;

print_tray();
//preview();

/*
Arrange the items on a tray for printing
*/
module print_tray() {
    motor_shaft_mount();
    translate([20, 0, 0]) {
        coupler_receptor();
    }
}

/*
Preview the coupling action in exploded view
*/
module preview() {
    motor_shaft_mount();
    translate([0, 0, SHAFT_BASE_LENGTH + SHAFT_BASE_THICKNESS]) {
        coupler_receptor();
    }
    translate([0, 0, SHAFT_BASE_LENGTH + SHAFT_LENGTH + SHAFT_BASE_THICKNESS + 20]) {
        rotate([0, 180, 0]) {
            bearingCoupler();
        }
    }
}

/*
Coupler between shaft mount and the bearing handle
*/
module coupler_receptor() {
    difference() {
        cylinder(h=SHAFT_LENGTH, d1=SHAFT_OUTER_DIAMETER_BOTTOM, d2=SHAFT_OUTER_DIAMETER_TOP, $fn=40);
        cylinder(h=SHAFT_LENGTH, d1=SHAFT_INNER_DIAMETER_BOTTOM, d2=SHAFT_INNER_DIAMETER_TOP, $fn=40);
    }
}

module motor_shaft_mount() {
    difference() {
        union() {
            cylinder(h=SHAFT_BASE_LENGTH+SHAFT_BASE_THICKNESS, d=SHAFT_MOUNT_OUTER_DIAMETER, $fn=40);
            cylinder(h=SHAFT_BASE_THICKNESS, d=SHAFT_BASE_DIAMETER, $fn=40);
        }
        translate([0, 0, SHAFT_BASE_THICKNESS]) {
            cylinder(h=SHAFT_BASE_LENGTH, d=SHAFT_MOUNT_INNER_DIAMETER, $fn=40);
        }

        // Primary mount point onto motor shaft
        cylinder(h=SHAFT_BASE_THICKNESS, d=SHAFT_SCREW_BOLT_DIAMETER, $fn=40);

        // Secondary mount points on motor attachment
        for (degree = [0 : 90 : 270]) {
            rotate([0, 0, degree]) {
                translate([CENTER_TO_BASE_SCREW_DISTANCE, 0, 0]) {
                    cylinder(h=SHAFT_BASE_THICKNESS, d=BASE_SCREW_DIAMETER, $fn=40);
                }
            }
        }
    }
}

/*
A coupler for connecting the cam shaft to the bearing insert.
Yanked from braille_display_small.scad
*/
module bearingCoupler(){
    translate([0,0,5]) cylinder(d=5.1, h=2.5, $fn=40);
    translate([0,0,7.5]) cylinder(d1=5.0, d2=4.8, h=12.5, $fn=40);
    difference(){
        cylinder(d=12, h=5, $fn=40);
        cube([8.5,4.5,7.5], center=true);
    }
}
