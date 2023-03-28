use <utility.scad>
use <mount.scad>
use <dovetail.scad>
use <lib/honeycomb.scad>
include <dimensions.scad>


module lamp() {
    D = Dlamp;

    difference() {
        lamp_body();
        sheet_cutout();
        // Dovetails for diffuser
        mirror_x() {
            translate([
                get(D, "width") / 2 - 1,         // 1mm from the side of the lamp
                -get(D, "stoppers_thickness"),   // It needs to go though the stopper on 1 side so that you can actually slide in the diffuser
                -get(D, "base_height")           // It needs to start at the very bottom of the lamp (on the z axis)
            ]) // TODO: I probably wanna use that 1mm in the diffuser later
            dovetail(
                get(Dsheet, "length") + get(D, "stoppers_thickness"), // Compensate for going through that stopper earlier
                false,                                                // Female
                true                                                  // Half dovetail to save space
            );
        }
    }
}

module lamp_body() {
    // Makes the body of the lamp without any of the cutouts
    // It consists of 3 objects. 
    // 1. A base cube with a hole in it for the mounts
    // 2. The mounts
    // 3. Honeycomb mesh for above the sheets
    D = Dlamp;

    inner_width = get(D, "width") - get(get(Dmount, "male"), "wall_thickness") * 2; // The width not including the walls

    // Base with hole for the mounts
    difference() {
        // Base cube
        translate([
            -get(D, "width") / 2,           // Centering on X
            -get(D, "stoppers_thickness"),  // The stoppers are there to keep the sheet from flying out the sides (and to look pretty)
            -get(D, "base_height")          // Below the XY plane is the "base" of the lamp, which holds the sheet and diffuser, above it is the mount 
        ])
        cube([
            get(D, "width"), 
            get(Dsheet, "length") + 2 * get(D, "stoppers_thickness"),    // The lamp is the same length as the sheet + the 2 stoppers that keep in the sheet
            get(D, "base_height") + get(get(Dmount, "female"), "height") + get(get(Dmount, "male"), "tape_thickness") // The base is below the XY plane and above it needs to fit into the female mount
        ]);

        // Hole for the mounts
        translate([
            -inner_width / 2,      // Center X
            0, 
            -get(Dsheet, "offset") // This is to make room for the honeycomb mesh that's added later
        ])
        cube([
            inner_width, 
            get(Dsheet, "length"), 
            get(Dsheet, "offset") + get(get(Dmount, "female"), "height") + get(get(Dmount, "male"), "tape_thickness")
        ]);
    }

    // Mounts and honeycomb mesh
    for (i = [0:len(mounts_pos) - 1]) {    // Iterating over the mounts_pos array to make several mounts
        translate([0, mounts_pos[i], 0]) { // in the different positions specified in the array
            // Mounts
            mount_male();

            // Honeycomb mesh
            mirror([0, 1, 0])            // Make it go towards negative Y (origin) instead of positive
            translate([
                -inner_width / 2,        // Center on X
                0,
                -get(Dsheet, "offset")   // Lower down so that it touches the sheet
            ])
            linear_extrude(height = get(Dsheet, "offset"))
            honeycomb(
                inner_width,             // Width
                i == 0 ? mounts_pos[i] : // If we're on the first mount make the length extend all the way to the origin (start of the lamp)
                    (-mounts_pos[i - 1] + mounts_pos[i] - get(get(Dmount, "general"), "length")), 
                                         // Otherwise make it extend to the end of the previos mount generated
                4.6,                     // Hexagon gap width
                0.8                      // Wall thickness of the mesh (2 * the width of the nozzle)
            );
        }
    }
}

module sheet_cutout() {
    // Hole for the sheet and the LEDs on the sheet
    D = Dlamp;

    mirror([0, 0, 1]) translate([   // This part needs to go downwards
        -get(Dsheet, "width") / 2,  // Center on X
        0, 
        get(Dsheet, "offset")       // It needs to have some material on top of it
    ]) {
        // Sheet itself
        cube([get(Dsheet, "width"), get(Dsheet, "length"), get(Dsheet, "thickness")]);

        // Make the face of the sheet accesible
        translate([get(Dsheet, "lip_width"), 0, 0])
        cube([
            get(Dsheet, "width") - 2 * get(Dsheet, "lip_width"), 
            get(Dsheet, "length"), 
            10 // Long enough to always go through
        ]);
    }
}
