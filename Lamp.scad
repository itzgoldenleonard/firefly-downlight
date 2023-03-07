// Female end
/*
for (i = [0, 1]) {
    mirror([i, 0, 0]) translate([-6, 0, 0]) rotate([90, 0, 0]) snap_fit_female(10);
}
translate([-9, -10, -2]) cube([18, 10, 2]);
*/

// Male end
for (i = [0, 1]) {
    mirror([i, 0, 0]) translate([6 - 2.5, 0, 0]) rotate([-90, 0, 0]) snap_fit_male(10);
}
translate([-3.5, 0, 0]) cube([7, 10, 2]);


module snap_fit_female(length) {
    // This is the part that doesnt bend
    // https://en.wikipedia.org/wiki/Snap-fit#Cantilever
    body_width = 3;
    head_height = 3;
    head_width = 2.5;

    linear_extrude(length) union() {
        translate([-body_width, 0, 0]) square([body_width, head_height * 2]);
        polygon([
            [0, head_height], 
            [head_width, head_height], 
            [0, head_height * 2]
        ]);
    }
}

module snap_fit_male(length) {
    // This part bends
    body_width = 0.8;
    head_height = 3;
    head_width = 2.5;
    epsilon = 0.3;

    linear_extrude(length) union() {
        translate([-body_width, 0, 0]) square([body_width, head_height * 2]);
        polygon([
            [0, head_height + epsilon],
            [head_width, head_height + epsilon],
            [0, head_height * 2]
        ]);
    }
}
