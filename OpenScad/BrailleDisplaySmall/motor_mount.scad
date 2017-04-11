// Values measured from an actual motor
MOTOR_BASE_LENGTH = 41;
MOTOR_BASE_WIDTH  = 20;
MOTOR_BASE_HEIGHT = 39.3;
MOTOR_PLUG_HEIGHT = 4;
MOTOR_SHAFT_OFFSET = 10;

MOUNT_BRACKET_HEIGHT = 29;
MOUNT_BRACKET_THICKNESS = 2;
MOUNT_BRACKET_LENGTH = 7;
MOUNT_SCREW_DIAMETER = 5.08; // 0.2"
MOUNT_SCREW_HOLE_CENTER_TO_CENTER_DISTANCE = 10;
MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_X = 5;

MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_Y = (MOTOR_BASE_WIDTH - MOUNT_SCREW_HOLE_CENTER_TO_CENTER_DISTANCE) / 2;
// ===================================

preview();
//motor_mount();

module preview() {
    display_model();

    translate([-57, 33.7, 51])
        rotate([-90, 0, -90])
            motor_model();

    translate([-57, 52.7, 26])
        rotate([-90, 0, -90])
            motor_model();

    translate([-57, 52.7, 51])
        mirror([0, 1, 0])
            rotate([-90, 0, -90])
                motor_model();

    color("gold")
    translate([-26, -14.3, 51])
        rotate([0, 90, 0])
            motor_mount();
}


module motor_mount() {
    SLIM = false;

    difference() {
        if (SLIM) {
            union() {
                translate([0, -2.5, 0])
                    cube([23, 120, 3]);
                translate([23, 16.5, 0])
                    cube([28, 60, 3]);
            }
        } else {
            translate([0, -2.5, 0])
                cube([51, 120, 3]);
        }

        translate([51, 14.3, 25.7]) {
            rotate([0, -90, 0]) {
                union() {
                    translate([-57, 33.7, 51])
                        rotate([-90, 0, -90])
                            motor_model(negative=true);

                    translate([-57, 52.7, 26])
                        rotate([-90, 0, -90])
                            motor_model(negative=true);

                    translate([-57, 52.7, 51])
                        mirror([0, 1, 0])
                            rotate([-90, 0, -90])
                                motor_model(negative=true);
                }
            }
        }
    }
}

module display_model() {
    translate([29, 50, 16])
        import("braille_display_model.stl", convexity=5);
}

module motor_model(negative=false) {
    module bracket() {
        difference() {
            cube([MOUNT_BRACKET_LENGTH, MOTOR_BASE_WIDTH, MOUNT_BRACKET_THICKNESS]);
            translate([MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_X, MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_Y, 0])
                cylinder(h=MOUNT_BRACKET_THICKNESS, d=MOUNT_SCREW_DIAMETER, $fn=40);
            translate([MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_X,
                       MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_Y + MOUNT_SCREW_HOLE_CENTER_TO_CENTER_DISTANCE,
                       0])
                cylinder(h=MOUNT_BRACKET_THICKNESS, d=MOUNT_SCREW_DIAMETER, $fn=40);
        }

        if (negative) {
            translate([MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_X,
                       MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_Y + MOUNT_SCREW_HOLE_CENTER_TO_CENTER_DISTANCE,
                       0])
                cylinder(h=10, d=MOUNT_SCREW_DIAMETER, $fn=40);
            translate([MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_X, MOUNT_SCREW_HOLE_OFFSET_FROM_BASE_Y, 0])
                cylinder(h=10, d=MOUNT_SCREW_DIAMETER, $fn=40);
        }
    }

    color("cyan")
    if (!negative) {
        cube([MOTOR_BASE_LENGTH, MOTOR_BASE_WIDTH, MOTOR_BASE_HEIGHT]);
    } else {
        negative_offset = 0.3;
        translate([-negative_offset/2, -negative_offset/2, 0])
            cube([MOTOR_BASE_LENGTH + negative_offset, MOTOR_BASE_WIDTH + negative_offset, MOTOR_BASE_HEIGHT]);
    }

    color("red")
    translate([MOTOR_SHAFT_OFFSET, MOTOR_BASE_WIDTH / 2, MOTOR_BASE_HEIGHT]) {
        cylinder(h=5, d=6, $fn=40);
    }

    translate([-4, -7/2 + MOTOR_BASE_WIDTH / 2, MOTOR_PLUG_HEIGHT]) {
        cube([4, 7, 4]);
    }

    translate([MOTOR_BASE_LENGTH, 0, MOUNT_BRACKET_HEIGHT]) {
        bracket();
    }

    mirror([1, 0, 0]) {
        translate([0, 0, MOUNT_BRACKET_HEIGHT]) {
            bracket();
        }
    }
}
