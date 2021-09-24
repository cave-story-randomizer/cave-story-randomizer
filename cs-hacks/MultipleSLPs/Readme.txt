Author: Enlight

DUNC NOTE: flag range changed from 4008 through 4015 to 2888 through 2919 in rando
also: skip the second patch it's not needed and also bugged

Instructions:
1. Backup your .exe, then patch your .exe with the patches in patches.txt.
2. Learn how to use the hack and setup your teleporters with the demonstration mod and the information below.
3. Make a similar system in your mod.


Important Files:
Patches.txt - The first patch allows you to edit where teleporter menus draw. The 2nd one just fixes a graphic bug with slots 6 and 7.

OOBFlagGen.jar - What helps you generate the flags for the top framerects. Input address 49DF09 and the value will be how many pixels down you want
the mod to START drawing the teleporter icons IN HEXADECIMAL. The rows are IN DECIMAL 0, 16, 32, 48, 64... etc. In HEXADECIMAL it's 0, 10, 20, 30 etc.
Keep it in bytes. You will then copy the flags it generates (should be just over flag 4000) to use in your level TSC (explained below)

StageSelect.tsc - Example of how you can setup having different location names for different teleporters.
This is just normal TSC using flags. The game is hardcoded to run events 1001-1007 for the slots, but flagjumps can change what it says.

The TSC file for Arthur's House (Pens1.tsc) - Example of how to setup everything else for the teleporters (explained below)


~~~~~



Please open the demonstration mod in a CS editor of you choice to see how the tsc all comes together.
The most important events though are the ones for displaying the teleporter.
One of these events is shown below with comments.

#0100
<KEY
<FL-4008<FL-4009<FL-4010<FL-4011<FL-4012<FL-4013<FL-4014<FL-4015
// What you generate with OOBFlagGen, tells the game the top framerect of where to draw the teleporter images.

<FL+5001<FL-5002<FL-5003<FL-5004
// These are used like normal flags, telling StageSelect.tsc what to call the teleporter options.

<PS+0001:0110<PS+0002:0111<PS+0003:0112<PS+0004:0113
// These are overwriting the teleporter slots to run events 110-113, this is what's saved to profile.dat
but you can (probably) ignore that and just overwrite it every time before you display the tele menu.

<SLP<END
// Displays the teleporter menu.



~~~~~




If you have any other questions you can just contact me (Enlight) because I'm not good at writing tutorials at 4:30 AM
<Cave Story ~ Doukutsu Monogatari> (C) Studio Pixel 2004
