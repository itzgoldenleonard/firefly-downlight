$fa = 1;
$fs = $preview ? 1 : 0.15;

use <lamp.scad>
use <lamp_mount.scad>

// Which part to make
PART = "lamp"; // [ mount, lamp ]

if ( PART == "lamp" ) { lamp(); } 
else { lamp_mount(); }
