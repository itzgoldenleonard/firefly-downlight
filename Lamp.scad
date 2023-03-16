$fa = 1;
$fs = $preview ? 1 : 0.15;
// Which part to make
PART = "lamp"; // [ mount, lamp ]
// TODO: Make this customizer affect the actual parts, not the mount

mount();

module mount() {
    // This module is just a wrapper containing the shared variables between the two parts that I don't want to be global
    // Sheet
    sheet_width = 30;
    // General
    locking_nubs_position = 2;
    // Lamp
    lamp_width = sheet_width + 14; // TODO: I still need to specify exactly where those 14mm come from
    lamp_wall_thickness = 2;
    // Mount
    mount_width = lamp_width + (-lamp_wall_thickness - 0.2) * 2;
    mount_length = 25;
    mount_thickness = 1 + 1.5; // The first 1mm is solid, the female dovetail is 1.5mm

    if (PART == "mount") {
        mount_female(
            length = mount_length, 
            width = mount_width, 
            height = mount_thickness,
            locking_nubs_position = locking_nubs_position,
            lamp_width = lamp_width
        );
    } else { 
        mount_male(
            length = mount_length,
            width = lamp_width,
            wall_thickness = lamp_wall_thickness,
            mount_thickness = mount_thickness,
            locking_nubs_position = locking_nubs_position
        ); 
    }
}

module mount_male(length, width, wall_thickness, mount_thickness, locking_nubs_position) {
    // Creates a single mounting piece which is part of the lamp, slides into the single_mount
    // Consists of a base cube with holes for the locking nubs cut into it. Then the dovetails are added. And the walls, which are just cubes with a half dovetail sticking out of their sides
    base_height = 2; // Doesn't include the height of the walls or the dovetails, also NOT FINAL

    difference() {
        // Base cube
        translate([-width / 2, 0, -base_height]) cube([width, length, base_height]);
        // Locking nub holes
        nub_distribution(width) {
            dimension = 1.7;
            translate([-dimension / 2, locking_nubs_position, 0.3]) 
            rotate([90, 0, 90]) 
            cylinder(h = dimension, d = dimension);
        }
    }

    // Dovetails
    dovetails_distribution(width) {
        dovetail(length, true);
    }
    // Walls
    mirror_x() {
        translate([width / 2 - wall_thickness, 0, 0]) {
            cube([wall_thickness, length, mount_thickness]);
            male_dovetail_body_width = 2; // This is dependent on another variable but has to be changed manually if the other one is
            translate([male_dovetail_body_width / 2, 0, 0]) dovetail(length, true, true);
        }
    }
}

module mount_female(length, width, height, locking_nubs_position, lamp_width) {
    // Creates a single mounting piece that can be taped to the surface where the lamp should be mounted. A lamp would typically use multiple of these
    // It starts with a base cube that gets 3 dovetails and some side slits cut into it, after that the additive features go on, that's a back stop and the locking nubs
    back_stop_thickness = 1;

    difference() {
        // Base cube
        translate([-width / 2, 0, 0]) cube([width, length, height]);
        // Dovetails
        dovetails_distribution(lamp_width) {
            dovetail(length);
        }
        // Side slits
        mirror_x() {
            female_dovetail_body_width = 2.4; // This is dependent on another variable but has to be changed manually if the other one is
            translate([(width + female_dovetail_body_width) / 2, 0, 0]) 
            dovetail(length);
        }
    }
    // Back stop
    translate([-width / 2, -back_stop_thickness, 0]) cube([width, back_stop_thickness, height]);
    // Nubs
    nub_distribution(lamp_width) {
        translate([0, locking_nubs_position, 0.4]) sphere(d = 1.5);
    }
}

module dovetails_distribution(lamp_width, ratio = 1, middle_child = true) {
    // Makes 3 copies of the object passed to it in the pattern that the dovetails need to be in in the mount and consequently, on the lamp
    if (middle_child) children();
    mirror_x() {
        translate([(lamp_width / 2 - 1) / 2 * ratio, 0, 0]) // I don't know where -1 comes from
        children();
    }
}

module nub_distribution(lamp_width) {
    dovetails_distribution(lamp_width, 0.5, false) { // Here I set the ratio to 1/2 to get the nubs to be centered between the dovetails
        dovetails_distribution(lamp_width, 1, false) { // We need 2 sets of nubs
            children();
        }
    }
}

// TODO: Consider splitting this up into several files
module dovetail(length, male = false, half = false) {
    // Makes the dovetail that connects the mount to the lamp itself
    // This module makes both the male and female dovetail since the only thing that really varies between them is the dimensions
    // The whole part is just a 2d polygon that's linearly extruded to the given length
    // Dimensions:       Male  Female
    head_height = male ? 0.8 : 1  ;
    body_width  = male ? 2   : 2.4;
    body_height = male ? 0.6 : 0.5;
    head_width = body_width + 2 * (head_height + (male ? -0.05 : 0.15));
    // Calculated variables
    height = head_height + body_height;

    // This vector is actually only contains the half of the points on the positive side of the X-axis, it is effectively mirrored about the axis a little later
    path = [
        [body_width / 2, 0],
        [body_width / 2, body_height],
        male ? [head_width / 2, height - 0.2] : [head_width / 2, height], // I can't tell it to skip for the female, so I'm just placing a point on top of the next one
        [head_width / 2, height],
        [0, height],
    ];

    rotate([-90, 180, 0])
    linear_extrude(length)
    if (half) { polygon(concat(path, [[0, 0]])); }
    else { polygon(concat(path, reverse(flip_sign_x(path)))); }
    // I reverse the sign of the x coordinates of all the points in the `path` vector and put them in the right order with the reverse function to do the mirroring. Like the native mirror function it doesnt create a copy, so I need to concat the mirrored point vector with the original.
}

// Utility functions
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]]; // From scad-utils
function flip_sign_x(list) = [ for (i = list) [ i[0] * -1, i[1] ] ];
module mirror_x() {
    for (i = [0, 1]) { mirror([i, 0, 0]) {
        children();
    }}
}
