$fa = 1;
$fs = $preview ? 1 : 0.15;

//dovetail_mount_bottom();
dovetail_mount_top();

/*
dovetail_male(10);
translate([0, 5, 0]) dovetail_female(10);
translate([6, 0, 0]) dovetail(10, true);
translate([6, 5, 0]) dovetail(10, false);
*/

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

        rotate([-90, 180, 0]) dovetail_female(25);
        // Middle dovetails
        for (i = [0, 1]) {
            mirror([i, 0, 0]) {
                translate([middle_dovetail_offset, 0, 0]) rotate([-90, 180, 0]) dovetail_female(25);
                translate([width / 2 + 2.4 / 2, 0, 0]) rotate([-90, 180, 0]) dovetail_female(25);
            }
        }
    }
}

module dovetail_mount_bottom() {
    rotate([90, 0, 0]) dovetail_male(25);
    // Middle dovetails
    for (i = [0, 1]) {
        mirror([i, 0, 0]) {
            translate([(((30 + 14) / 2) - 1) / 2, 0, 0]) rotate([90, 0, 0]) dovetail_male(25);
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
                    dovetail_male(25);
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

module dovetail_female(length) {
    // Note: this is supposed to be a hole
    head_height = 1;
    body_width = 2.4;
    body_height = 0.5;
    // Calculated variables
    head_width = body_width + 2 * (head_height + 0.15);
    height = head_height + body_height;

    linear_extrude(length)
    translate([0, height, 0])
    rotate(180)
    polygon([
        [head_width / 2, 0],
        [-head_width / 2, 0],
        [-body_width / 2, head_height],
        [-body_width / 2, height],
        [body_width / 2, height],
        [body_width / 2, head_height]
    ]);
}

module dovetail_male(length) {
    head_height = 0.8;
    body_width = 2;
    body_height = 0.6;
    // Calculated variables
    head_width = body_width + 2 * (head_height + 0.15);
    height = head_height + body_height;

    linear_extrude(length)
    polygon([
        [-body_width / 2, 0],
        [-body_width / 2, body_height],
        [-body_width / 2 - head_height + 0.05, height - 0.2], // Not so pretty but it works although it depends on head_width not changing
        [-head_width / 2 + 0.2, height],
        [head_width / 2 - 0.2, height],
        [body_width / 2 + head_height - 0.05, height - 0.2],
        [body_width / 2, body_height],
        [body_width / 2, 0],
    ]);
}

module dovetail(length, male = false) {
    // Makes a dovetail, female is default, male can be toggled on. The female one is meant to be used subtractively
    //                   Male  Female
    head_height = male ? 0.9 : 1  ;
    body_width  = male ? 2   : 2.4;
    body_height = male ? 0.6 : 0.5;
    // Calculated variables
    head_width = body_width + 2 * (head_height + 0.15);
    height = head_height + body_height;

    path = male ? [
    ] : [
        [body_width / 2, 0],
        [body_width / 2, body_height],
        [head_width / 2, height],
        [-head_width / 2, height],
        [-body_width / 2, body_height],
        [-body_width / 2, 0],
    ];

    linear_extrude(length)
    polygon(path);
}
