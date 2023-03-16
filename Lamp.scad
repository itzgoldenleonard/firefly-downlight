$fa = 1;
$fs = $preview ? 1 : 0.15;
// Which part to make
PART = "mount"; // [ mount, lamp ]

//dovetail_mount_bottom();
parts();

module parts() { // Wow that name sure could be improved
    // This module is just a wrapper containing the shared variables between the two parts that I don't want to be global
    // Sheet
    sheet_width = 30;
    sheet_length = 200;
    // General
    locking_nubs_position = 2;
    // Lamp
    lamp_width = sheet_width + 14; // I still need to specify exactly where those 14mm come from
    lamp_wall_thickness = 2;
    // Mount
    mount_width = lamp_width + (-lamp_wall_thickness - 0.2) * 2;
    mount_length = 25;
    mount_thickness = 1 + 1.5; // The first 1mm is solid, the female dovetail is 1.5mm

    if (PART == "mount") {
        single_mount(
            length = mount_length, 
            width = mount_width, 
            height = mount_thickness,
            locking_nubs_position = locking_nubs_position,
            lamp_width = lamp_width
        );
    } else {
        // NYI
    }
}

module single_mount(length, width, height, locking_nubs_position, lamp_width) {
    // Creates a single mounting piece that can be taped to the surface where the lamp should be mounted. A lamp would typically use multiple of these
    // It starts with a base cube that gets 3 dovetails and some side slits cut into it, after that the additive features go on, that's a back stop and the locking nubs
    dovetail_rotation = [-90, 180, 0];
    back_stop_thickness = 1;

    difference() {
        // Base cube
        translate([-width / 2, 0, 0]) cube([width, length, height]);
        // Dovetails
        dovetails_distribution(lamp_width) {
            rotate(dovetail_rotation) dovetail(length);
        }
        // Side slits
        mirror_x() {
            female_dovetail_body_width = 2.4; // This is dependent on another variable but has to be changed manually if the other one is
            translate([(width + female_dovetail_body_width) / 2, 0, 0]) 
            rotate(dovetail_rotation) dovetail(length);
        }
    }
    // Back stop
    translate([-width / 2, -back_stop_thickness, 0]) cube([width, back_stop_thickness, height]);
    // Nubs
    dovetails_distribution(lamp_width, 0.5, false) { // Here I set the ratio to 1/2 to get the nubs to be centered between the dovetails
        dovetails_distribution(lamp_width, 1, false) { // We need 2 sets of nubs
            translate([0, locking_nubs_position, 0.4]) sphere(d = 1.5);
        }
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

// TODO: Clean up this module a bunch
module dovetail_mount_bottom() {
    rotate([90, 0, 0]) dovetail(25, true);
    // Middle dovetails
    mirror_x() {
        translate([(((30 + 14) / 2) - 1) / 2, 0, 0]) rotate([90, 0, 0]) dovetail(25, true);
    }
    // Walls
    for (i = [0, 1]) {
        width = 2;
        height = 1.5 + 1;

        mirror([i, 0, 0]) union() {
            translate([(30 + 14) / 2 - width, -25, 0]) cube([width, 25, height]);
            translate([(30 + 14) / 2 + 1 - width, 0, 0]) rotate([90, 0, 0]) {
                difference() {
                    dovetail(25, true);
                    cube([5, height, 25]);
                }
            }
        }
    }
    difference() {
        // Just for reference for now
        translate([(30 + 14) / -2, -25, -2]) cube([30 + 14, 25, 2]);

        // Lock nub holes
        for (i = [0, 1]) {
            cylinder_h = (((30 + 14) / 2) - 1) / 2 - 2;

            mirror([i, 0, 0]) {
                translate([2 / 2, -2, 0.3]) rotate([90, 0, 90]) cylinder(h = cylinder_h, d = 1.7);
                translate([(2 / 2) * 3 + cylinder_h, -2, 0.3]) rotate([90, 0, 90]) cylinder(h = cylinder_h, d = 1.7);
            }
        }
    }
}

module dovetail(length, male = false) {
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
    ];

    linear_extrude(length)
    polygon(concat(path, reverse(flip_sign_x(path))));
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
