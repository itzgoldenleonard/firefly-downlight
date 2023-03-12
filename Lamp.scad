$fa = 1;
$fs = $preview ? 1 : 0.15;

dovetail_mount_bottom();
dovetail_mount_top();

// TODO: Clean up all of this code a bunch
module dovetail_mount_top() {
    width = 30 + 14 - 2 * 2 - 0.2 * 2;
    middle_dovetail_offset = (((30 + 14) / 2) - 1) / 2;

    difference() {
        union() {
            translate([-width / 2, 0, 0]) cube([width, 25, 1 + 1.5]);
            translate([-width / 2, -1, 0]) cube([width, 1, 1 + 1.5]);
            for (i = [0, 1]) {
                mirror([i, 0, 0]) {
                    // Nubs
                    translate([middle_dovetail_offset / 2, 2, 0.3]) sphere(d = 1.5);
                    translate([middle_dovetail_offset * 1.5, 2, 0.3]) sphere(d = 1.5);
                }
            }
        }

        rotate([-90, 180, 0]) dovetail(25);
        // Middle dovetails
        for (i = [0, 1]) {
            mirror([i, 0, 0]) {
                translate([middle_dovetail_offset, 0, 0]) rotate([-90, 180, 0]) dovetail(25);
                translate([width / 2 + 2.4 / 2, 0, 0]) rotate([-90, 180, 0]) dovetail(25);
            }
        }
    }
}

module dovetail_mount_bottom() {
    rotate([90, 0, 0]) dovetail(25, true);
    // Middle dovetails
    for (i = [0, 1]) {
        mirror([i, 0, 0]) {
            translate([(((30 + 14) / 2) - 1) / 2, 0, 0]) rotate([90, 0, 0]) dovetail(25, true);
        }
    }
    //#translate([(((30 + 14) / 2) - 1) / -2, 0, 0]) rotate([90, 0, 0]) dovetail_male(25);
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
    // Makes a dovetail, female is default, male can be toggled on. The female one is meant to be used subtractively
    //                   Male  Female
    head_height = male ? 0.8 : 1  ;
    body_width  = male ? 2   : 2.4;
    body_height = male ? 0.6 : 0.5;
    // Calculated variables
    head_width = body_width + 2 * (head_height + (male ? -0.05 : 0.15));
    height = head_height + body_height;

    path = [
        [body_width / 2, 0],
        [body_width / 2, body_height],
        male ? [head_width / 2, height - 0.2] : [head_width / 2, height], // I can't tell it to skip for the female, so I'm just placing a point on top of the next one
        [head_width / 2, height],
    ];

    linear_extrude(length)
    polygon(concat(path, reverse(flip_sign_x(path))));
}

function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]]; // From scad-utils
function flip_sign_x(list) = [ for (i = list) [ i[0] * -1, i[1] ] ];
