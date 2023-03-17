use <utility.scad>
include <dovetail.scad>

// These variables have to be in another file
// Sheet
sheet_width = 30;
// Lamp
lamp_width = sheet_width + 14; // TODO: I still need to specify exactly where those 14mm come from

general = [
    [ "length", 25 ],
    [ "locking_nubs_position", 2 ],
];

male = [
    [ "wall_thickness", 2 ],
    [ "base_height", 2 ],
];

female = [
    [ "width", lamp_width + (-get(male, "wall_thickness") - 0.2) * 2],
    [ "height", 1 + get(get(Ddovetail, "female"), "head_height") + get(get(Ddovetail, "female"), "body_height")],
    [ "back_stop_thickness", 1 ],
];

Dmount = [
    [ "general", general],
    [ "male", male],
    [ "female", female],
];

module mount_male() {
    // Creates a single mounting piece which is part of the lamp, slides into the single_mount
    // Consists of a base cube with holes for the locking nubs cut into it. Then the dovetails are added. And the walls, which are just cubes with a half dovetail sticking out of their sides
    D = get(Dmount, "male");
    Dgen = get(Dmount, "general");

    difference() {
        // Base cube
        translate([-lamp_width / 2, 0, -get(D, "base_height")]) cube([lamp_width, get(Dgen, "length"), get(D, "base_height")]);
        // Locking nub holes
        nub_distribution() {
            dimension = 1.7;
            translate([-dimension / 2, get(Dgen, "locking_nubs_position"), 0.3]) 
            rotate([90, 0, 90]) 
            cylinder(h = dimension, d = dimension);
        }
    }

    // Dovetails
    dovetails_distribution() {
        dovetail(get(Dgen, "length"), true);
    }
    // Walls
    mirror_x() {
        translate([lamp_width / 2 - get(D, "wall_thickness"), 0, 0]) {
            cube([get(D, "wall_thickness"), get(Dgen, "length"), get(get(Dmount, "female"), "height")]);
            translate([get(get(Ddovetail, "male"), "body_width") / 2, 0, 0]) dovetail(get(Dgen, "length"), true, true);
        }
    }
}

module mount_female() {
    // Creates a single mounting piece that can be taped to the surface where the lamp should be mounted. A lamp would typically use multiple of these
    // It starts with a base cube that gets 3 dovetails and some side slits cut into it, after that the additive features go on, that's a back stop and the locking nubs
    D = get(Dmount, "female");
    Dgen = get(Dmount, "general");

    difference() {
        // Base cube
        translate([-get(D, "width") / 2, 0, 0]) cube([get(D, "width"), get(Dgen, "length"), get(D, "height")]);
        // Dovetails
        dovetails_distribution() {
            dovetail(get(Dgen, "length"));
        }
        // Side slits
        mirror_x() {
            translate([(get(D, "width") + get(get(Ddovetail, "female"), "body_width")) / 2, 0, 0]) 
            dovetail(get(Dgen, "length"));
        }
    }
    // Back stop
    translate([-get(D, "width") / 2, -get(D, "back_stop_thickness"), 0]) cube([get(D, "width"), get(D, "back_stop_thickness"), get(D, "height")]);
    // Nubs
    nub_distribution() {
        translate([0, get(Dgen, "locking_nubs_position"), 0.4]) sphere(d = 1.5);
    }
}

module dovetails_distribution(ratio = 1, middle_child = true) {
    // Makes 3 copies of the object passed to it in the pattern that the dovetails need to be in in the mount and consequently, on the lamp
    if (middle_child) children();
    mirror_x() {
        translate([(lamp_width / 2 - 1) / 2 * ratio, 0, 0]) // I don't know where -1 comes from
        children();
    }
}

module nub_distribution() {
    dovetails_distribution(0.5, false) { // Here I set the ratio to 1/2 to get the nubs to be centered between the dovetails
        dovetails_distribution(1, false) { // We need 2 sets of nubs
            children();
        }
    }
}
