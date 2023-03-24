use <utility.scad>
use <mount.scad>
include <dimensions.scad>

module lamp_mount() {
    // Makes the mount that gets attached to the cabinet or ceiling and holds the lamp
    // Mounted with adhesive but can be modified relatively easily to be screw-mountable
    D = get(Dmount, "female");
    dovetail_height = get(get(Ddovetail, "female"), "head_height") + get(get(Ddovetail, "female"), "body_height");

    // Mounts
    for (i = mounts_pos) { translate([0, i, 0]) mount_female(); }
    // Base
    translate([
        -get(D, "width") / 2,   // Center on X
        mounts_pos[0],          // Start at the beginning of the first mount
        dovetail_height         // Attached above the dovetails
    ])
    cube([
        get(D, "width"), 
        mounts_pos[len(mounts_pos) - 1] - mounts_pos[0],  // The position of the last mount in the list - the offset of the base itself
        get(D, "height") - dovetail_height
    ]);
}
