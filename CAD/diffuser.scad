use <utility.scad>
use <dovetail.scad>
include <dimensions.scad>

module diffuser() {
    D = Ddiffuser;

    mirror_x() { 
        // Main diffuser
        linear_extrude(30) diffuser2d(); 

        // Dovetails
        translate([get(Dlamp, "width") / 2 - get(D, "dovetail_offset"), get(D, "height"), 0]) 
        mirror([1, 0, 0]) 
        rotate([90, 0, 180]) 
        dovetail(30, true, true);

    }
    // End caps
    translate([0, 0, -get(Dlamp, "stoppers_thickness")]) hull() mirror_x() linear_extrude(get(Dlamp, "stoppers_thickness")) {
        diffuser2d();
    }
}

module diffuser2d() {
    D = Ddiffuser;

    // Bottom straight line
    square([get(Dlamp, "width") / 2 - get(D, "corner_radius"), get(D, "thickness")]);
    // Side straight line
    translate([get(Dlamp, "width") / 2 - get(D, "thickness"), get(D, "corner_radius"), 0]) square([get(D, "thickness"), get(D, "height") - get(D, "corner_radius")]);
    // Support for dovetails
    polygon([
        [get(Dlamp, "width") / 2 - get(D, "thickness"), get(D, "height")],
        [get(Dlamp, "width") / 2 - get(D, "thickness") - get(get(Ddovetail, "male"), "body_width") / 2, get(D, "height")],
        [get(Dlamp, "width") / 2 - get(D, "thickness"), get(D, "height") - get(get(Ddovetail, "male"), "body_width")],
    ]);

    // Rounded corners
    difference() {
        translate([get(Dlamp, "width") / 2 - get(D, "corner_radius"), get(D, "corner_radius"), 0]) circle(get(D, "corner_radius"));
        translate([get(Dlamp, "width") / 2 - get(D, "corner_radius"), get(D, "corner_radius"), 0]) circle(get(D, "corner_radius") - get(D, "thickness"));

        polygon([
            [0, get(D, "thickness")],
            [get(Dlamp, "width") / 2 - get(D, "corner_radius"), get(D, "thickness")],
            [get(Dlamp, "width") / 2 - get(D, "thickness"), get(D, "corner_radius")],
            [get(Dlamp, "width") / 2 - get(D, "thickness"), get(D, "height")],
            [0, get(D, "height")],
        ]);
    }
}
