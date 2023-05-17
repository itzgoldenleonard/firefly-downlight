# Print the diffuser

1. Print the diffuser in the same orientation as it will hang (big face towards the build plate). Use support on the rounded corners
2. Remove the support and use a deburring tool or knife to remove any sharp edges on the *half dovetails*. Optionally sand the rounded corners to make them look proper nice.

# Print the lamp mount

1. Print the lamp mount with the biggest face towards the build plate and the locking nubs facing away from the build plate. Dont use any support
2. Remove any sharp edges around the dovetails with a deburring tool or knife and try to insert a male mount into each of the mounts on the part, once they fit well the part is done

# Make the lamp part

1. Cut a 200mmx30mm sheet of 1mm metal (or whatever you specified in `dimensions.scad`). I've had the best luck with using an angle grinder, but a rotary tool with a cutting disc attachment works well too, it's just slower. If you have access to a CNC plasma (or powerful laser) cutter that would probably be the best option though. You can use the [`sheet_template`](../CAD/tools/sheet_template.scad) to help test the fit and score the right shape onto your metal sheet
2. Make sure that the sheet is as flat as possible. Your cutting probably left some nasty edges that need to be sanded away and chances are that your sheet is a little bit bent. Use a known flat surface and carefully bend it with your hands until it's as flat as you can possibly get it (or use a surface grinder if you have access to one). The flatness of the final lamp depends entirely on the flatness of the sheet
3. Print the lamp part in the same orientation as it will hang with the dovetail mounts pointing away from the build plate. Pause the print right before it starts printing the honeycomb grid that covers the sheet
4. Insert the sheet and continue printing, integrating the metal sheet into the plastic part. This is the trickiest part of the whole process, I suggest you read the [tips and tricks](./Tips%20and%20tricks.md) document for more info about how to do this successfully.
5. Remove sharp edges around the dovetail and test fit every mount individually with a female mount to make sure they fit well. Then do a test fit with the whole lamp mount and use sandpaper or a knife to get them to fit well together.
6. Drill and/or burn a hole through the lamp and sheet to pass the power wires though. The location depends on where the wires come out of the surface you're mounting the lamp to
7. Cut 2 lengths of LED strip and attach them to either long side of the sheet
8. Solder power wires to the LED strips and pass them through the hole from the previous step. Connect the 2 LED strips together with 2 14mm long wires. Be very careful not to touch the plastic part with your hot soldering iron, it will evaporate and leave ugly marks. Give the surface a good clean with an alcohol drenched cotton swab.
9. Attach a connector to the power wires coming out of the lamp and to the wires coming out of the bottom of the cabinet (or wherever you're mounting the lamp)
10. Test the connection

# Assembly

1. Mark out the location on the bottom of the cabinet where you intend to place the lamp
2. Slide the diffuser onto the lamp, it might require a few light bonks with a rubber mallet, it's meant to be tight
3. Apply copious amounts of magic tape to the flat face of the lamp mount and peel the protective plastic off of the sticky side. Be careful that the tape doesnt extend over the edges though, that will make it much harder to get the lamp on and off.
4. Put the lamp mount on top of the lamp in the correct place, dont attach it properly, then the tape wont stick well enough, but be careful that it stays in the right place. Line up the lamp with your markings on the bottom of the cabinet making sure not to touch the sticky tape to the cabinet yet. Once you're sure that it's straight and lined up right apply pressure on the sticky tape and remove the lamp. Now put some pressure on the lamp mount so that the tape can stick as well as possible.
5. Slide the lamp onto the lamp mount until it clicks in place. This might also require a rubber mallet if your cabinet (or lamp) isnt perfectly flat, that's okay it's plenty durable (it can hold several kgs, I tested it).
