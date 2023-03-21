$fa = 1;
$fs = $preview ? 1 : 0.15;

use <lamp.scad>

// Which part to make
PART = "lamp"; // [ mount, lamp ]
// TODO: Make this customizer affect the actual parts, not the mount

lamp();
