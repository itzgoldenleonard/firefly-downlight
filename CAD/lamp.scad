use <utility.scad>
use <mount.scad>
use <dovetail.scad>
use <lib/honeycomb.scad>
include <dimensions.scad>


module lamp() {
    // Right now this module is quite sktechy
    D = Dlamp;

    difference() {
        union() {
            // Mounts
            mounts_pos = [
                get(get(Dmount, "general"), "length") + 2,
                get(Dsheet, "length") / 2,
                get(Dsheet, "length") - get(get(Dmount, "general"), "length"),
            ];

            for (i = [0:len(mounts_pos) - 1]) {
                translate([0, mounts_pos[i], 0]) {
                    mount_male();

                    // Base honeycomb cube
                    mirror([0, 1, 0])
                    translate([-get(D, "width") / 2, 0, -get(Dsheet, "offset")])
                    linear_extrude(height = get(Dsheet, "offset"))
                    honeycomb(get(D, "width"), i == 0 ? mounts_pos[i] : (-mounts_pos[i - 1] + mounts_pos[i] - get(get(Dmount, "general"), "length")), 4.6, 0.8);
                }
            }

            // Stoppers and walls, TODO: make it a little less jank
            translate([-get(D, "width") / 2, 0, 0]) { // Centering on X
                difference() {
                    translate([0, -get(D, "stoppers_thickness"), -get(D, "base_height")])
                    cube([get(D, "width"), get(Dsheet, "length") + 2 * get(D, "stoppers_thickness"), get(D, "base_height") + get(get(Dmount, "female"), "height")]);

                    translate([get(get(Dmount, "male"), "wall_thickness"), 0, -get(Dsheet, "offset")])
                    cube([get(D, "width") - get(get(Dmount, "male"), "wall_thickness") * 2, get(Dsheet, "length"), 1 + get(get(Dmount, "female"), "height")]);
                }
            }
        }
        // Sheet cutout
        translate([-get(Dsheet, "width") / 2, 0, - get(Dsheet, "offset") - get(Dsheet, "thickness")]) 
        cube([get(Dsheet, "width"), get(Dsheet, "length"), get(Dsheet, "thickness")]);
        translate([-get(Dsheet, "width") / 2 + get(Dsheet, "lip_width"), 0, - get(Dsheet, "offset") - get(Dsheet, "thickness")]) 
        mirror([0, 0, 1])
        cube([get(Dsheet, "width") - (get(Dsheet, "lip_width") * 2), get(Dsheet, "length"), 10]);

        // Dovetails for diffuser
        mirror_x() {
            translate([get(D, "width") / 2 - 1, -get(D, "stoppers_thickness"), -get(D, "base_height")]) // TODO: I probably wanna use that 1mm in the diffuser later
            dovetail(get(Dsheet, "length") + get(D, "stoppers_thickness"), false, true);
        }
    }
}

