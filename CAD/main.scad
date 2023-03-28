$fa = 1;
$fs = $preview ? 1 : 0.15;

use <lamp.scad>
use <lamp_mount.scad>
use <diffuser.scad>

// Which part to make
PART = "lamp"; // [ mount, lamp, diffuser ]

if ( PART == "lamp" ) { lamp(); } 
else if (PART == "mount") { lamp_mount(); }
else { diffuser(); }
