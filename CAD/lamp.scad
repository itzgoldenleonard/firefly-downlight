use <utility.scad>
use <mount.scad>
use <dovetail.scad>
include <dimensions.scad>


module lamp() {
    // Right now this module is quite sktechy
    D = Dlamp;

    difference() {
        union() {
            // Base cube
            translate([-get(D, "width") / 2, 0, -get(mount_male, "base_height")]) cube([get(D, "width"), get(Dsheet, "length"), get(mount_male, "base_height")]); // I need to preserve the nub holes, Also this needs to be honeycombed
            // Mounts
            translate([0, get(get(Dmount, "general"), "length") + 2, 0]) mount_male();
            translate([0, 100, 0]) mount_male(); // put it in between those two
            translate([0, get(Dsheet, "length") - get(get(Dmount, "general"), "length"), 0]) mount_male();

            // Stoppers
            translate([-get(D, "width") / 2, -get(D, "stoppers_thickness"), -5.5 + get(get(Dmount, "female"), "height")]) cube([get(D, "width"), get(D, "stoppers_thickness"), 5.5]);
            translate([-get(D, "width") / 2, get(Dsheet, "length"), -5.5 + get(get(Dmount, "female"), "height")]) cube([get(D, "width"), get(D, "stoppers_thickness"), 5.5]);

            // Walls
            mirror_x() {
                translate([get(Dlamp, "width") / 2 - get(get(Dmount, "male"), "wall_thickness"), 0, 0]) 
                cube([get(get(Dmount, "male"), "wall_thickness"), get(Dsheet, "length"), get(get(Dmount, "female"), "height")]);
            }
        }
        // Sheet cutout
        sheet_offset = 1; // Bad name, needs to go in the actual dimensions, not final
        sheet_lip = 0; // Same as the line above
        translate([-get(Dsheet, "width") / 2, -1.5, - sheet_offset - get(Dsheet, "thickness")]) 
        cube([get(Dsheet, "width"), get(Dsheet, "length"), get(Dsheet, "thickness")]);
        translate([-get(Dsheet, "width") / 2 + sheet_lip, 0, - sheet_offset - get(Dsheet, "thickness")]) 
        mirror([0, 0, 1])
        cube([get(Dsheet, "width") - (sheet_lip * 2), get(Dsheet, "length"), 10]);

        // Dovetails for diffuser
        mirror_x() {
            translate([19, -get(D, "stoppers_thickness"), -get(mount_male, "base_height")]) // Needs to be centered in it's face
            dovetail(get(Dsheet, "length") + get(D, "stoppers_thickness"), false, true);
        }
    }
}
