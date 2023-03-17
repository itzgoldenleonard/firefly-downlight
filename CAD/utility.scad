// Hashmap function
function get(hashmap, key) = [ for (i = hashmap) if (i[0] == key) i[1] ][0];
// Utility functions
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]]; // From scad-utils
function flip_sign_x(list) = [ for (i = list) [ i[0] * -1, i[1] ] ];
module mirror_x() {
    for (i = [0, 1]) { mirror([i, 0, 0]) {
        children();
    }}
}
