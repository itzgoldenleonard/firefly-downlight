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
    [ "width", 30 ],
    [ "length", 200 ],
    [ "thickness", 1 ],
];

Dlamp = [
    [ "width", get(Dsheet, "width") + 14 ], // TODO: I still need to specify exactly where those 14mm come from
];

// Mount
mount_general = [
    [ "length", 25 ],
    [ "locking_nubs_position", 2 ],
];

mount_male = [
    [ "wall_thickness", 2 ],
    [ "base_height", 2 ],
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

