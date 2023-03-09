$fa = 1;
$fs = $preview ? 1 : 0.15;

// Female
difference() {
    union() {
        translate([-3.5, 0, 0]) cube([7, 2.5, 10]);
        translate([(3.5 + 0.5) / 2, 0.3, 2]) sphere(d = 1.5);
        translate([(3.5 + 0.5) / -2, 0.3, 2]) sphere(d = 1.5);
        translate([-3.5, 0, -1]) cube([7, 2.5, 1]);
    }
    dovetail_female(10);
}

// Male
difference() {
    translate([-3.5, -1.5, 0]) cube([7, 1.5, 10]);
    rotate([0, 90, 0]) translate([-2, 0.3, 1]) cylinder(h = 3.5 - 1, d = 1.7);
    rotate([0, -90, 0]) translate([2, 0.3, 1]) cylinder(h = 3.5 - 1, d = 1.7);
}
dovetail_male(10);

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
    head_height = 0.9;
    body_width = 2;
    body_height = 0.8;
    // Calculated variables
    head_width = body_width + 2 * (head_height + 0.15);
    height = head_height + body_height;

    linear_extrude(length)
    polygon([
        [-body_width / 2, 0],
        [-body_width / 2, body_height],
        [-head_width / 2, height],
        [head_width / 2, height],
        [body_width / 2, body_height],
        [body_width / 2, 0],
    ]);
}
