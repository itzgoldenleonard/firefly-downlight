use <utility.scad>

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

module dovetail(length, male = false, half = false) {
    // Makes the dovetail that connects the mount to the lamp itself
    // This module makes both the male and female dovetail since the only thing that really varies between them is the dimensions
    // The whole part is just a 2d polygon that's linearly extruded to the given length
    D = get(Ddovetail, male ? "male" : "female");
    // Calculated variables
    head_width = get(D, "body_width") + 2 * (get(D, "head_height") + (male ? -0.05 : 0.15));
    height = get(D, "head_height") + get(D, "body_height");

    // This vector is actually only contains the half of the points on the positive side of the X-axis, it is effectively mirrored about the axis a little later
    path = [
        [get(D, "body_width") / 2, 0],
        [get(D, "body_width") / 2, get(D, "body_height")],
        male ? [head_width / 2, height - 0.2] : [head_width / 2, height], // I can't tell it to skip for the female, so I'm just placing a point on top of the next one
        [head_width / 2, height],
        [0, height],
    ];

    rotate([-90, 180, 0])
    linear_extrude(length)
    if (half) { polygon(concat(path, [[0, 0]])); }
    else { polygon(concat(path, reverse(flip_sign_x(path)))); }
    // I reverse the sign of the x coordinates of all the points in the `path` vector and put them in the right order with the reverse function to do the mirroring. Like the native mirror function it doesnt create a copy, so I need to concat the mirrored point vector with the original.
}
