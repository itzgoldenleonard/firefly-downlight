# Design files for the firefly downlight

This project is entirely made in OpenSCAD. Let me let you in on a little secret: *Openscad is pretty bad for projects of this size*. The code quality probably couldn't be much better, I've spent a long time making it as readable as possible, but I've had to get pretty hacky to get everything to work together. I'll walk you through how it all works on a high level though, if you want more detail the code itself is either pretty self explanatory or explained with comments.

## 1. Selecting the parts

It all starts in `main.scad`. This is the file you'll wanna open in OpenSCAD. There are 3 parts to a complete lamp, you can select which one you want in the customizer window in OpenSCAD. They are as follows:
- `mount` aka *lamp mount* is the part that you stick or screw to the bottom of wherever you want the lamp to hang
- `lamp` is the part that holds the metal sheet with the LED strips and wiring
- `diffuser` is the part that slides into the lamp part and prevents you from burning out your eyeballs by looking directly at the LEDs

## 2. The dimensions file

All the different files need access to a bunch of dimensions, many of which need to be shared across multiple different files. So all of the dimensions are put in the single single `dimensions.scad` file that's included (run) at the start of every other file. If you wanna change some measurements, the `dimensions.scad` file is your one stop shop. Some things might break if you change certain variables too much, so always verify that the model turned out the way you actually wanted if you change anything in `dimensions.scad`.

The dimension variables are all prefixed with D and similar dimensions are grouped together in a hashmap (called object by json) like structure. There's a function in the `utility.scad` file called `get` that can extract values of the variables inside the hashmap like structures. This is the hacky stuff I was talking about.

## 3. The lamp mount part

The code for the *lamp mount* is inside `lamp_mount.scad`. It's a relatively simple part and it only consists of primitives and a few *female mounts*. 

The distinction is between *lamp mount* and just *mount*, the *lamp mount* is the entire part that you actually print, but the *mount* (in `mount.scad`) is the sub part with the dovetails, which can be either male or female, in this case it's female. 

The mount actually also consists of a custom module called *dovetail* from the file `dovetail.scad`

## 4. The lamp part

The code for the *lamp* part is inside the aptly named `lamp.scad` file. It's considerably more complicated, it also has some *mounts*, these ones are male. 

Inside of the part is a metal *sheet*, which is obviously not 3d printed. The *sheet* is covered with some honeycomb mesh from an external library called `lib/honeycomb.scad`.

It also has some cutouts that the *diffuser* can slide into. These are actually the same dovetails (from `dovetail.scad`) that the *mounts* use, just cut in half. And that's about it.

## 5. The diffuser

The *diffuser* whose code is in `diffuser.scad` is the easiest part. It's pretty much just a single extruded 2d sketch with some *half dovetails* from `dovetail.scad` on the tips. It slides into the matching half dovetails on the *lamp* with only a single visible seam.
