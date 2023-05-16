/* This is a special lamp mount that attaches to helping hands for soldering
 * Turns out that without the diffuser these lamps are actually also great for soldering,
 * they just need to be held in the right place, which is exactly what this little part does
 * I dont know if it works with all models of helping hands, mine is from fixpoint. But hey,
 * that's nothing a pair of calipers and some variable changing cant fix in a few minutes
 */
$fa = 1;
$fs = $preview ? 1 : 0.15;
use <../utility.scad>
use <../mount.scad>
include <../dimensions.scad>

// Ball mount
ball_diameter = 7.2;
// Bonding cube
cube_length = 10 + get(mount_female, "width") / 2;
translate([0, -ball_diameter / 2, 0]) cube([cube_length, ball_diameter, ball_diameter]);
// Connecting cylinder, allowing for free adjustment without buming into the cube
cylinder_height = 3.8;
translate([cube_length, 0, ball_diameter / 2]) rotate([0, 90, 0]) cylinder(h = cylinder_height, d = 4.4);
// Ball head
translate([cube_length + cylinder_height + ball_diameter / 2 - 1, 0, ball_diameter / 2]) sphere(d = ball_diameter);

// Lamp mount
translate([0, -get(mount_general, "length") / 2, -get(mount_female, "height")])
mount_female();
