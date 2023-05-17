/* This is a template that you can use to precisely score out the right shape
 * on a piece of sheet metal to cut the sheet in the correct shape
 * When you have cut you can also use it to measure that your cut sheet
 * will actually fit into the lamp and make the needed adjustments before it's too late
 */

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
