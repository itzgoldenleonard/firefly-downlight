use <utility.scad>
use <dovetail.scad>
include <dimensions.scad>

module diffuser() {
    // This is the diffuser that slides onto the lamp. 
    // It consists of an extruded 2d shape, some dovetails and 2 end caps, which are hulls of the 2d shapes.
    D = Ddiffuser;

    mirror_x() { 
        // Main diffuser
        linear_extrude(get(Dsheet, "length")) diffuser2d(); 

        // Dovetails
        translate([get(Dlamp, "width") / 2 - get(D, "dovetail_offset"), get(D, "height"), 0]) 
        mirror([1, 0, 0]) 
        rotate([90, 0, 180]) 
        dovetail(get(Dsheet, "length") + get(Dlamp, "stoppers_thickness"), true, true);

    }
    // End caps
    for (i = [
        -get(Dlamp, "stoppers_thickness"),
        get(Dsheet, "length"),
    ]) {
        translate([0, 0, i]) 
        hull() 
        mirror_x() 
        linear_extrude(get(Dlamp, "stoppers_thickness")) {
            diffuser2d();
        }
    }
}

module diffuser2d() {
    // This is a 2D projection of the main body of the diffuser. But without the dovetails, because those are 3D.
    D = Ddiffuser;
    width = get(Dlamp, "width") / 2;

    // Bottom straight line
    square([
        width - get(D, "corner_radius"), 
        get(D, "thickness")
    ]);

    // Side straight line
    translate([
        width - get(D, "thickness"), 
        get(D, "corner_radius"), 
    0]) 
    square([
        get(D, "thickness"), 
        get(D, "height") - get(D, "corner_radius")
    ]);

    // Support for dovetails
    polygon([
        [width - get(D, "thickness"), get(D, "height")],
        [width - get(D, "thickness") - get(get(Ddovetail, "male"), "body_width") / 2, get(D, "height")],
        [width - get(D, "thickness"), get(D, "height") - get(get(Ddovetail, "male"), "body_width")],
    ]);

    // Rounded corners
    intersection() {
        translate([width, 0, 0])
        mirror([1, 0, 0])
        square(get(D, "corner_radius"));

        difference() {
            translate([width - get(D, "corner_radius"), get(D, "corner_radius"), 0]) circle(get(D, "corner_radius"));
            translate([width - get(D, "corner_radius"), get(D, "corner_radius"), 0]) circle(get(D, "corner_radius") - get(D, "thickness"));
        }
    }
}
