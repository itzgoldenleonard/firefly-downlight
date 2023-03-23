use <../utility.scad>
include <../dimensions.scad>

difference() {
    wall_thickness = 5;
    height = 2.5;
    union() {
        // Walls
        translate([-wall_thickness, -wall_thickness, 0])
        cube([get(Dsheet, "width") + wall_thickness * 2, get(Dsheet, "length") + wall_thickness * 2, height]);
        // Extra ridge for lining up
        cube([get(Dsheet, "width") + wall_thickness, get(Dsheet, "length") + wall_thickness, height + get(Dsheet, "thickness")]);
    }
    // Cutout for sheet
    cube([get(Dsheet, "width"), get(Dsheet, "length"), height + get(Dsheet, "thickness")]);
}
