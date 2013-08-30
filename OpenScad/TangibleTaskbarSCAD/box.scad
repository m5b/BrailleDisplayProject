
outer = 18.4;
inner = 16;
tray = 3;

module box(){
rotate([90,0,0]){
	difference(){
		cube([outer,outer,outer]);
		translate([1.1,1.1,.5]) cube([inner,inner+4,tray]);
	}
}
}

box();
