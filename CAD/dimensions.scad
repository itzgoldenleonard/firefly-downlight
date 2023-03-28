Ddovetail = [
    [ "male",
        [
            [ "head_height", 0.8 ],
            [ "body_width" , 2   ],
            [ "body_height", 0.6 ],
        ]
    ],
    [ "female",
        [
            [ "head_height", 1   ],
            [ "body_width" , 2.4 ],
            [ "body_height", 0.5 ],
        ]
    ],
];

Dsheet = [
    [ "width", 30 ], // 10mm for each LED strip, 4mm of space between them, 3mm on each side for the lips
    [ "length", 200 ],
    [ "thickness", 1 ],
    [ "offset", 1 ], // This is the thickness of material above the sheet
    [ "lip_width", 3], // Per lip
    [ "lip_thickness", 2],
];

Dlamp = [
    [ "width", get(Dsheet, "width") + 1 * 4 + 5 ], // 1mm on each side of the half dovetails + the approximate width of a dovetail
    [ "base_height", get(Dsheet, "offset") + get(Dsheet, "thickness") + get(Dsheet, "lip_thickness") ],
    [ "stoppers_thickness", 1.5 ],
];

// Mount
mount_general = [
    [ "length", 25 ],
    [ "locking_nubs_position", 2 ],
];

mount_male = [
    [ "wall_thickness", 2 ],
    [ "tape_thickness", 0.4], // Extra wall height
];

mount_female = [
    [ "width", get(Dlamp, "width") + (-get(mount_male, "wall_thickness") - 0.2) * 2],
    [ "height", 1 + get(get(Ddovetail, "female"), "head_height") + get(get(Ddovetail, "female"), "body_height")],
    [ "back_stop_thickness", 1 ],
];

Dmount = [
    [ "general", mount_general],
    [ "male", mount_male],
    [ "female", mount_female],
];

mounts_pos = [
    get(get(Dmount, "general"), "length") + 2,
    get(Dsheet, "length") / 2,
    get(Dsheet, "length") - get(get(Dmount, "general"), "length"),
];

Ddiffuser = [
    [ "height", 20 ],
    [ "corner_radius", 5 ],
    [ "thickness", 1 ],
    [ "dovetail_offset", 1 ],
];
