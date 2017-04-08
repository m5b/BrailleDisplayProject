SHAFT_OUTER_DIAMETER_TOP = 7.0;
SHAFT_OUTER_DIAMETER_BOTTOM = 6.4;
SHAFT_INNER_DIAMETER_TOP = 5.6;
SHAFT_INNER_DIAMETER_BOTTOM = 4.8;
SHAFT_SCREW_BOLT_DIAMETER = 3;
SHAFT_MOUNT_OUTER_DIAMETER = 10;
SHAFT_MOUNT_INNER_DIAMETER = 7;
SHAFT_LENGTH = 12;
SHAFT_BASE_WIDTH = 3;

print_tray();
//preview();

/*
Arrange the items on a tray for printing
*/
module print_tray() {
    motor_shaft_mount();
    translate([15, 0, 0]) {
        coupler_receptor();
    }
}

/*
Preview the coupling action in exploded view
*/
module preview() {
    motor_shaft_mount();
    translate([0, 0, SHAFT_LENGTH + SHAFT_BASE_WIDTH]) {
        coupler_receptor();
    }
    translate([0, 0, SHAFT_LENGTH + 35]) {
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
        cylinder(h=SHAFT_LENGTH+SHAFT_BASE_WIDTH, d=SHAFT_MOUNT_OUTER_DIAMETER, $fn=40);
        translate([0, 0, SHAFT_BASE_WIDTH]) {
            cylinder(h=SHAFT_LENGTH, d=SHAFT_MOUNT_INNER_DIAMETER, $fn=40);
        }
        cylinder(h=SHAFT_BASE_WIDTH, d=SHAFT_SCREW_BOLT_DIAMETER, $fn=40);
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
