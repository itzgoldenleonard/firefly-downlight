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
            translate([0, get(get(Dmount, "general"), "length") + 2, 0]) mount_male();
            translate([0, 100, 0]) mount_male(); // TODO: offset it to the correct amount
            translate([0, get(Dsheet, "length") - get(get(Dmount, "general"), "length"), 0]) mount_male();

            // Stoppers and walls, TODO: make it a little less jank
            translate([-get(D, "width") / 2, 0, 0]) { // Centering on X

                // Base honeycomb cube
                mirror([0, 0, 1])
                linear_extrude(height = 1) // TODO: The sheet offset
                honeycomb(get(D, "width"), get(Dsheet, "length"), 4.5, 0.8); // TODO: figure out these values, don't need to be parameterized though

                difference() {
                    translate([0, -get(D, "stoppers_thickness"), -get(mount_male, "base_height")])
                    cube([get(D, "width"), get(Dsheet, "length") + 2 * get(D, "stoppers_thickness"), get(mount_male, "base_height") + get(get(Dmount, "female"), "height")]);

                    translate([get(get(Dmount, "male"), "wall_thickness"), 0, -1]) // TODO: This 1 mm is the sheet offset, it needs to be parameterized
                    cube([get(D, "width") - get(get(Dmount, "male"), "wall_thickness") * 2, get(Dsheet, "length"), 1 + get(get(Dmount, "female"), "height")]);
                }
            }
        }
        // Sheet cutout
        sheet_offset = 1; // TODO: make a better name, TODO: parameterize properly, TODO: check the value again
        sheet_lip = 3; // TODO: make a better name, TODO: parameterize properly, TODO: check the value again
        translate([-get(Dsheet, "width") / 2, 0, - sheet_offset - get(Dsheet, "thickness")]) 
        cube([get(Dsheet, "width"), get(Dsheet, "length"), get(Dsheet, "thickness")]);
        translate([-get(Dsheet, "width") / 2 + sheet_lip, 0, - sheet_offset - get(Dsheet, "thickness")]) 
        mirror([0, 0, 1])
        cube([get(Dsheet, "width") - (sheet_lip * 2), get(Dsheet, "length"), 10]);

        // Dovetails for diffuser
        mirror_x() {
            translate([19, -get(D, "stoppers_thickness"), -get(mount_male, "base_height")]) // TODO: Needs to be centered in it's face
            dovetail(get(Dsheet, "length") + get(D, "stoppers_thickness"), false, true);
        }
    }
}
